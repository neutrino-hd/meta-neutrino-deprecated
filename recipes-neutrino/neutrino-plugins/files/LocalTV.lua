--[[
	LocalTV Plugin
	Copyright (C) 2015,  Jacek Jendrzej 'satbaby', Janus, flk

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
local n = neutrino()

local fover="Favoriten durch erstellte Bouquets ersetzen"
local fno="Favoriten nicht ändern"
local fadd="Erstellte Bouquets zu deiner Favoritenliste hinzufügen "

local on="ein"
local off="aus"
local u="ubouquets"
local b="bouquets"
local localtv_verrsion="LocalTV 0.12 (beta)"
function __LINE__() return debug.getinfo(2, 'l').currentline end

function gethttpdata(host,link)

	local p = require "posix"
	local b = bit32 or require "bit"
	p.signal(p.SIGPIPE, function() print("pipe") end)

	local httpreq  = "GET /" .. link .. " HTTP/1.0\r\nHost: " ..host .. "\r\n\r\n"
	local res, err = p.getaddrinfo(host, "http", { family = p.AF_INET, socktype = p.SOCK_STREAM })
	if not res then 
		info("Fehler:", err)
		return
	end

	local fd = p.socket(p.AF_INET, p.SOCK_STREAM, 0)
	local ok, err, e = p.connect(fd, res[1])
	if err then 
		info("Fehler:", err)
		return
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
		if data == nil then
			print("DEBUG ".. __LINE__())
		else
			nBeginn, nEnde, data = string.find(data, "^.-\r\n\r\n(.*)") -- skip header
		end

	if data == nil then
	  	print("DEBUG ".. __LINE__())
	end
      return data
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

function add_channels(t,b_name)
	local BListeTab = {}
	local ok = false
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
					local url='"http://' .. conf.ip .. ':31339/id='.. chid .. '"'
					table.insert(BListeTab, { tv=url,s=v.attr.s, frq=v.attr.frq, n=v.attr.n, t=v.attr.t, on=v.attr.on, i=v.attr.i, l=v.attr.l, un=v.attr.un })
					ok=true
				end
			end
		end
	end
	if ok then 
		return BListeTab
	else
		return nil
	end
end

function make_list(value)
	local boxurl ="http://" .. conf.ip .. "/control/get" .. conf.bouquet .."xml"
	local data = getdatafromurl(boxurl)

	if data == nil then return end -- error

	local lom = require("lxp.lom")
	local tab = lom.parse(data)
	if tab == nil then
		info("Fehler","Liste konnte nicht erstellt werden.")
		return
	end
	ListeTab = {}
	for i, v in ipairs(tab) do
		if v.tag == "Bouquet" then
			local blt = add_channels(v,v.attr.name)
			if blt then
				v.attr.name=v.attr.name:gsub("%&","&amp;")
				table.insert(ListeTab, { name=v.attr.name, epg=v.attr.epg, hidden=v.attr.hidden, locked=v.attr.locked ,bqID=v.attr.bqID , bt=blt, enabled=conf.enabled})
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

function changeFav()
	local ubouquets_xml = "/var/tuxbox/config/zapit/ubouquets.xml"
	local force = true
	local fileout = nil
	if conf.fav == "add" then
			local lines = read_ubouquets_xml(ubouquets_xml)
			if lines then
				fileout = io.open(ubouquets_xml, 'w+')
				if fileout then
					for k,v in pairs(lines) do
						local f = string.find(v, "</zapit>")
						if not f then
							fileout:write(v .. "\n")
							force = false
						end
					end
				end
			end
	end
	if force then
		fileout = io.open(ubouquets_xml, 'w+')
		if fileout == nil then return end
		fileout:write('<?xml version="1.0" encoding="UTF-8"?>\n<zapit>\n')
	end
	for _, v in ipairs(ListeTab) do
		if v.enabled then
--			print(v.name)
			if v.bt then
				local locked = ""
				local hidden = ""
				local epg = ""
				local bqID = ""
				if v.bqID then
					bqID=' bqID="' .. v.bqID .. '"' 
				end
				if v.locked then
					locked=' locked="' .. v.locked .. '"' 
				end
				if v.hidden then
					hidden=' hidden="' .. v.hidden .. '"' 
				end
				if v.epg then
					epg=' epg="' .. "0"  .. '"' -- v.epg disable epg scan 
				end
				fileout:write('\t<Bouquet name="' .. v.name .. '"' .. bqID .. hidden .. locked .. epg ..' >\n')
					for __, b in ipairs(v.bt) do
						if conf.epg then
						local un = ""
						local l = ""
						if b.l then
							l=' l="' .. b.l .. '"' 
						end
						if b.un then
							un=' un="' .. b.un  .. '"'
						end
						fileout:write('\t\t<S i="' .. b.i ..'" t="' .. b.t .. '" on="' .. b.on..'" s="' ..b.s..'" frq="'.. b.frq .. '" n="'.. b.n .. un .. l ..'" />\n')
					end
 					fileout:write('\t\t<S u=' .. b.tv..' n="' ..b.n.. '" />\n')
				end
				fileout:write('\t</Bouquet>\n')
			end
		end
	end
	fileout:write('</zapit>\n')
	fileout:close()
end

function read_ubouquets_xml(file)
 	if not file_exists(file) then return {} end
	lines = {}
	for line in io.lines(file) do 
		lines[#lines + 1] = line
	end
	return lines
end

function saveliste()
	if ListeTab then
		local filename = conf.path .. "/" .. conf.name .. ".xml"
		if is_dir(conf.path) then
			if file_exists(filename) then
				local res = messagebox.exec{title=conf.name .. " ist vorhanden", text="Die existierende 			Datei überschreiben ?", buttons={ "yes", "no" } }
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
							localtv:write('\t<webtv title="' .. b.n .. '" url=' .. b.tv .. ' description="' .. v.name .. '" genre="' ..conf.name  ..'" />\n')
						end
					end
				end
			end
			localtv:write("</webtvs>\n")
			localtv:close()
			if conf.fav ~= "no" then
				changeFav()
			end
			os.execute( 'pzapit -c')
			info("Inforation", "Liste ".. conf.name .. ".xml" .. " wurde gespeichert")
		end
	else
		info("Fehler", "Verzeichnis nicht beschreibbar")
		return
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
		config:setString("fav",conf.fav)
		config:setBool  ("epg",conf.epg)
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
	conf.fav = config:getString("fav", "no")
	conf.epg = config:getBool("epg", false)
	conf.changed = false
end

function setvar(k, v) 
	conf[k]=v
	conf.changed = true
end

function bool2onoff(a)
	if a then return on end
	return off
end

function favoption(a)
	if a == "on" then return fon
	end
	if a == "overwrite" then return fover
	end
	if a == "add" then return fadd
	end
end

function setub(a,b)
	conf.bouquet = b
	conf.changed = true
	return b
end

function setabc(a,b)
	if b == fno then
		conf.fav = "no"
	elseif b == fover then
		conf.fav = "overwrite"
	elseif b == fadd then
		conf.fav = "add"
	end
	conf.changed = true
	return b
end

function set_path(value)
	conf.path=value
	conf.changed = true
end

function info(captxt,infotxt)
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
		conf[k]=true
	else 
		conf[k]=false
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
	m:addItem{type="keyboardinput", action="setvar", id="name", name="Name", value=conf.name,directkey=RC["1"],hint_icon="hint_service",hint="Unter welchem Namen soll die Liste gespeichert werden"}
	m:addItem{type="keyboardinput", action="setvar", id="ip",   value=conf.ip, name="Box-Adresse (IP/Name)",directkey=RC["2"],hint_icon="hint_service",hint="Box IP oder Url"}
	m:addItem{type="chooser", action="setub", options={ u, b }, id="ub", value=conf.bouquet, name="Liste aus:",directkey=RC["3"],hint_icon="hint_service",hint="Liste aus Favoriten- oder Anbieterbouquets"}
	m:addItem{ type="filebrowser", dir_mode="1", id="path", name="Verzeichnis: ", action="set_path",
		   enabled=true,value=conf.path,directkey=RC["4"],
		   hint_icon="hint_service",hint="In welchem Verzeichnis soll die Liste gespeichert werden ?"
		 }
	m:addItem{type="chooser", action="set_option", options={ on, off }, id="enabled", value=bool2onoff(conf.enabled), directkey=RC["5"], name="Auswahl vorbelegen mit",hint_icon="hint_service",hint="Erstelle Auswahlliste mit 'ein' oder 'aus'"}
	m:addItem{type="chooser", action="setabc", options={ fno, fadd, fover }, id="boxub", value=favoption(conf.fav), name="",directkey=RC["6"],hint_icon="hint_service",hint="Erstellte Bouquets zu den Favoriten hinzufügen, überschreiben oder unverändert lassen"}
	m:addItem{type="chooser", action="set_option", options={ on, off }, id="epg",enabled=ture,value=bool2onoff(conf.epg), directkey=RC["7"], name="Falsche Sender erstellen",hint_icon="hint_service",hint="Falsche Sender nur in der Favoritenliste erstellen. EPG workaround !!!"}
	m:addItem{type="separatorline"}
	m:addItem{type="forwarder", name="Erstelle Liste", action="make_list",enabled=true,id="",directkey=RC["red"],hint_icon="hint_service",hint="Die Liste erstellen" }
	m:exec()
	m:hide()
end

function main()
	loadConfig()
	main_menu()
	saveConfig()
end

main()
