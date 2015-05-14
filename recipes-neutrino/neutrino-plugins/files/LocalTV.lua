--[[
	LocalTV Plugin
	Copyright (C) 2015,  Jacek Jendrzej 'satbaby', Janus

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

local conf = {}
local g = {}
local ListeTab = {}

local on="ein"
local off="aus"
local u="ubouquets"
local b="bouquets"
local localtv_verrsion="LocalTV 0.9 (beta)"
function __LINE__() return debug.getinfo(2, 'l').currentline end

function gethttpdata(host,link)

	local p = require "posix"
	local b = bit32 or require "bit"
	p.signal(p.SIGPIPE, function() print("pipe") end)

	local httpreq  = "GET /" .. link .. " HTTP/1.0\r\nHost: " ..host .. "\r\n\r\n"
	local res, err = p.getaddrinfo(host, "http", { family = p.AF_INET, socktype = p.SOCK_STREAM })
	if not res then 
		error(err) 
	end

	local fd = p.socket(p.AF_INET, p.SOCK_STREAM, 0)
	local ok, err, e = p.connect(fd, res[1])
	if err then 
		error(err)
	end
	p.send(fd, httpreq)

	local data = {}
	while true do
		local b = p.recv(fd, 1024)
		if not b or #b == 0 then
			break
		end
		table.insert(data, b)
	end
	p.close(fd)
	data = table.concat(data)
--	print(string.find(data, "HTTP/%d*%.%d* (%d%d%d)"))
	return data
end

function getDomainandLink(url)
	local f = string.find(url, '//')
	local patern = '([^/]+)/(.*)'
	if f  then 
		patern = "^%w+://"..patern
	end
	local host,link = url:match(patern)
	return host,link
end

function getdatafromurl(url)
	local data = nil
	local nBeginn, nEnde  

		local host,link = getDomainandLink(url)
		data = gethttpdata(host,link)
		nBeginn, nEnde, data = string.find(data, "^.-\r\n\r\n(.*)") -- skip header

	if data == nil then
	  	print("DEBUG ".. __LINE__())
	end
      return data
end

function tprint(tbl, indent)
         if not indent then indent = 0 end
        for k, v in pairs(tbl) do
                formatting = string.rep("       ", indent) .. k .. ": "
                if type(v) == "table" then
                        print(formatting)
                        tprint(v, indent+1)
                elseif type(v) == 'boolean' then
                        print(formatting .. tostring(v))
                else
                        print(formatting .. v)
                end
        end
end

function to_chid(satpos, frq, t, on, i)
	local transport_stream_id=tonumber (t, 16);
	local original_network_id=tonumber (on, 16);
	local service_id=tonumber(i, 16);
	return (string.format('%04x', satpos+frq*4) .. 
		string.format('%04x', transport_stream_id) .. 
		string.format('%04x', original_network_id) .. 
		string.format('%04x', service_id))
end

function printtab(t,b_name)
	local BListeTab = {}
	if t and b_name then
		for k, v in ipairs(t) do
			if v.tag == "S" then
--     				print(v.tag)
				if v.attr.u then
-- 			    		print(v.attr.u)
				elseif v.attr.i then
-- 			    		print(v.attr.i , v.attr.t , v.attr.on , v.attr.s , v.attr.frq, v.attr.n )
					local chid = to_chid(v.attr.s, v.attr.frq, v.attr.t, v.attr.on, v.attr.i)
					if v.attr.n == nil then
						v.attr.n = "Nicht definiert"
					end
					v.attr.n=v.attr.n:gsub("%&","&amp;")
					local webtv = '\t<webtv title="' .. v.attr.n .. '" url="http://' .. conf.ip .. ':31339/id='.. chid .. '" description="' .. b_name .. '" />'
					table.insert(BListeTab, { tv=webtv })
				end
			end
		end
	end
	return BListeTab
end

function make_list(value)
	local buxurl ="http://" .. conf.ip .. "/control/get" .. conf.bouquet .."xml"
	print(buxurl)
	local data = getdatafromurl(buxurl)
	local lom = require("lxp.lom")
	local tab = lom.parse(data)
	if tab == nil then
		info("Fehler","List konnte nicht generiert werden.")
		return
	end
	ListeTab = {}
	for i, v in ipairs(tab) do
		if v.tag == "Bouquet" then
			local blt = printtab(v,v.attr.name)
			if blt then
				v.attr.name=v.attr.name:gsub("%&","&amp;")
				table.insert(ListeTab, { name=v.attr.name , bt=blt,enabled=conf.enabled})
			end
		end
	end
	if ListeTab then
		gen_menu(ListeTab)
	end
end

function file_exists(file)
	local f = io.open(file, "rb")
	if f then f:close() end
	return f ~= nil
end

function is_dir(path)
	local f = io.open(path, "r")
	local ok, err, code = f:read(1)
	f:close()
	return code == 21
end

function saveliste()
	if ListeTab then
		local filename = conf.path .. "/" .. conf.name .. ".xml"
		if is_dir(conf.path) then
			if file_exists(filename) then
				local res = messagebox.exec{title=conf.name .. " ist vorhanden", text="Soll die existierende 			Datei überschrieben werden ?", buttons={ "yes", "no" } }
				if (res == "no") then return  end
			end
			local localtv = io.open(filename,'w+')
			if localtv then
				localtv:write('<?xml version="1.0" encoding="UTF-8"?>\n<webtvs>\n')
			else
				return
			end
			for _, v in ipairs(ListeTab) do
				if v.enabled then
-- 					print(v.name)
					if v.bt then
						for __, b in ipairs(v.bt) do
-- 							print(b.tv)
							localtv:write(b.tv.."\n")
						end
					end
				end
			end
			localtv:write("</webtvs>\n")
			localtv:close()
			info("Information", "Liste ".. conf.name .. ".xml" .. " wurde gespeichert")
		end
	else
		info("Fehler", "Verzeichnis nicht beschreibbar")
	end
end

function get_confFile()
	local confFile = "/var/tuxbox/config/localtv.conf"
	return confFile
end

function saveConfig()
	if conf.changed then
		local config	= configfile.new()
		config:setString("path", conf.path)
		config:setString("name",conf.name)
		config:setString("bouquet",conf.bouquet)
		config:setString("ip",conf.ip)
		config:setBool  ("enabled",conf.enabled)
		config:saveConfig(get_confFile())
		conf.changed = false
	end
end

function loadConfig()
	local config	= configfile.new()
	config:loadConfig(get_confFile())
	conf.path = config:getString("path", "/var/tuxbox/config")
	conf.name = config:getString("name", "BoxName")
	conf.ip   = config:getString("ip", "192.168.178.2")
	conf.bouquet = config:getString("bouquet", "ubouquets")
	conf.enabled = config:getBool("enabled", true)
	conf.changed = false
end

function setvar(k, v) 
--   	print(k,v)
	conf[k]=v
	conf.changed = true
end

function bool2onoff(a)
	if a then return on end
	return off
end
function setub(a,b)
	conf.bouquet = b
	conf.changed = true
	return b
end

function set_path(value)
	conf.path=value
	conf.changed = true
end

function info(captxt,infotxt)
	local n = neutrino()
	if captxt == localtv_verrsion and infotxt==nil then
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
function set_bool_in_liste(k, v) 
	local i = tonumber(k)
	if v == on then
		ListeTab[i].enabled=true
	else 
		ListeTab[i].enabled=false
	end
end

function set_option(k, v)
	if v == on then
		conf.enabled=true
	else 
		conf.enabled=false
	end
	conf.changed = true
end

function gen_menu(table)
	if table == nil then
		return
	end
	g.main:hide()
	local m  = menu.new{name="Liste " .. conf.name .. ": ".. conf.ip, icon="icon_blue"}
	m:addItem{type="separator"}
	m:addItem{type="back"}
	m:addItem{type="separatorline"}
	m:addItem{type="forwarder", name="Speichere Liste", action="saveliste",enabled=true,id="" ,directkey=RC["red"],hint_icon="hint_service",hint="Speichert die Liste unter ".. conf.path .. "/" .. conf.name .. ".xml" }
	m:addItem{type="separatorline"}
	for i, v in ipairs(table) do
		m:addItem{type="chooser", action="set_bool_in_liste", options={ on, off }, id=i, value=bool2onoff(v.enabled), name=v.name,hint_icon="hint_service",hint="Bouquet ".. v.name .. " speichern ? Ein/Aus"}
	end
	m:exec()
	m:hide()
	return MENU_RETURN.EXIT
end

function main_menu()
  	g.main = menu.new{name="LocalTV", icon="icon_red"}
	m=g.main
	m:addKey{directkey=RC["info"], id=localtv_verrsion, action="info"}

	m:addItem{type="back"}
	m:addItem{type="separatorline"}
	m:addItem{type="keyboardinput", action="setvar", id="name", name="Name", value=conf.name,directkey=RC["1"],hint_icon="hint_service",hint="Name unter dem die Liste gespeichert wird"}
	m:addItem{type="keyboardinput", action="setvar", id="ip",   value=conf.ip, name="Box-Adresse (IP/Name)",directkey=RC["2"],hint_icon="hint_service",hint="Box IP oder Url"}
	m:addItem{type="chooser", action="setub", options={ u, b }, id="ub", value=conf.bouquet, name="Liste aus:",directkey=RC["3"],hint_icon="hint_service",hint="Liste aus Favoriten- oder Anbieter-Bouquets"}
	m:addItem{ type="filebrowser", dir_mode="1", id="path", name="Verzeichnis: ", action="set_path",
		   enabled=true,value=conf.path,directkey=RC["4"],
		   hint_icon="hint_service",hint="Verzeichnis wählen in dem die Liste gespeichert wird"
		 }
	m:addItem{type="chooser", action="set_option", options={ on, off }, id="onoff",         value=bool2onoff(conf.enabled),         directkey=RC["5"], name="Auswahl vorbelegen mit",hint_icon="hint_service",hint="Generiere Auswahlliste mit 'ein' oder 'aus'"}
	m:addItem{type="separatorline"}
	m:addItem{type="forwarder", name="Generiere Liste", action="make_list",enabled=true,id="" ,directkey=RC["red"],hint_icon="hint_service",hint="Generiere Liste" }
	m:exec()
	m:hide()
end

function main()
	loadConfig()
	main_menu()
	saveConfig()
end

main()
