--[[
name: One Key Arp
description: Takes in a single Midi Note, generates a "chord"
(ie. collection of notes) but then play the chord as an arpeggio
author: synaesmedia

See : https://www.youtube.com/watch?v=MHo1FXyRvrA for tutorial
--]]

require "include/protoplug"


function dumpList(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. dumpList(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end


function pd(o)
  print(dumpList(o))
end


--[[

root2arp

given a root (MIDI note no),
- a timestep (offset between notes), and
- a chordTemplate (a list of intervals),
- produces a list of absolute notes and time offsets

eg.

root2arp(65, 50, {0,4,7,11})

=>

{ { 65,0,} ,{ 69,50,} ,{ 72,100,} ,{ 76,150,} ,}

--]]

function root2arp(root,timestep,chordTemplate)
	notes = {}
    t = 0
	for _,oset in ipairs(chordTemplate) do
		table.insert(notes,{root+oset,t})
        t = t + timestep
	end
	return notes
end


-- Constants
local CHORD_TEMPLATE = {0, 4, 7, 11}
local TIMESTEP = 50

local FUTURE_BUFFER = {}
NOTE_ON = 1
NOTE_OFF = 0

--[[

myNoteOn and myNoteOff take

futureBuffer ... a list of events that will happen in the future

- chan ... midi chan number
- root ... root (midi number)
- vel ... velocity

it uses root2arp, to then fill the futureBuffer with new events
in the form of tuples

- a noteOn tuple is : { 1,9,120,0,64,} {noteOnFlag, chan, note, time-offset, vel
- a noteOff tuple is : { 0,9,120,0 } {noteOffFlag, chan, note, time-offset

these functions are just concerned with adding these tuples to the futureBuffer

--]]

function myNoteOn(futureBuffer, chan, root, vel)
  arp = root2arp(root,TIMESTEP,CHORD_TEMPLATE)
  for k,v in ipairs(arp) do
    table.insert(futureBuffer,{NOTE_ON,chan,v[1],v[2],vel})
  end
end

function myNoteOff(futureBuffer, chan, root)
  arp = root2arp(root,TIMESTEP,CHORD_TEMPLATE)
  for k,v in ipairs(arp) do
    table.insert(futureBuffer,{NOTE_OFF,chan,v[1],v[2]})
  end
end

--[[

main processBlock called by DAW

 first we run through the midiBuf events ... which are all the
events received by the plugin, coming from the piano roll (or external keyboard)

 we take all these events and translate them into the format for our futureBuffer

 then we run through the futureBuffer.

 For each item in it,
   - if its time is zero, we convert it back into a system MIDI event which
   we place on the real midiBuf midi-buffer to be sent out to another instrument in
   the DAW. We also delete it from the futureBuffer

   - if its time is greater than zero (ie. it is still scheduled for some time in
   the future), then we decrement its time counter but leave it on the futureBuffer

--]]

function plugin.processBlock(samples, smax, midiBuf)

	-- analyse midi buffer and prepare an arp for each note
	for ev in midiBuf:eachEvent() do
		if ev:isNoteOn() then
			myNoteOn(FUTURE_BUFFER, ev:getChannel(), ev:getNote(), ev:getVel())
		elseif ev:isNoteOff() then
			myNoteOff(FUTURE_BUFFER, ev:getChannel(), ev:getNote())
		end
	end

	-- clear the midiBuf
	midiBuf:clear()

    -- if FUTURE_BUFFER has size > 0 (ie. isn't empty)
	if #FUTURE_BUFFER>0 then


	    -- loop through the FUTURE_BUFFER
		for k,v in ipairs(FUTURE_BUFFER) do
		    -- we get k = index numbers (STARTING AT 1)
		    -- and v = one of the tuples eg. { 1,9,120,0,64,}

		    -- test if this event is now current, v[4] is time

		    if v[4] < 1 then
		        -- it's ready to pop
		        -- make a real midi event
		        local mEv
		        -- but we need to know if it's a noteOn or noteOff event
		        if v[1] == NOTE_ON then
                    mEv = midi.Event.noteOn(v[2],v[3],v[5])
                else
                    mEv = midi.Event.noteOff(v[2],v[3])
                end
		        midiBuf:addEvent(mEv)
			    table.remove(FUTURE_BUFFER,k)
			else
			    -- it's still in the future,
			    -- so just decrement the time
			    v[4] = v[4]-1
			end
		end
	end
end
