function handle_input_sel(event, selnum)
	for selnum=1,g_selcount do
        	if(g_sel[selnum] ~= nil) then
                	local msg = { time_stamp = event.time_stamp, item = itemsindex["Sel"..selnum.."_"..g_sel[selnum]], value = 1 }
                	remote.handle_input(msg)
                	g_sel[selnum] = nil
                	g_updateall = true
        	end
        end
end

function handle_input_select(event)
	for itemname,value in pairs(g_select) do
		local msg = { time_stamp = event.time_stamp, item = itemsindex[itemname], value = value }
		remote.handle_input(msg)
		g_select[itemname] = nil
	end
end

function handle_input_scrollend(event)
	local msg_scrollend = remote.match_midi(MIDI_IN_SCROLLEND, event)
	if(msg_scrollend ~= nil) then
		g_scrolling = false
		g_updateall = true
		return true
	end
end

function handle_input_lightshow(event)
	for buttonname,buttonmidi in pairs(buttons) do
		local button = remote.match_midi(buttonmidi.." zz", event)
		if(button ~= nil and button.z > 0) then
			return true
		end
                local button = remote.match_midi(buttonmidi.." 00", event)
                if(button ~= nil) then
                        if(g_lightshowtime + 500 < remote.get_time_ms()) then
				g_lightshow = 0
				g_updateall = true
                        end
                        return true
                end
        end
end

function handle_input_kong(event, button)
	if(g_scopetext == "Kong" and get_current_page() == "Main") then
		local buttonname = get_button_name(button)
		local padnote = button_to_padnote[buttonname]
		if(padnote ~= nil) then
			remote.handle_input({ time_stamp = event.time_stamp, item = 1, value = 1, note = padnote, velocity = button.z })
			return true
		end
	end
end

function handle_input_keyboard(event, button)
	local velocity = get_veloctity(button.z)
	if(get_current_page() == "Keyboard" and get_current_kbdpage() == "Kbd") then
		buttonname = get_button_name(button)
		keynote = button_to_keynote[buttonname]
		if(keynote ~= nil) then
			remote.handle_input({ time_stamp = event.time_stamp, item = 1, value = 1, note = (keynote+12*g_basekey), velocity = velocity })
			return true
		end
	elseif(get_current_page() == "Keyboard" and get_current_kbdpage() == "Drum") then
		local buttonname = get_button_name(button)
		local padnote = button_to_fullpadnote[buttonname]
		if(padnote ~= nil) then
			remote.handle_input({ time_stamp = event.time_stamp, item = 1, value = 1, note = padnote, velocity = velocity })
			return true
		end
	end
end

function handle_input_item(event, button)
	local buttonname = get_button_name(button)
	local row = get_button_row(buttonname)
	local col = get_button_col(buttonname)
	local itemname = get_item_by_button(buttonname)
	if(button.z > 0) then
		if(buttonname ~= itemname) then
			local itemtype = get_item_type(itemname)
			if(itemtype == "Fader" or itemtype == "BigFader" or itemtype == "Drawbar") then
				local value = get_item_bvmap(itemname)[row]
				local msg = { time_stamp = event.time_stamp, item = itemsindex[itemname], value = value }
				remote.handle_input(msg)
				return(true)
			elseif(itemtype == "Knob") then
				local oldvalue = remote.get_item_value(itemsindex[itemname])
				local value

				if(get_knob_type(itemname) == 'H') then
					value = get_item_bvmap(itemname)[col]
					if((oldvalue < 64 and col == 5) or (oldvalue > 64 and col == 4)) then
						value = 64
					end
				else
					value = get_item_bvmap(itemname)[row]
					if((oldvalue > 64 and row == 5) or (oldvalue < 64 and row == 4)) then
						value = 64
					end
				end
				local msg = { time_stamp = event.time_stamp, item = itemsindex[itemname], value = value }
				remote.handle_input(msg)
				return(true)
			elseif(itemtype == "UDVButton" or itemtype == "UDHButton") then
				local value = 1
				if(is_up_udupbutton(buttonname, itemname)) then
					value = 1
				else
					value = -1
				end
				local msg = { time_stamp = event.time_stamp, item = itemsindex[itemname], value = value }
				remote.handle_input(msg)
				return(true)
			end
		end
	else
		local itemtype = get_item_type(itemname)
		if(itemtype == "Knob") then
			if(get_item_conf_map(itemname,g_colorscheme, get_current_page()).resetonrel) then
				local msg = { time_stamp = event.time_stamp, item = itemsindex[itemname], value = 64 }
				remote.handle_input(msg)
				return true
			end
		end
	end
end

function handle_input_helpmode(event, button)
	if(button.z == 0) then
		g_helpmode = false
		g_stopflashing = true
		g_scrollcolor = S_RED
		g_updateall = true
		local buttonname = get_button_name(button)
		local itemname = get_item_by_button(buttonname)

		if(itemname == "Button C1" or itemname == "Button C2") then
			g_scrolltext = g_scopetext
		elseif(itemname == "Button C3" or itemname == "Button C4") then
			g_scrolltext = remote.get_item_text_value(itemsindex["PatchName"])
		elseif(itemname == "Button C7") then
			g_scrolltext = get_current_page()
		elseif(itemname == "Button D8") then
			g_scrolltext = get_current_docpage()
		elseif(itemname == "Button C8") then
			g_valuemode = true
			g_startflashing = true
		else
			g_scrolltext = remote.get_item_name(itemsindex[itemname])
		end
		if(g_scrolltext == "") then
			g_scrolltext = get_item_conf_map(itemname, g_colorscheme, get_current_page()).helptext
			if(g_scrolltext == nil) then
				g_scrolltext = "Unknown"
			end
		end
		return true
	end
end

function handle_input_valuemode(event, button)
	if(button.z == 0) then
		g_valuemode = false
		g_stopflashing = true
		g_scrollcolor = S_YELLOW
		g_updateall = true
		local buttonname = get_button_name(button)
		local itemname = get_item_by_button(buttonname)

		if(itemname == "Button C1" or itemname == "Button C2") then
			g_scrolltext = remote.get_item_text_value(itemsindex["DeviceName"])
		elseif(itemname == "Button C8") then
			return true
		else
			g_scrolltext = tostring(remote.get_item_value(itemsindex[itemname]))
		end

		if(g_scrolltext == "") then
			g_scrolltext = "Unknown"
		end
		return true
	end
end

function handle_input_internalpage(event, button)
	if(string.match(get_current_page(), "Internal")) then
		local button_brightnessup = remote.match_midi(buttons["Button 7-8"].." zz", event)
		local button_brightnessdown = remote.match_midi(buttons["Button 8-8"].." zz", event)
		if(button_brightnessup ~= nil and button_brightnessup.z > 0) then
			if(g_brightness_new < 5) then
				g_brightness_new = g_brightness_new+1
			end
			return true
		elseif(button_brightnessdown ~= nil and button_brightnessdown.z > 0) then
			if(g_brightness_new > 1) then
				g_brightness_new = g_brightness_new-1
			end
			return true
		end
		local button_lightshow1 = remote.match_midi(buttons["Button 1-6"].." zz", event)
		if(button_lightshow1 ~= nil and button_lightshow1.z > 0) then
			g_lightshow = 1
			g_lightshowtime = remote.get_time_ms()
			g_updatetime = remote.get_time_ms()
			g_lightshowcycle = 1
			return true
		end
		local button_lightshow2 = remote.match_midi(buttons["Button 1-7"].." zz", event)
		if(button_lightshow2 ~= nil and button_lightshow2.z > 0) then
			g_lightshow = 2
			g_lightshowtime = remote.get_time_ms()
			g_updatetime = remote.get_time_ms()
			g_lightshowcycle = 1
			return true
		end
		local button_lightshow3 = remote.match_midi(buttons["Button 1-8"].." zz", event)
		if(button_lightshow3 ~= nil and button_lightshow3.z > 0) then
			g_lightshow = 3
			g_lightshowtime = remote.get_time_ms()
			g_updatetime = remote.get_time_ms()
			g_lightshowcycle = 1
			return true
		end
		local button_lightshow4 = remote.match_midi(buttons["Button 2-8"].." zz", event)
		if(button_lightshow4 ~= nil and button_lightshow4.z > 0) then
			g_lightshow = 4
			g_lightshowtime = remote.get_time_ms()
			g_updatetime = remote.get_time_ms()
			g_lightshowcycle = 1
			g_lightshowloop = 1
			return true
		end
	end
end

function handle_input_starthelpmode(event, button)
	buttonname = get_button_name(button)
	if(buttonname == 'Button C8') then
		g_helpmode = true
		g_startflashing = true
		g_updateall = true
		return true
	end
end

function handle_input_setveltomax(event, button)
	-- Change all remaining button input to velocity 127
	if(button.z > 0 ) then
		local midi = string.format("%02x %02x", button.x, button.y)
		local item = itemsindex[midi_to_button[midi]]
       		local msg = { time_stamp = event.time_stamp, item = item, value = 1, velocity = 127 }
		remote.handle_input(msg)
		return true
	end
end
