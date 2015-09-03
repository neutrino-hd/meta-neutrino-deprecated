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
local mtv_verrsion="mtv.de Version 0.1"
local n = neutrino()

function init()
	glob.mtv={
		{name = "Brandneu",url="http://www.mtv.de/musik"},
		{name = "Hitlist Germany - Top 100",url="http://www.mtv.de/charts/5-hitlist-germany-top-100"},
		{name = "MTV.de Videocharts",url="http://www.mtv.de/charts/8-mtv-de-videocharts"},
		{name = "Top 100 Jahrescharts 2013",url="http://www.mtv.de/charts/199-top-100-single-jahrescharts-2013"},
		{name = "Dance Charts",url="http://www.mtv.de/charts/6-dance-charts"},
		{name = "Deutsche Urban Charts",url="http://www.mtv.de/charts/9-deutsche-black-charts"}
	}
end

function info(captxt,infotxt)
	if captxt == mtv_verrsion and infotxt==nil then
		infotxt=captxt
		captxt="Information"
	end
	local h = hintbox.new{caption=captxt, text=infotxt}
	h:paint()
	repeat
		msg, data = n:GetInput(500)
	until msg == RC.ok or msg == RC.home
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
	os.execute("wget --user-agent='Mozilla/5.0' -O " .. output .." ".. url );
	local clip_page = read_file(output)
	os.remove(output)
	return clip_page
end

function getliste(url)
	local clip_page = getdata(url)
	clip_page = string.match(clip_page,"window.pagePlaylist = %[(.-)%];")
	local json = require "json"
	local liste = {}
	for j in string.gmatch(clip_page, "(%{.id.-%})") do
		local jnTab = json:decode(j)
		if(jnTab.title and jnTab.subtitle and jnTab.riptide_image_id) then
			table.insert(liste,{name=jnTab.title .. ": " .. jnTab.subtitle, url=jnTab.mrss,type=jnTab.video_type})
		end
	end
	return liste
end

function hideMenu(menu)
	if menu ~= nil then menu:hide() end
end

function getvideourl(url)
	if url == nil then return nil end
	local video_url = nil
	local clip_page = getdata(url)
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
			n:PlayFile(glob.MTVliste[i].name, url);
		end
	end
	return MENU_RETURN.EXIT_REPAINT;
end

function __menu(_menu,table,_action)
	if table == nil then
		return
	end
	hideMenu(glob.main_menu)
	_menu:addItem{type="back"}
	_menu:addItem{type="separatorline"}
	local d = 0 -- directkey
	for i, v in ipairs(table) do
		d = d + 1
		local dkey = godirectkey(d)
		_menu:addItem{type="forwarder", name=i .. ": " .. v.name, action="action_exec",enabled=true,id=i,directkey=dkey,hint=v.type}
	end
	_menu:exec()
	_menu:hide()
	return MENU_RETURN.EXIT_REPAINT;
end

function mtvliste(id)
	local i = tonumber(id)
	glob.MTVliste=nil;
	local url=glob.mtv[i].url
	glob.MTVliste = getliste(url)
	glob.menu_liste  = menu.new{name=glob.mtv[i].name, icon="icon_blue"}
	__menu(glob.menu_liste ,glob.MTVliste,"action_exec")
	return MENU_RETURN.EXIT_REPAINT;
end

function main_menu()
	local table = glob.mtv
	if table == nil then
		return
	end
	hideMenu(glob.menu_liste)
	glob.main_menu  = menu.new{name="MTV", icon="icon_red"}
	local menu = glob.main_menu 
	
	menu:addKey{directkey=RC["info"], id=mtv_verrsion, action="info"}
	menu:addItem{type="back"}
	menu:addItem{type="separatorline"}
	local d = 0 -- directkey
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
	main_menu()
end
main()
