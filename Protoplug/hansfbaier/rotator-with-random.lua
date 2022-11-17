--[[
name: Harmony Rotator
description: Inspired by Michael Brecker's use of the Oberheim Matrix Rotator.
author: hansfbaier@gmail.com
--]]

require "include/protoplug"

local debug = false

-- what kind of chord ?
local parallelVoices_ = { 0, -5 }
local rotatingVoices1 = { -17, -14, -15, -8 }
local rotatingVoices2 = { -10, -7, -8, -1 }
local rotatingVelocity = 1
local blockEvents = {}
local pendingNotes = {}

local randomizeParallel = false
local randomizeRotating = false
local rotateMode = "circle"

function setRotatePattern(val)
	if     "AutoAaron" == val then
		parallelVoices_ = { 0, -5 }
		rotatingVoices1 = { -17, -14, -15, -8 }
		rotatingVoices2 = { -10, -7, -8, -1 }
	elseif "ChordTypes" == val then
		parallelVoices_ = { 2, -5 }
		rotatingVoices1 = { -1, -2, -2 }
		rotatingVoices2 = { -8, -8, -9 }
	end
		
end

params = plugin.manageParams {
	{
		name = "RotatePattern";
		type = "list";
		values = {"AutoAaron"; "ChordTypes";};
		default = "AutoAaron";
		changed = setRotatePattern;
	};
	{
		name = "RotateMode";
		type = "list";
		values = {"circle"; "random";};
		default = "false";
		changed = function(val) rotateMode = val end;
	};
	{
		name = "Rotating Velocity Factor";
		min = 0.01;
		max = 1;
		default = 1;
		changed = function(val) rotatingVelocity=val end;
	};
	{
		name = "RandomizeParallel";
		type = "list";
		values = {"false"; "true";};
		default = "false";
		changed = function(val) randomizeParallel=(val == "true") end;
	};
	{
		name = "RandomizeRotating";
		type = "list";
		values = {"false"; "true";};
		default = "false";
		changed = function(val) randomizeRotating=(val == "true") end;
	};
	{
		name = "Debug";
		type = "list";
		values = {"false"; "true";};
		default = "false";
		changed = function(val) debug=(val == "true") end;
	};
}

local counter = 0
function parallelVoices()
		return {unpack(parallelVoices_)}
end

function rotatingVoices(the_counter)
	local result = {}
	local rotatingPos = (the_counter % #rotatingVoices1) + 1
	if (rotateMode == "random") then
		rotatingPos = math.random(1, #rotatingVoices1)
	end
	
	result[#result + 1] = rotatingVoices1[rotatingPos]

	rotatingPos = (the_counter % #rotatingVoices2) + 1
	if (rotateMode == "random") then
		rotatingPos = math.random(1, #rotatingVoices2)
	end

	result[#result + 1] = rotatingVoices2[rotatingPos]
	return result
end

function plugin.processBlock(samples, smax, midiBuf)
	blockEvents = {}
	-- analyse midi buffer and prepare a chord for each note
	for ev in midiBuf:eachEvent() do
		if ev:isNoteOn() and ev:getVel() > 0 then
			if debug then print("on " .. ev:getNote() .. "@" .. counter) end
			counter = counter + 1
			chordOn(ev)
		elseif ev:isNoteOff() then
			if debug then print("off " .. ev:getNote().. "@" .. counter) end
			chordOff(ev)
		elseif ev:isPitchBend() then
			table.insert(blockEvents, midi.Event.pitchBend(
				ev:getChannel(),
				ev:getPitchBendValue()))
		elseif ev:isControl() then
			table.insert(blockEvents, midi.Event.control(
				ev:getChannel(),
				ev:getControlNumber(),
				ev:getControlValue()))
		end	
	end

	-- fill midi buffer with prepared notes
	midiBuf:clear()
	if #blockEvents>0 then
		for _,e in ipairs(blockEvents) do
			midiBuf:addEvent(e)
			if debug and e:isNoteOn()  then print("noteon  @" .. e:getNote() .. " vel " .. e:getVel()) end
			if debug and e:isNoteOff() then print("noteoff @" .. e:getNote() .. " vel " .. e:getVel()) end
		end
	end
end

function chordOn(root)
	math.randomseed(os.clock()*100000000000)
	math.random(); math.random();
	
	if debug then print("randomize parallel: " .. tostring(randomizeParallel) .. "; randomize rotating: " .. tostring(randomizeRotating)) end
	
	local rootNote = root:getNote()
	pendingNotes[rootNote] = { }
	for _, offset in ipairs(parallelVoices(counter)) do
	    local randOffset = randomizeParallel and math.random(-1,1) or 0
	    local theNote = rootNote + offset + randOffset
		local onEv = midi.Event.noteOn(
			root:getChannel(), 
			theNote, 
			root:getVel())
		table.insert(blockEvents, onEv)
		table.insert(pendingNotes[rootNote], theNote)
	end
	for _, offset in ipairs(rotatingVoices(counter)) do
	    local randOffset = randomizeRotating and math.random(-1,1) or 0
	    local theNote = rootNote + offset + randOffset		local onEv = midi.Event.noteOn(
			root:getChannel(), 
			theNote, 
			root:getVel() * rotatingVelocity)
		table.insert(blockEvents, onEv)
		table.insert(pendingNotes[rootNote], theNote)
	end 
end

function chordOff(root)
	local rootNote = root:getNote()
	if pendingNotes[rootNote] ~= nil then
		for _, note in ipairs(pendingNotes[rootNote]) do
			local offEv = midi.Event.noteOff(
				root:getChannel(), 
				note)
			table.insert(blockEvents, offEv)
		end
	end
	pendingNotes[rootNote] = nil
end


-------------------------------------------------------------------------------- helpers

function concatArray(a, b)
	table.foreach(b,function(i,v) table.insert(a,v) end)
	return a
end

function print_r(arr, indentLevel)
    local str = ""
    local indentStr = "#"

    if(indentLevel == nil) then
        print(print_r(arr, 0))
        return
    end

    for i = 0, indentLevel do
        indentStr = indentStr.."\t"
    end

    for index,value in pairs(arr) do
        if type(value) == "table" then
            str = str..indentStr..index..": \n"..print_r(value, (indentLevel + 1))
        else 
            str = str..indentStr..index..": "..value.."\n"
        end
    end
    return str
end