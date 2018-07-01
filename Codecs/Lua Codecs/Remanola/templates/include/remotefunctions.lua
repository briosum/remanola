function remote_init()
	init_buttons()
	init_udbuttons()
	init_sel()
	init_itemsindex()
	init_miditobutton()

	remote.define_items(items)
	remote.define_auto_inputs(inputs)
end

function remote_release_from_use()
	local ret_events={}

	return ret_events;
end

function remote_prepare_for_use()
	local ret_events={}
	if(lptype == 'pro') then
		table.insert(ret_events, remote.make_midi(MIDI_OUT_PRO_PROGLAYOUT))
		table.insert(ret_events, remote.make_midi("f0 00 20 29 02 10 2b 00 00 05 46 f7"))
	else
		table.insert(ret_events, remote.make_midi(string.format("%s %02x", MIDI_OUT_DOUBLEBUFF, bit.bor(DBDISP0,DBUPDATE1,DBCOPY))))
	end

	return ret_events;
end

function remote_set_state(changed_items)
	for i,citemindex in ipairs(changed_items)do
		local citemname = items[citemindex].name

		g_updateall = true

		if(citemname ~= nil) then
			handle_changed_sel(citemindex, citemname)
			handle_changed_devicescope(citemindex, citemname)
			handle_changed_barposition(citemindex, citemname)
			handle_changed_barposition(citemindex, citemname)
			handle_changed_playingstep(citemindex, citemname)
			handle_changed_pagename(citemindex, citemname)
			handle_changed_subpagename(citemindex, citemname)
			handle_changed_kbdvel(citemindex, citemname)
			handle_changed_basekey(citemindex, citemname)
		end
	end
end

function remote_deliver_midi(maxbytes, port)
	local ret_events = {}

	if(g_stopflashing) then
		g_stopflashing = false
		g_flashing = false
		g_updateall = true
	end

	if(g_lightshow == 0 and not g_flashing) then
		if(g_updateall) then
			deliver_midi_buttons(ret_events)
			deliver_midi_sideled(ret_events)

			g_updateall = false
		end
	end

	deliver_midi_startflashing(ret_events)
	deliver_midi_brightness(ret_events)
	deliver_midi_scrolltext(ret_events)
	deliver_midi_endscroll(ret_events)
	deliver_midi_lightshow(ret_events)
	deliver_midi_transport(ret_events)
	deliver_midi_sel(ret_events)

	return ret_events
end

function remote_process_midi(event)
        local pad = "none"
        local pad_note = 0
        local pad_item = 0

	for s=1,g_selcount do
		handle_input_sel(event,s)
	end

	handle_input_select(event)
	handle_input_scrollend(event)

	if(g_lightshow > 0) then
		if(handle_input_lightshow(event)) then
			return(true)
		end
	end

	local button = remote.match_midi("xx yy zz", event)

	if(not g_helpmode and not g_valuemode and button ~= nil and (button.x == 0x90 or button.x == 0xb0)) then
		if(handle_input_kong(event, button)) then
			return(true)
		end

		if(handle_input_keyboard(event, button)) then
			return(true)
		end

		if(handle_input_item(event, button)) then
			return(true)
		end
	end
	
	if(g_helpmode and (button.x == 0x90 or button.x == 0xb0)) then
		if(handle_input_helpmode(event, button)) then
			return(true)
		end
	end

	if(g_valuemode and (button.x == 0x90 or button.x == 0xb0)) then
		if(handle_input_valuemode(event, button)) then
			return(true)
		end
	end

	if(string.match(get_current_page(), "Internal")) then
		if(handle_input_internalpage(event, button)) then
			return(true)
		end
	end

	local button_helpmode = remote.match_midi(buttons["Button C8"].." 00", event)
	if(button_helpmode ~= nil) then
		g_helpmode = true
		g_startflashing = true
		g_updateall = true
		return true
	end

	if(g_helpmode or g_valuemode) then
		return true
	end

	-- Change all remaining button input to velocity 127
	if(button ~= nil and (button.x == 0x90 or button.x == 0xb0) and button.z > 0 ) then
		local midi = string.format("%02x %02x", button.x, button.y)
		local item = itemsindex[midi_to_button[midi]]
		local msg = { time_stamp = event.time_stamp, item = item, value = 1, velocity = 127 }
		remote.handle_input(msg)
		return true
	end

	return false
end

function remote_probe(manufacturer,model,prober)
	local controlRequest="F0 7E 7F 06 01 F7"
	local controlResponse=string.format("F0 7E 00 06 02 00 20 29 %x 00 ?? ?? ?? ?? ?? ??  F7", DEVICE_ID)

	return {
                request=controlRequest,
                response=controlResponse
        }
end