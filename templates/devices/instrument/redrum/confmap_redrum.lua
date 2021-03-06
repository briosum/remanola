	["Redrum"]={
		["Default"]={
{% if lptype == "pro" %}
{% include "devices/instrument/redrum/pro/confmap_mainmenu.lua" %}
{% endif %}
		},
		["Index"]={
			-- Select Drum
			["Button 6-1"]={template="BOscPage"},
			["Button 6-2"]={template="BOscPage"},
			["Button 7-1"]={template="BOscPage"},
			["Button 7-2"]={template="BOscPage"},
			["Button 7-3"]={template="BOscPage"},
			["Button 7-4"]={template="BOscPage"},
			["Button 8-1"]={template="BOscPage"},
			["Button 8-2"]={template="BOscPage"},
			["Button 8-3"]={template="BOscPage"},
			["Button 8-4"]={template="BOscPage"},
		},
		["Main"]={
			-- Sequence Step and toggle selected drum step
			["Button 1-1"]={template="BStep"},
			["Button 1-2"]={template="BStep"},
			["Button 1-3"]={template="BStep"},
			["Button 1-4"]={template="BStep"},
			["Button 1-5"]={template="BStep"},
			["Button 1-6"]={template="BStep"},
			["Button 1-7"]={template="BStep"},
			["Button 1-8"]={template="BStep"},
			["Button 2-1"]={template="BStep"},
			["Button 2-2"]={template="BStep"},
			["Button 2-3"]={template="BStep"},
			["Button 2-4"]={template="BStep"},
			["Button 2-5"]={template="BStep"},
			["Button 2-6"]={template="BStep"},
			["Button 2-7"]={template="BStep"},
			["Button 2-8"]={template="BStep"},
			-- Drum Select
			["Button 3-1"]={template="BOscSel"},
			["Button 3-2"]={template="BOscSel"},
			["Button 4-1"]={template="BOscSel"},
			["Button 4-2"]={template="BOscSel"},
			["Button 4-3"]={template="BOscSel"},
			["Button 4-4"]={template="BOscSel"},
			["Button 5-1"]={template="BOscSel"},
			["Button 5-2"]={template="BOscSel"},
			["Button 5-3"]={template="BOscSel"},
			["Button 5-4"]={template="BOscSel"},
			-- Edit Steps, Accent
			["Button 3-5"]={template="BPerformancePage"},
			["Button 3-6"]={template="BPerformancePage"},
			-- Edit Accent, color is handled elsewhere
			["Button 4-6"]={template="BRedOnOff"},
			-- Edit Steps
			["UDVButton 5-8_6-8"]={template="UDPerf"},
			-- Flam
			["UDVButton 7-7_8-7"]={template="UDPerf"},
			["Button 8-8"]={template="BRedOnOff"},
			-- Run
			["Button 3-8"]={template="BRun"},
			-- Play, Solo, Mute
			["Button 6-5"]={template="BMute"},
			["Button 7-5"]={template="BSoloRevival"},
			["Button 8-5"]={template="BPlaySel"},
			["Play"]={
				["Button 6-1"]={template="BPad"},
				["Button 6-2"]={template="BPad"},
				["Button 7-1"]={template="BPad"},
				["Button 7-2"]={template="BPad"},
				["Button 7-3"]={template="BPad"},
				["Button 7-4"]={template="BPad"},
				["Button 8-1"]={template="BPad"},
				["Button 8-2"]={template="BPad"},
				["Button 8-3"]={template="BPad"},
				["Button 8-4"]={template="BPad"},
			},
			["Solo"]={
				["Button 6-1"]={template="BSoloRevival"},
				["Button 6-2"]={template="BSoloRevival"},
				["Button 7-1"]={template="BSoloRevival"},
				["Button 7-2"]={template="BSoloRevival"},
				["Button 7-3"]={template="BSoloRevival"},
				["Button 7-4"]={template="BSoloRevival"},
				["Button 8-1"]={template="BSoloRevival"},
				["Button 8-2"]={template="BSoloRevival"},
				["Button 8-3"]={template="BSoloRevival"},
				["Button 8-4"]={template="BSoloRevival"},
			},
			["Mute"]={
				["Button 6-1"]={template="BMute"},
				["Button 6-2"]={template="BMute"},
				["Button 7-1"]={template="BMute"},
				["Button 7-2"]={template="BMute"},
				["Button 7-3"]={template="BMute"},
				["Button 7-4"]={template="BMute"},
				["Button 8-1"]={template="BMute"},
				["Button 8-2"]={template="BMute"},
				["Button 8-3"]={template="BMute"},
				["Button 8-4"]={template="BMute"},
			},
		},
		["Performance"]={
			-- Pattern enable
			["Button 1-1"]={template="BRedOnOff"},
			["Button 1-3"]={template="BRedOnOff"},
			-- Resolution, Shuffle
			["UDVButton 7-1_8-1"]={template="FPerf"},
			["UDVButton 7-4_8-4"]={template="FFreq"},
			["Button 8-5"]={template="BRedOnOff"},
			-- Pattern 1-4
			["Button 2-1"]={template="BPerformancePage"},
			["Button 2-2"]={template="BPerformancePage"},
			["Button 2-3"]={template="BPerformancePage"},
			["Button 2-4"]={template="BPerformancePage"},
			-- Pattern 5-8
			["Button 3-1"]={template="BPerformancePage"},
			["Button 3-2"]={template="BPerformancePage"},
			["Button 3-3"]={template="BPerformancePage"},
			["Button 3-4"]={template="BPerformancePage"},
			-- Bank A-D
			["Button 5-1"]={template="BPerformancePage"},
			["Button 5-2"]={template="BPerformancePage"},
			["Button 5-3"]={template="BPerformancePage"},
			["Button 5-4"]={template="BPerformancePage"},
			["Fader 8"]={template="FVol"},
		},
		["Drum *"]={
			["Button 1-1"]={template="BPad"},
			["Button 1-2"]={template="BMute"},
			["Button 1-3"]={template="BSolo"},
                        -- Goto Drum edit/main
                        ["Button 2-1"]={template="BOscPage"},
                        ["Button 3-1"]={template="BOscPage"},
			-- 
			["UDVButton 5-4_6-4"]={template="UDPerf"},
			["Fader 5"]={template="FEffect"},
			["Fader 6"]={template="FEffect"},
			["Knob V7"]={template="FPan"},
			["Fader 8"]={template="FVol"},
{% if lptype == "pro" %}
{% include "devices/instrument/redrum/pro/confmap_submenu_drum.lua" %}
{% endif %}
		},
		["Drum * Edit"]={
			["Button 1-1"]={template="BPad"},
			["Button 1-2"]={template="BMute"},
			["Button 1-3"]={template="BSolo"},
                        -- Goto Drum edit/main
                        ["Button 2-1"]={template="BOscPage"},
                        ["Button 3-1"]={template="BOscPage"},
			-- 
			["UDVButton 5-2_6-2"]={template="UDOsc"},
			["UDVButton 5-4_6-4"]={template="UDPerf"},
			["Fader 5"]={template="FFreq"},
			["Knob V6"]={template="FOsc"},
			["Knob V7"]={template="FOsc"},
			["Knob V8"]={template="FPerf"},
{% if lptype == "pro" %}
{% include "devices/instrument/redrum/pro/confmap_submenu_drum.lua" %}
{% endif %}
		},
	},
