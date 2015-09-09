--[[
	mtv.de 
	Copyright (C) 2015,  Jacek Jendrzej 'satbaby'

	License: GPL

	This program is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public
	License as published by the Free Software Foundation; either
	version 2 of the License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	General Public License for more details.

	You should have received a copy of the GNU General Public
	License along with this program; if not, write to the
	Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
	Boston, MA  02110-1301, USA.
]]

local glob = {}
local mtv_verrsion="mtv.de Version 0.2" -- Lua API Version: " .. APIVERSION.MAJOR .. "." .. APIVERSION.MINOR
local n = neutrino()
local conf = {}
local on="ein"
local off="aus"

function get_confFile()
	local confFile = "/var/tuxbox/config/mtv.conf"
	return confFile
end

function hideMenu(menu)
	if menu ~= nil then menu:hide() end
end

function setvar(k, v) 
	if v and #v > 0 then
		conf[k]=v
		conf.changed = true
	end
end

function set_bool_in_liste(k, v) 
	local i = tonumber(k)
	if v == on then
		glob.MTVliste[i].enabled=true
	else 
		glob.MTVliste[i].enabled=false
	end
end

function file_exists(file)
	local f = io.open(file, "rb")
	if f then f:close() end
	return f ~= nil
end

function saveConfig()
	if conf.changed then
		local config	= configfile.new()
		config:setString("path", conf.path)
		config:setBool  ("dlflag",conf.dlflag)
		config:setString("search", conf.search)
		config:saveConfig(get_confFile())
		conf.changed = false
	end
end

function loadConfig()
	local config	= configfile.new()
	config:loadConfig(get_confFile())
	conf.path = config:getString("path", "/media/sda1/movies/")
	conf.dlflag = config:getBool("dlflag", false)
	conf.search = config:getString("search", "Jessie J")
	conf.changed = false
end

function init()
	glob.mtv_search={}
	glob.mtv={
		{name = "Brandneu",url="http://www.mtv.de/musik"},
		{name = "Hitlist Germany - Top 100",url="http://www.mtv.de/charts/5-hitlist-germany-top-100"},
		{name = "MTV.de Videocharts",url="http://www.mtv.de/charts/8-mtv-de-videocharts"},
		{name = "Top 100 Jahrescharts 2013",url="http://www.mtv.de/charts/199-top-100-single-jahrescharts-2013"},
		{name = "Dance Charts",url="http://www.mtv.de/charts/6-dance-charts"},
		{name = "Deutsche Urban Charts",url="http://www.mtv.de/charts/9-deutsche-black-charts"},
	}
end

function info(captxt,infotxt, sleep)
	if captxt == mtv_verrsion and infotxt==nil then
		infotxt=captxt
		captxt="Information"
	end
	local msg, data = 0,0
	local h = hintbox.new{caption=captxt, text=infotxt}
	h:paint()
	if sleep then
		os.execute("sleep " .. sleep)
	else
		repeat
			msg, data = n:GetInput(500)
		until msg == RC.ok or msg == RC.home
	end
	h:hide()
end

function read_file(filename)
	if filename == nil then 
		print("Error: FileName  is empty") 
		return nil
	end
	local fp = io.open(filename, "r")
	if fp == nil then print("Error opening file '" .. filename .. "'.") return nil end
	local data = fp:read("*a")
	fp:close()
	return data
end

function getdata(url)
	local output = os.tmpname()
	os.execute("wget -q -U 'Mozilla/5.0' -O " .. output .." '".. url .. "'");
	local clip_page = read_file(output)
	os.remove(output)
	return clip_page
end

function getliste(url)
	local clip_page = getdata(url)
	if clip_page == nil then return nil end

	clip_page = string.match(clip_page,"window.pagePlaylist = %[(.-)%];")
	local json = require "json"
	local liste = {}
	for j in string.gmatch(clip_page, "(%{.id.-%})") do
		local jnTab = json:decode(j)
		if(jnTab.title and jnTab.subtitle and jnTab.riptide_image_id) then
			local pic = ""
			if jnTab.riptide_image_id then
				pic = "http://images.mtvnn.com/" .. jnTab.riptide_image_id .. "/306x172_"
			end
			jnTab.title=jnTab.title:gsub("&quot;",'"')
			jnTab.title=jnTab.title:gsub("&amp;",'&')
			table.insert(liste,{name=jnTab.title .. ": " .. jnTab.subtitle, url=jnTab.mrss,
			type=jnTab.video_type, logo=pic,enabled=conf.dlflag
			})
		end
	end
	return liste
end

function getvideourl(url)
	if url == nil then return nil end
	local video_url = nil
	local clip_page = getdata(url)
	if clip_page == nil then return nil end

	url  = clip_page:match("url='(.-)'")
	if url == nil then return nil end
	clip_page = getdata(url)
	local max_width = -1
	for  width,url in string.gmatch(clip_page, '<rendition.-width="(%d+).-<src>(.-)</src>') do
		if max_width < tonumber(width) and url then
			max_width = tonumber(width)
			video_url = url
		end
	end

	if video_url and video_url:sub(1,5) == "rtmpe" then
		video_url = "rtmp" .. video_url:sub(6,#video_url)
	else
	  print("########## Error ##########")
	  print(clip_page)
	  print("###########################")
	end
	if video_url and video_url:find("copyright_error") then
		info("Video Not Available", "Copyright Error\n" .. url)
	end
	return video_url
end

function godirectkey(d)
	local  _dkey = ""
	if d == 1 then
		_dkey = RC["red"]
	elseif d == 2 then
		_dkey = RC["green"]
	elseif d == 3 then
		_dkey = RC["yellow"]
	elseif d == 4 then
		_dkey = RC["blue"]
	elseif d < 14 then
		_dkey = RC[""..d - 4 ..""]
	elseif d == 14 then
		_dkey = RC["0"]
	else
		-- rest
		_dkey = ""
	end
	return _dkey
end

function action_exec(id)
	if id  then
		local i = tonumber(id)
		print(glob.MTVliste[i].url)
		local url = getvideourl(glob.MTVliste[i].url)
		if url then
			hideMenu(glob.menu_liste)
			n:PlayFile(glob.MTVliste[i].name, url,glob.MTVliste[i].type);
		end
	end
	return MENU_RETURN.EXIT_REPAINT
end

function gen_m3u_list(filename)
	local m3ufilename="/tmp/" .. filename .. ".m3u"

	local h = hintbox.new{caption="Info", text=filename .." - Playlist wird erstellt\n"..m3ufilename}
	h:paint()

	local m3ufile=io.open(m3ufilename,"w")
	m3ufile:write("#EXTM3U name=" .. filename .. "\n")
        for k, v in ipairs(glob.MTVliste) do
		local url = getvideourl(v.url)
		if url then
			if v.name == nil then
				v.name = "NoName"
			end
			local extinf = ", "
-- 			if v.logo then --TODO Add Logo parse to CMoviePlayerGui::parsePlaylist
-- 				extinf = " logo=" .. v.logo ..".jpg ,"
-- 			end
			extinf = extinf .. v.name
			m3ufile:write("#EXTINF:-1".. extinf .."\n")
			m3ufile:write(url .."\n")
		end
	end
	h:hide()
        m3ufile:close()
	info("Info", filename.." - Playlist wurde erstellt\n"..m3ufilename,2)
	return MENU_RETURN.EXIT_REPAINT
end

function playlist(filename)
	if (n:checkVersion(1, 1) == 0) then do return end end
	hideMenu(glob.menu_liste)
	local i = 1
	local KeyPressed = 0
	repeat
		local url = getvideourl(glob.MTVliste[i].url)
		if url then
			if glob.MTVliste[i].name == nil then
				glob.MTVliste[i].name = "NoName"
			end
			KeyPressed = n:PlayFile( glob.MTVliste[i].name,url);
		end
		if KeyPressed == PLAYSTATE.NORMAL then --play continue
			i=i+1
		elseif KeyPressed == PLAYSTATE.STOP then
			break
		elseif KeyPressed == PLAYSTATE.NEXT then
			i=i+1
		elseif KeyPressed == PLAYSTATE.PREV then
			i=i-1
		else
			print("Error")
			break
		end

	until i==0 or i == #glob.MTVliste+1

	return MENU_RETURN.EXIT_REPAINT
end

function dlstart(name)
	local infotext = name .." - Doownlaod-list wird erstellt\n"
	name = name:gsub([[%s+]], "_")
	name = name:gsub("[:'&()]", "_")
	local dlname = "/tmp/" .. name ..".dl"
	local p = file_exists(dlname)
	if p == true then
		infotext="Ein andere Download ist bereits Aktiv."
	end
	local h = hintbox.new{caption="Info", text=infotext}
	h:paint()
	if p == true then 
		os.execute("sleep 4")
		h:hide()
		return 
	end

	local dl=io.open(dlname,"w")
	local script_start = false
	for i, v in ipairs(glob.MTVliste) do
		if v.enabled == true then
			local url = getvideourl(glob.MTVliste[i].url)
			if url then
				if glob.MTVliste[i].name == nil then
					glob.MTVliste[i].name = "NoName_" .. i
				end
				local fname = v.name:gsub([[%s+]], "_")
				fname = fname:gsub("[:'()]", "_")
				dl:write("rtmpdump -e -r " .. url .. " -o " .. conf.path .. "/" .. fname ..".mp4\n")
				script_start = true
			end
		end
	end
	dl:close()
	if script_start == true then
	local scriptname  = "/tmp/" .. name ..".sh"
	local script=io.open(scriptname,"w")
	script:write(
	[[#!/bin/sh
	while read -r i
	do
		$i
	done < ]]
	)
	script:write("'" .. dlname .. "'\n")
	script:write([[
	wget -q 'http://127.0.0.1/control/message?popup=Video Liste ]])
	script:write(name .. "ist heruntergeladet.' -O /dev/null\n")
	script:write("rm '" .. dlname .. "'\n")
	script:write("rm '" .. scriptname .. "'\n")

	script:close()
	os.execute("sleep 2")
	os.execute("chmod 755 '" .. scriptname .. "'")
	os.execute("sh '"..scriptname.."' &")
	else
		local er = hintbox.new{caption="Info", text=name .." - Doownlaod-Error\n"}
		er:paint()
		os.remove(dlname)
		print("ERROR")
		os.execute("sleep 2")
		er:hide()
	end
	h:hide()
end

function gen_dl_list(name)
	hideMenu(glob.menu_liste)
	local menu =  menu.new{name=name, icon="icon_red"}
	menu:addItem{type="back"}
	menu:addItem{type="separatorline"}
	local d = 1 -- directkey

	menu:addItem{type="forwarder", name="Download-Start", action="dlstart", enabled=true,
	id=name, directkey=godirectkey(d),hint="Starte die selektierten Videos herunterzuladen in" .. conf.path}
	menu:addItem{type="separatorline"}
	for i, v in ipairs(glob.MTVliste) do
		d = d + 1
		local dkey = godirectkey(d)
		menu:addItem{type="chooser", action="set_bool_in_liste", options={ on, off }, id=i, value=bool2onoff(conf.dlflag), 
		name=i .. ": " ..v.name, hint_icon="hint_service",hint=v.name .. " speichern ? Ein/Aus"}
	end
	menu:exec()
	menu:hide()
end

function __menu(_menu,menu_name,table,_action)
	if table == nil or #table == 0 then
		info("Info", "Liste ist leer.", 1)
		return
	end
	hideMenu(glob.main_menu)
	_menu:addItem{type="back"}
	_menu:addItem{type="separatorline"}
	local d = 1 -- directkey

	_menu:addItem{type="forwarder", name="Playliste", action="playlist", enabled=true,
	id="Playliste " .. menu_name, directkey=godirectkey(d),hint="Playlist: " .. menu_name}
        d=d+1
	_menu:addItem{type="forwarder", name="Generiere M3U Playlist", action="gen_m3u_list", enabled=true,
	id=menu_name, directkey=godirectkey(d),hint="Generiere M3U Playlist: /tmp/" .. menu_name .. ".m3u"}
        d=d+1
	_menu:addItem{type="forwarder", name="Generiere Download-List", action="gen_dl_list", enabled=true,
	id=menu_name, directkey=godirectkey(d),hint="Generiere Download-List vor Verzeichnis: " .. conf.path}

	_menu:addItem{type="separatorline"}

	for i, v in ipairs(table) do
		d = d + 1
		local dkey = godirectkey(d)
		_menu:addItem{type="forwarder", name=i .. ": " .. v.name, action=_action,enabled=true,id=i,directkey=dkey,hint=v.type}
	end
	_menu:exec()
	_menu:hide()
	return MENU_RETURN.EXIT_REPAINT
end

function mtvliste(id)
	local i = tonumber(id)
	glob.MTVliste=nil;
	local url=glob.mtv[i].url
	glob.MTVliste = getliste(url)
	glob.menu_liste  = menu.new{name=glob.mtv[i].name, icon="icon_blue"}
	__menu(glob.menu_liste ,glob.mtv[i].name, glob.MTVliste,"action_exec")
	return MENU_RETURN.EXIT_REPAINT
end

function set_path(value)
	conf.path=value
	conf.changed = true
end

function set_option(k, v)
	if v == on then
		conf[k]=true
	else 
		conf[k]=false
	end
	conf.changed = true
end

function bool2onoff(a)
	if a then return on end
	return off
end

function setings()
	hideMenu(glob.main_menu)
	
	local d =  1
	local menu =  menu.new{name="Einstellungen", icon="icon_red"}
	menu:addItem{type="back"}
	menu:addItem{type="separatorline"}
	menu:addItem{ type="filebrowser", dir_mode="1", id="path", name="Verzeichnis: ", action="set_path",
		   enabled=true,value=conf.path,directkey=godirectkey(d),
		   hint_icon="hint_service",hint="In welchem Verzeichnis soll die Video gespeichert werden ?"
		 }
	d=d+1
	menu:addItem{type="chooser", action="set_option", options={ on, off }, id="dlflag", value=bool2onoff(conf.dlflag), directkey=godirectkey(d), name="Auswahl vorbelegen mit",hint_icon="hint_service",hint="Erstelle Auswahlliste mit 'ein' oder 'aus'"}

	menu:exec()
	menu:hide()
	return MENU_RETURN.EXIT_REPAINT
end

function gen_search_list(search) 
	local url = "http://www.mtv.de/searches?q=+"..search .. "+&ajax=1"
	local clip_page = getdata(url)
	if clip_page == nil then return nil end
	glob.mtv_search={}
	for _url ,title in clip_page:gmatch('/artists/(.-)"><div class="title">(.-)</div>') do
		title=title:gsub("&quot;",'"')
		title=title:gsub("&amp;",'&')
		table.insert(glob.mtv_search,{name=title,url="http://www.mtv.de/artists/" .. _url})
	end
	return MENU_RETURN.EXIT_REPAINT

end

function searchliste(id)
	hideMenu(glob.artists_menu)
	local i = tonumber(id)
	glob.MTVliste=nil;
	local url=glob.mtv_search[i].url
	glob.MTVliste = getliste(url)
	glob.menu_liste  = menu.new{name=glob.mtv_search[i].name, icon="icon_blue"}
	__menu(glob.menu_liste ,glob.mtv_search[i].name, glob.MTVliste,"action_exec")
	return MENU_RETURN.EXIT_REPAINT
end

function search_artists()
	if conf.search == nil then return end

	hideMenu(glob.main_menu)
	local h = hintbox.new{caption="Info", text="Suche: " .. conf.search}
	h:paint()
	if #conf.search > 1 then
		gen_search_list(conf.search)
	end
	h:hide()
	if glob.mtv_search == nil or #glob.mtv_search == 0 then
		info("Info", "Liste ist leer.", 1)
		return
	end

	local d = 0
	local menu =  menu.new{name=conf.search, icon="icon_yellow"}
	glob.artists_menu = menu
	menu:addItem{type="back"}
	menu:addItem{type="separatorline"}
	if glob.mtv_search then
	for i, v in ipairs(glob.mtv_search) do
		d = d + 1
		local dkey = godirectkey(d)
		menu:addItem{type="forwarder", name=i .. ": " .. v.name, action="searchliste",enabled=true,id=i,directkey=dkey,hint=v.type}
	end
	end
	menu:exec()
	menu:hide()
	return MENU_RETURN.EXIT_REPAINT
end

function main_menu()
	local table = glob.mtv
	if table == nil then
		return
	end
	hideMenu(glob.menu_liste)
	glob.main_menu  = menu.new{name="MTV", icon="icon_red"}
	local menu = glob.main_menu 
	local d = 1 -- directkey

	menu:addKey{directkey=RC["info"], id=mtv_verrsion, action="info"}
	menu:addItem{type="back"}
	menu:addItem{type="separatorline"}
	menu:addItem{type="forwarder", name="Einstellungen", action="setings", enabled=true,
	id="", directkey=godirectkey(d),hint="Einstellungen"}
        d=d+1
	menu:addItem{type="separatorline"}
	menu:addItem{type="keyboardinput", action="setvar", id="search", name="Künstler Name:", value=conf.name,directkey=godirectkey(d),hint_icon="hint_service",hint="Nach welchem Künstler soll gesucht werden"}
	d=d+1
	menu:addItem{type="forwarder", name="Suche nach Künstler", action="search_artists", enabled=true,
	id="find", directkey=godirectkey(d),hint="Suche nach Künstler"}

	menu:addItem{type="separatorline"}
	for i, v in ipairs(table) do
		d = d + 1
		local dkey = godirectkey(d)
		menu:addItem{type="forwarder", name=v.name, action="mtvliste",enabled=true,id=i,directkey=dkey,hint=v.url}
	end
	menu:exec()
	menu:hide()
end

function main()
	init()
	loadConfig()
	main_menu()
	saveConfig()
end

main()
