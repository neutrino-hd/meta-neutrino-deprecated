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

local u="ubouquets"
local b="bouquets"
local localtv_version="LocalTV 0.19"
function __LINE__() return debug.getinfo(2, 'l').currentline end

locale = {}
locale["deutsch"] = {
	create_error = "Liste konnte nicht erstellt werden.",
	patient = "Bitte warten ...",
	Error = "Fehler",
	fover = "Favoriten durch erstellte Bouquets ersetzen",
	fno = "Favoriten nicht ändern",
	fadd = "Erstellte Bouquets zu deiner Favoritenliste hinzufügen ",
	on = "ein",
	off = "aus",
	favoption = "Erstellte Bouquets zu den Favoriten hinzufügen, überschreiben oder unverändert lassen",
	dirnotwrit = "Verzeichnis nicht beschreibbar",
	saved = " wurde gespeichert",
	notdef = "Nicht definiert",
	askoverwrit = "Die existierende Datei überschreiben ?",
	isavailable = " ist vorhanden",
	list = "Liste ",
	info = "Information",
	savelist = "Speichere Liste",
	savelisthint = "Speichert die Liste unter ",
	keyboardhint = "Unter welchem Namen soll die Liste gespeichert werden",
	listsaveto = "In welchem Verzeichnis soll die Liste gespeichert werden ?",
	directory = "Verzeichnis",
	directory_hint = "Verzeichnis wählen, in dem das Favoriten bin-Paket erstellt werden soll",
	createlist = "Erstelle Liste",
	createlisthint = "Die Liste erstellen",
	onoffhint = "Erstelle Auswahlliste mit 'ein' oder 'aus'",
	provhint = "Liste aus Favoriten- oder Anbieterbouquets",
	select = "Auswahl vorbelegen mit",
	saveonoff = " speichern ? Ein/Aus",
	deflinkpath = "Symlinks im Var-Bereich",
	deflinkpathhint="Sollen alle Logo links zu /var/tuxbox/icons/logo führen ?"
}
locale["english"] = {
	create_error = "List could not be created.",
	patient = "Please be patient.",
	Error = "Error",
	fover = "Replace favorites by created bouquets",
	fno = "Favorites do not change",
	fadd = "Created bouquets Add to My Favorites List ",
	on = "on",
	off = "off",
	favoption = "Created Bouquets bookmark, overwrite or leave unchanged",
	dirnotwrit = "Directory not writable",
	saved = " has been saved",
	notdef = "Not defined",
	askoverwrit = "Overwrite existing file ?",
	isavailable = " is available",
	list = "List ",
	info = "Information",
	savelist = "Save list",
	savelisthint = "Saves the list under ",
	keyboardhint = "Under what name the list is to be saved",
	listsaveto = "In which directory list to be saved ?",
	directory = "Directory",
	createlist = "Create List",
	directory_hint = "Choose directory where the Favorites bin-package should be created",
	createlisthint = "Create List",
	onoffhint = "Creating selection list with 'on' or 'off'",
	provhint = "List of Favorites or Provider Bouquets",
	select = "Selection Preassign with",
	saveonoff = " save ? on/off",
	deflinkpath = "Symlinks in the VAR-area",
	deflinkpathhint="If all logo links lead to /var/tuxbox/icons/logo logo ?"
}
----------------------------------------------------------------------------------------------
function gethttpdata(host,link)

	local p = require "posix"
	local b = bit32 or require "bit"
	p.signal(p.SIGPIPE, function() print("pipe") end)

	local httpreq  = "GET /" .. link .. " HTTP/1.0\r\nHost: " ..host .. "\r\n\r\n"
	local res, err = p.getaddrinfo(host, "http", { family = p.AF_INET, socktype = p.SOCK_STREAM })
	if not res then 
		info(locale[conf.lang].Error .. ":", err)
		return
	end

	local fd = p.socket(p.AF_INET, p.SOCK_STREAM, 0)
	local ok, err, e = p.connect(fd, res[1])
	if err then 
		info(locale[conf.lang].Error .. ":", err)
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

function add_channels(t,b_name,logolist)
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
						if logolist ~= nil then
							v.attr.n = logolist:match(chid .. ";(.-);")
						end
						if v.attr.n == nil then
							v.attr.n = locale[conf.lang].notdef .. " " .. k
						end
					end
					v.attr.n=v.attr.n:gsub("%&","&amp;")
					local url='http://' .. conf.ip .. ':31339/id='.. chid
					local _epgid = chid:sub(#chid-11,#chid)
					_epgid = _epgid:gsub("^0+(.-)", "%1")
					table.insert(BListeTab, { tv=url, n=v.attr.n, l=v.attr.l, un=v.attr.un, epgid= _epgid })
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
	local h = hintbox.new{caption=locale[conf.lang].info, text=locale[conf.lang].patient}
	h:paint()

	local data = getdatafromurl(boxurl)

	if data == nil then return end -- error
	local logolist = getdatafromurl("http://" .. conf.ip .. "/control/logolist")
	local lom = require("lxp.lom")
	local tab = lom.parse(data)
	if tab == nil then
		h:hide()
		info(locale[conf.lang].Error, locale[conf.lang].create_error)
		return
	end
	ListeTab = {}
	for i, v in ipairs(tab) do
		if v.tag == "Bouquet" then
			local blt = add_channels(v,v.attr.name,logolist)
			if blt then
				v.attr.name=v.attr.name:gsub("%&","&amp;")
				table.insert(ListeTab, { name=v.attr.name, epg=v.attr.epg, hidden=v.attr.hidden, locked=v.attr.locked ,bqID=v.attr.bqID , bt=blt, enabled=conf.enabled})
			end
		end
	end
	h:hide()
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
	local ok, err, code = false, false, false
	if f then
		ok, err, code = f:read(1)
		f:close()
	end
	return code == 21
end

function make_fav_back()
	os.execute("mkdir /tmp/tmpfav")
	os.execute("mkdir /tmp/tmpfav/temp_inst")
	os.execute("mkdir /tmp/tmpfav/temp_inst/inst")
	os.execute("mkdir /tmp/tmpfav/temp_inst/inst/var")
	os.execute("mkdir /tmp/tmpfav/temp_inst/inst/var/tuxbox")
	os.execute("mkdir /tmp/tmpfav/temp_inst/inst/var/tuxbox/config")
	os.execute("mkdir /tmp/tmpfav/temp_inst/inst/var/tuxbox/config/zapit")
	os.execute("mkdir /tmp/tmpfav/temp_inst/ctrl")
	local postins = "/tmp/tmpfav/temp_inst/ctrl/postinstall.sh"
	local fileout = io.open(postins, 'w')
	fileout:write("pzapit -c \n")
	fileout:write('wget -q -O /dev/null "http://localhost/control/message?popup=Favoriten-Bouquet%20wurde%20installiert."')
	fileout:close()
	os.execute("chmod 755 " .. postins)
	os.execute("cp " .. conf.ubouquets_xml .. " /tmp/tmpfav/temp_inst/inst/var/tuxbox/config/zapit/" )
	os.execute("cd /tmp/tmpfav && tar -czvf  " .. conf.backuppath .."/last_ubouquets_xml.bin temp_inst" )
	os.execute("rm -rf /tmp/tmpfav/")
end

function changeFav()
	if is_dir(conf.backuppath) then
		make_fav_back()
	end
	local force = true
	local fileout = nil
	if conf.fav == "add" then
			local lines = read_ubouquets_xml(conf.ubouquets_xml)
			if lines then
				fileout = io.open(conf.ubouquets_xml, 'w+')
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
		fileout = io.open(conf.ubouquets_xml, 'w+')
		if fileout == nil then return end
		fileout:write('<?xml version="1.0" encoding="UTF-8"?>\n<zapit>\n')
	end
	for _, v in ipairs(ListeTab) do
		if v.enabled then
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
				fileout:write('\t<Bouquet name="' .. v.name .. " (".. conf.name .. ')"' .. bqID .. hidden .. locked .. epg ..' >\n')
				for __, b in ipairs(v.bt) do
					local un = ""
					local l = ""
					if b.l then
						l=' l="' .. b.l .. '"' 
					end
					if b.un then
						un=' un="' .. b.un  .. '"'
					end
					fileout:write('\t\t<S u="' .. b.tv..'" n="' ..b.n.. '"' .. un .. l ..' />\n')
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
				local res = messagebox.exec{title=conf.name .. locale[conf.lang].isavailable, text=locale[conf.lang].askoverwrit, buttons={ "yes", "no" } }
				if (res == "no") then return  end
			end
			local localtv = io.open(filename,'w+')
			if localtv then
				localtv:write('<?xml version="1.0" encoding="UTF-8"?>\n<webtvs>\n')
			else
				return
			end
			local deflogopth = "/var/tuxbox/icons/logo"
			for _, v in ipairs(ListeTab) do
				if v.enabled then
					if v.bt then
						for __, b in ipairs(v.bt) do
							localtv:write('\t<webtv title="' .. b.n .. '" url="' .. b.tv  .. '" epgid="' .. b.epgid.. '" description="' .. v.name .. '" genre="' ..conf.name  ..'" />\n')
							if conf.logo_dir  ~= "#" then
								local logo={}
								logo[1] =  deflogopth .."/"
								logo[2] = "/share/tuxbox/neutrino/icons/logo"
								logo[3] = conf.logo_dir
								for j,l  in pairs(logo) do
									if l and is_dir(l) then
										local logopath = l .."/" ..b.epgid
										local jpg = false
										local png = file_exists(logopath..".png")
										local picformat = ".png"
										if png == false then
											jpg = file_exists(logopath..".jpg")
											picformat = ".jpg"
										end
										if  png or jpg then
											local webtvid = n:createChannelIDfromUrl(b.tv)
											webtvid = webtvid:sub(#webtvid-11,#webtvid)
											local defvar =""
											if conf.varonoff == true and is_dir(deflogopth) then
												defvar = deflogopth .. "/"
											end
											local logo_symlink = defvar .. webtvid .. picformat
											if conf.varonoff == true then
												os.execute("ln  -fs " .. l .."/".. b.epgid.. picformat .. " " .. logo_symlink)
											else
												os.execute("cd " .. l .. "/ && ln  -fs " .. b.epgid.. picformat .. " " .. logo_symlink)
											end
										end
									end
								end
							end
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
			info(locale[conf.lang].info, locale[conf.lang].list.. conf.name .. ".xml" .. locale[conf.lang].saved)
		end
	else
		info(locale[conf.lang].Error, locale[conf.lang].dirnotwrit)
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
		config:setString("backuppath", conf.backuppath)
		config:setString("name",conf.name)
		config:setString("bouquet",conf.bouquet)
		config:setString("ip",conf.ip)
		config:setBool  ("enabled",conf.enabled)
		config:setBool  ("varonoff",conf.varonoff)
		config:setString("fav",conf.fav)
		config:saveConfig(get_confFile())
		conf.changed = false
	end
end

function loadConfig()
	local config	= configfile.new()
	config:loadConfig(get_confFile())
	conf.path = config:getString("path", "/var/tuxbox/config")
	conf.backuppath = config:getString("backuppath", "/media/sda1")
	conf.name = config:getString("name", "BoxName")
	conf.ip   = config:getString("ip", "192.168.178.2")
	conf.bouquet = config:getString("bouquet", "ubouquets")

	conf.enabled = config:getBool("enabled", true)
	conf.varonoff = config:getBool("varonoff", false)
	conf.fav = config:getString("fav", "no")
	conf.changed = false
	local Nconfig	= configfile.new()
	Nconfig:loadConfig("/var/tuxbox/config/neutrino.conf")
	if APIVERSION.MAJOR > 1 or ( APIVERSION.MAJOR == 1 and APIVERSION.MINOR > 5 ) then
		conf.logo_dir = Nconfig:getString("logo_hdd_dir", "#")
	else
		conf.logo_dir = "#"
	end
	conf.lang = Nconfig:getString("language", "english")
	if locale[conf.lang] == nil then
		conf.lang = "english"
	end
	conf.ubouquets_xml = "/var/tuxbox/config/zapit/ubouquets.xml"

end

function setvar(k, v) 
	conf[k]=v
	conf.changed = true
end

function bool2onoff(a)
	if a then return locale[conf.lang].on end
	return locale[conf.lang].off
end

function favoption(a)
	if a == "on" then return locale[conf.lang].fon
	end
	if a == "overwrite" then return locale[conf.lang].fover
	end
	if a == "add" then return locale[conf.lang].fadd
	end
end

function setub(a,b)
	conf.bouquet = b
	conf.changed = true
	return b
end

function setabc(a,b)
	local aktiv = true
	if b == locale[conf.lang].fno then
		conf.fav = "no"
		aktiv = false
	elseif b == locale[conf.lang].fover then
		conf.fav = "overwrite"
	elseif b == locale[conf.lang].fadd then
		conf.fav = "add"
	end
	conf.changed = true
	g.main:setActive{item=g.item1, activ=aktiv}
	return b
end

function set_path(value)
	conf.path=value
	conf.changed = true
end

function set_backup_path(value)
	conf.backuppath=value
	conf.changed = true
end

function info(captxt,infotxt)
	if captxt == localtv_version and infotxt==nil then
		infotxt=captxt
		captxt=locale[conf.lang].info
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
	if v == locale[conf.lang].on then
		ListeTab[i].enabled=true
	else 
		ListeTab[i].enabled=false
	end
end

function set_option(k, v)
	if v == locale[conf.lang].on then
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
	m:addItem{type="forwarder", name=locale[conf.lang].savelist, action="saveliste",enabled=true,id="" ,directkey=RC["red"],hint_icon="hint_service",hint=locale[conf.lang].savelisthint .. conf.path .. "/" .. conf.name .. ".xml" }
	m:addItem{type="separatorline"}
	for i, v in ipairs(table) do
		m:addItem{type="chooser", action="set_bool_in_liste", options={ locale[conf.lang].on, locale[conf.lang].off }, id=i, value=bool2onoff(v.enabled), name=v.name,hint_icon="hint_service",hint="Bouquet ".. v.name .. locale[conf.lang].saveonoff}
	end
	m:exec()
	m:hide()
	return MENU_RETURN.EXIT
end

function main_menu()
  	g.main = menu.new{name="LocalTV", icon="icon_red"}
	m=g.main
	m:addKey{directkey=RC["info"], id=localtv_version, action="info"}

	m:addItem{type="back"}
	m:addItem{type="separatorline"}
	m:addItem{type="keyboardinput", action="setvar", id="name", name="Name", value=conf.name,directkey=RC["1"],hint_icon="hint_service",hint=locale[conf.lang].keyboardhint}
	m:addItem{type="keyboardinput", action="setvar", id="ip",   value=conf.ip, name="Box-Adresse (IP/Name)",directkey=RC["2"],hint_icon="hint_service",hint="Box IP oder Url"}
	m:addItem{type="chooser", action="setub", options={ u, b }, id="ub", value=conf.bouquet, name="Liste aus:",directkey=RC["3"],hint_icon="hint_service",hint=locale[conf.lang].provhint}
	m:addItem{ type="filebrowser", dir_mode="1", id="path", name="WebTV ".. locale[conf.lang].directory .. ": ", action="set_path",
		   enabled=true,value=conf.path,directkey=RC["4"],
		   hint_icon="hint_service",hint=locale[conf.lang].listsaveto
		 }
	m:addItem{type="chooser", action="set_option", options={ locale[conf.lang].on, locale[conf.lang].off }, id="enabled", value=bool2onoff(conf.enabled), directkey=RC["5"], name=locale[conf.lang].select,hint_icon="hint_service",hint=locale[conf.lang].onoffhint}
	m:addItem{type="chooser", action="setabc", options={ locale[conf.lang].fno, locale[conf.lang].fadd, locale[conf.lang].fover }, id="boxub", value=favoption(conf.fav), name="",directkey=RC["6"],hint_icon="hint_service",hint=locale[conf.lang].favoption}
	g.item1 = m:addItem{type="filebrowser",dir_mode="1",name="Fav " .. locale[conf.lang].directory .. ":",action="set_backup_path",enabled=file_exists(conf.ubouquets_xml),
		value=conf.backuppath,directkey=RC["7"] ,hint_icon="hint_service",hint=locale[conf.lang].directory_hint}
	m:addItem{type="chooser", action="set_option", options={ locale[conf.lang].on, locale[conf.lang].off }, id="varonoff", value=bool2onoff(conf.varonoff), directkey=RC["8"], enabled=is_dir("/var/tuxbox/icons/logo"), name=locale[conf.lang].deflinkpath,hint_icon="hint_service",hint=locale[conf.lang].deflinkpathhint}
	m:addItem{type="separatorline"}
	m:addItem{type="forwarder", name=locale[conf.lang].createlist, action="make_list",enabled=true,id="",directkey=RC["red"],hint_icon="hint_service",hint=locale[conf.lang].createlisthint }

	m:setActive{item=g.item1, activ=conf.fav ~= "no"}
	m:exec()
	m:hide()
end

function main()
	loadConfig()
	main_menu()
	saveConfig()
end

main()
