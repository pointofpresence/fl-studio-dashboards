--[[
name: ProtoWave Synth
description: A demonstration synthesizer with wave-folding and phase modulation  
See https://www.youtube.com/watch?v=_M1nBN6kCME for details 
author: synaesmedia

Get Protoplug here : https://www.osar.fr/protoplug/

My series on programming it : https://www.youtube.com/watch?v=zkgYBoiQPek&list=PLuBDEereAQUxEb6hsnaeqXe3TX3IbGfPG
--]] 

require "include/protoplug"
local makeFilter = require "include/dsp/cookbook filters"

function freq_to_delta(f)
		local sr = plugin.isSampleRateKnown() and plugin.getSampleRate() or 44100
	    return 2*math.pi*f/sr
end
 
function make_env(a,d,s,r)
    o = {
        attack = a,
        decay = d,
        sustain = s,
        release = r,
        da = 1 / a,
        dd = (1-s) / d,
        dr = s / r,
        v = 0,
        stage = 3,
        
        set_attack = function(self,a)
            if a < 1 then a = 1 end
            self.attack = a
            self.da = 1/a
        end,
        
        set_decay = function(self,d)
            if d < 1 then d = 1 end
            self.decay = d
            self.dd = (1-self.sustain)/d
        end,
        
        set_sustain = function(self,s)
            self.sustain = s
        end,
        
        set_release = function(self,r)
            if r < 1 then r = 1 end
            self.release = r
            self.dr = self.sustain / r
        end,
                
        noteOn = function(self)
            self.stage = 0 -- go into attack stage
        end,
        
        noteOff = function(self)
            self.stage = 3 -- go into release stage            
        end,
        
        notePerm = function(self,v2)
            self.stage = 5 -- go into permanent on stage
            self.v = v2
        end,
        
        next = function(self)
            if self.stage == 0 then -- attack stage
                self.v = self.v + self.da
                if self.v >= 1 then self.stage = 1 end
                return self.v
            elseif self.stage == 1 then -- decay stage
                self.v = self.v - self.dd
                if self.v <= self.sustain then self.stage = 2 end
                return self.v
            elseif self.stage == 2 then -- sustain stage
                return self.v
            elseif self.stage == 3 then -- release stage
                self.v = self.v - self.dr
                if self.v <= 0 then self.stage = 4 end
                return self.v
            else 
                -- unknown stage, do nothing
                return self.v
            end
        end,
        
        }
    return o
end
        

function make_osc(init_freq, init_amp,init_th) 
    o = {
        freq=init_freq,
        amp=init_amp,
        delta=0.06,
        phase=0,
        threshold=init_th,
        
        pm_ratio=1,
        mod_phase=0,
 
        
        -----------------------------------------------
        next=function(self)
            local v = 1
            local s = math.sin(self.phase+math.sin(self.mod_phase))
		    if s > self.threshold then 
		        v = self.threshold - (s-self.threshold)
		        if v < 0 then
		           v = -v
		        end
	        else 
	            if s < -self.threshold then
	                v = -self.threshold + (-self.threshold-s)
	                if v > 0 then
	                   v = -v
	                end
	            else
	                v = s
	            end
	        end
	        
	        final = v*(1/self.threshold)
	        if (final > 1) then
	            final = 1
	        else 
	           if (final < -1) then
	             final = -1
	           end
	        end
	        
	        -- phase mod
	        
	        self.phase=self.phase+self.delta
	        self.mod_phase=self.mod_phase+(self.delta*self.pm_ratio) 
	        return final*self.amp
        end,
        -----------------------------------------------------
        
        set_freq=function(self,f)
            self.freq = f
            self.delta = freq_to_delta(f)
        end,
        set_amp=function(self,a)
            self.amp=a
        end,
 
        set_threshold=function(self,th)
            self.threshold=th
        end,
        set_midi_note = function(self,mn)
            a = 440 -- frequency of A (common value is 440Hz)
            n = (a / 32) * math.pow(2,((mn - 9) / 12))  -- (2 ** ((mn - 9) / 12))
            self:set_freq(n)
            self.phase = 0
        end,
        
        reset_mod_phase = function(self)
            self.mod_phase = 0
        end,
        set_pm_ratio=function(self,v)
            self.pm_ratio = v
        end
    }
    o:set_freq(init_freq) -- so that delta is initialized properly
    return o
end

local osc1 = make_osc(440,0.5,0.5)
local osc2 = make_osc(441,0.5,0.5)

local o12ratio = 1.001
local fold_threshold=1
local pm_ratio = 1

local lfo1 = make_osc(4,1,0.5)
local lfo_amp = 0

local env = make_env(1000, 5000, 0.5, 5000)


local theFilter = makeFilter
	{
	-- initialize filters with current param values
		type 	= "lp";
		f 		= 220;
		gain 	= 0;
		Q 		= 1;
	}

function plugin.processBlock(samples, smax, midiBuf)

    -- Handle Midi
	for ev in midiBuf:eachEvent() do
		if ev:isNoteOn() then
		    note = ev:getNote()
		    osc1:set_midi_note(note)
		    osc2:set_freq(osc1.freq*o12ratio)
		    env:noteOn()
		elseif ev:isNoteOff() then
		    env:noteOff()
		end	
	end

    -- Handle sound synthesis
    	osc1:set_pm_ratio(pm_ratio)
    	osc2:set_pm_ratio(pm_ratio)
	
	for i=0,smax do
	    vlfo = lfo1:next()        
	    osc1:set_threshold(fold_threshold)
	    osc2:set_threshold(fold_threshold)
	    
	v1 = osc1:next()
	v2 = osc2:next()
	v = (v1+v2)/2
	v = ((v*lfo_amp*vlfo)+(v*(1-lfo_amp)))/2

	v = v * env:next()

	filtered = theFilter.process(v)
	samples[0][i] = filtered 
		samples[1][i] = filtered
	end
end


plugin.manageParams {
	{
		name = "OSC1 Amplitude";
		changed = function(val)
		    osc1:set_amp(val) 
		end;
	};
		

	{
		name = "OSC2 Amplitude";
		changed = function(val)
		    osc2:set_amp(val) 
		end;
	};
		
	{
		name = "2:1 Freq Ratio";
		max = 2;
		changed = function(val)
		    o12ratio = val 
		end;
	};

    {
        name = "Attack";
        max = 10000;
        changed = function(val)
            env:set_attack(val)
        end;
    };


    {
        name = "Decay";
        max = 10000;
        changed = function(val)
            env:set_decay(val)
        end;
    };

    {
        name = "Sustain";
        changed = function(val)
            env:set_sustain(val)
        end;
    };

    {
        name = "Release";
        max = 100000;
        changed = function(val)
            env:set_release(val)
        end;
    };

-- 
    {
        name = "PM Ratio";
        min = 0;
        max = 5;
        changed = function(val)
            pm_ratio = val
        end;
    };
 
--

    {
        name = "Wavefolding Threshold";
        min = 1;
        max = 0;
        changed = function(val)
            fold_threshold = val;
        end;
    };

--
			
	{
		name = "LFO1 Amplitude";
		changed = function(val)
		    lfo_amp = val 
		end;
	};
		
	{
		name = "LFO1 Freq";
		changed = function(val)
		    lfo1:set_freq(val*val*1000)
		end;
	};
	{
	    name = "LFO1 Threshold";
	    min = 1;
	    max = 0;
	    changed = function(val)
	       lfo1:set_threshold(val)
	    end;
	};

--
    {
        name = "LPF Cutoff";
        min = 10;
		max = 15000;
		default = 440;
        changed = function(val)
            theFilter.update{f=val};
        end;
    };
    
    {
        name = "LFP Resonance";
        min = 0.1;
		max = 30;
		default = 1;
        changed = function(val)
            theFilter.update{Q=val};
        end;
    };

}
