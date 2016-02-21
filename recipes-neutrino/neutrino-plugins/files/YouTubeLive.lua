--[[
	YouTubeLive Plugin
	Copyright (C) 2016,  Jacek Jendrzej 'satbaby'

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
local V = nil
local m,m2 = nil,nil
local conf = {}
local resolution = {'1920x1080','1280x720','854x480','640x360','426x240','128x72'}
local itags = {[37]='1920x1080',[96]='1920x1080',[22]='1280x720',[95]='1280x720',[94]='854x480',[35]='854x480',
		[18]='640x360',[93]='640x360',[34]='640x360',[5]='400x240',[6]='450x270',[35]='320x240',[92]='320x240',[132]='320x240',
		[17]='176x144',[13]='176x144',[151]='128x72',
		[85]='1920x1080p',[84]='1280x720',[83]='854x480',[82]='640x360'
}

local n = neutrino()

local version="YouTubeLive 0.2"

local locale = {}

locale["english"] = {
	info = "Information",
	settings = "Settings",
	resolution = "Preferred resolution",
	favname = "Preferred name",
	favopt1 = "from YouTube Channel",
	favopt2 = "My"
}
locale["deutsch"] = {
	info="Information",
	settings="Einstellungen",
	resolution = "Bevorzugte Auflösung",
	favname = "Bevorzugte Name",
	favopt1 = "von YouTube-Kanal",
	favopt2 = "Mein"
}
locale["polski"] = {
	info="Informacja",
	settings="Ustawienia",
	resolution = "Preferowana rozdzielczość",
	favname = "Preferowane nazwa",
	favopt1 = "od YouTube kanału",
	favopt2 = "Moja"
}

function info(captxt,infotxt)
	if captxt == version and infotxt==nil then
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

function get_confFile()
	local confFile = "/var/tuxbox/config/ytlive.conf"
	return confFile
end

function saveConfig()
	if conf.changed then
		local config	= configfile.new()
		config:setString("favres", conf.favres)
		config:setBool  ("favname",conf.favname)
		config:saveConfig(get_confFile())
		conf.changed = false
	end
end

function loadConfig()
	local config	= configfile.new()
	config:loadConfig(get_confFile())
	conf.favres = config:getString("favres", "1920x1080")
	conf.favname = config:getBool("favname", false)
	conf.changed = false

	local Nconfig	= configfile.new()
	Nconfig:loadConfig("/var/tuxbox/config/neutrino.conf")
	conf.lang = Nconfig:getString("language", "english")
	if locale[conf.lang] == nil then
		conf.lang = "english"
	end

end

function file_exists(file)
	local f = io.open(file, "rb")
	if f then f:close() end
	return f ~= nil
end

function lines_from(file)
 	if not file_exists(file) then return {} end
	lines = {}
	for line in io.lines(file) do
		lines[#lines + 1] = line
	end
	return lines
end

function godirectkey(d)
	if d  == nil then return d end
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

function play(name, url, infores)
	if V == nil then
		V   = video.new()
	end
	if V and m and url then
		m:hide()
		V:setSinglePlay(true)
		V:PlayFile(name, url, infores)
	end
end

local Curl = nil
function getdata(Url)
	if Url == nil then return nil end

	if Curl == nil then
		Curl = curl.new()
	end
	local ret, data = Curl:download{ url=Url, A="Mozilla/5.0"}
	if ret == CURL.OK then
		return data
	else
		return nil
	end
end

function init()
	loadConfig()
	local file = "/var/tuxbox/config/ytlive.url"
	local links = lines_from(file)
	return links
end
function hideMenu(_menu_)
	if _menu_ ~= nil then _menu_:hide() end
end

function set(a,b)
	conf[a] = b
 	conf.changed = true
	return b
end

function set_bool(a, b) 
	conf[a] = conf[a]~= true
 	conf.changed = true
end

function bool2onoff(a,b,c)
	if a then return locale[conf.lang][b] end
	return locale[conf.lang][c]
end

function settings()
	hideMenu(m)
	local m2 = menu.new{name=locale[conf.lang].settings, icon="settings", icon="icon_blue"}
	m2:addItem{type="separator"}
	m2:addItem{type="back"}
	m2:addItem{type="separatorline"}
	local favoptions = {locale[conf.lang].favopt1,locale[conf.lang].favopt2}
	local d = 1 -- directkey
	local dkey = 0
	dkey = godirectkey(d)
	m2:addItem{type="chooser", action="set", options=resolution, id='favres', value=conf.favres, name=locale[conf.lang].resolution,directkey=dkey}
	d=d+1
	dkey = godirectkey(d)	
	m2:addItem{type="chooser", action="set_bool", options=favoptions, id='favname', value=bool2onoff(conf.favname,'favopt1','favopt2'), name=locale[conf.lang].favname,directkey=dkey}

	m2:exec()
	m2:hide()
	return MENU_RETURN.EXIT_REPAINT;
end

function hex2char(hex)
  return string.char(tonumber(hex, 16))
end
function unescape_uri(url)
  return url:gsub("%%(%x%x)", hex2char)
end

function getAlternatevideourl(youtube_url)
	local id = youtube_url:match('v=(.-)$')
	local url = 'http://www.youtube.com/get_video_info?video_id=' .. id .. '&el=embedded&ps=default&eurl=&gl=US&hl=en'
	local data = getdata(url)
	if data then
		local stream_map = data:gsub("^(.-)url_encoded_fmt_stream_map","")
		data = nil
		stream_map=unescape_uri(stream_map)
		if stream_map then
			local favresurl = nil
			local url,infores = nil,nil
			local quali = 0
			for d in stream_map:gmatch('url=(.-)[,;]') do
				local item={}
				d=unescape_uri(d)
				local itagstr = d:match('itag=(%w+)')
				if  itagstr ~= nil and itags[tonumber(itagstr)] then
					local itagnum = tonumber(itagstr)
					d=d:gsub("(&itag=%d+)","")
					local video_url = d
					if video_url ~= nil then
						if itags[itagnum] == conf.favres then
							favresurl = video_url .. "&itag=" .. itagnum
							infores = itags[itagnum]
						break
						end
						res = tonumber(itags[itagnum]:match('(%d+)'))
						if res > quali then
							url = video_url .. "&itag=".. itagnum
							quali = res
							infores = itags[itagnum]
						end
					end
				end
			end
			if favresurl then
				return favresurl,infores
			elseif url then
				return url,infores
			else
				return nil,nil
			end
		end
	end
end
function getvideourl(name_url)
	local name,url = name_url:match('(.-);.-(http.-)$')
	if url == nil then
		return
	end
	local data = getdata(url)
	if data then
		local m3u_url = data:match('hlsvp.:.(https:\\.-m3u8)') 
		local newname = data:match('<title>(.-)</title>')
		if conf.favname and newname then
			name = newname
		end
		if m3u_url == nil then
			local urla,info = getAlternatevideourl(url)
			if urla then
				play(name, urla, info)
			end
			return
		end
		m3u_url = m3u_url:gsub("\\", "")
		local videdata= getdata(m3u_url)
		local quali = 0
		local url = url_m3u8
		local infores = ""
		for band,res,res2,urltmp in videdata:gmatch('#EXT.X.STREAM.INF.BANDWIDTH=(%d+).-RESOLUTION=(%d+)x(%d+).-(http.-)\n') do
			local bandnum= tonumber(band)
			if res == conf.favres:match('(%d+)') then
				url = urltmp
				infores = res .. "x"..res2
				break
			end
			if bandnum > quali then
				url = urltmp
				infores = res .. "x"..res2
				quali = bandnum
			end
		end
		play(name, url,infores)
	end
end

function main_menu(links)
	hideMenu(m2)
	m = menu.new{name="YouTubeLive", icon="icon_blue"}
	m:addKey{directkey=RC["info"], id=version, action="info"}
	m:addItem{type="separator"}
	m:addItem{type="back"}
	m:addItem{type="separatorline"}
	local d = 1 -- directkey
	local dkey = 0
	dkey = godirectkey(d)
	m:addItem{type="forwarder", name=locale[conf.lang].settings, action="settings",enabled=true,id="" ,directkey=dkey}
	m:addItem{type="separatorline"}
	for i, name_url in ipairs(links) do
		d = d + 1
		dkey = godirectkey(d)
		m:addItem{type="forwarder", name=name_url:match('(.-);'), action="getvideourl",id=name_url, directkey=dkey }
	end
	m:exec()
	return MENU_RETURN.EXIT_REPAINT

end

function main()	
	main_menu(init())
	saveConfig()

end
main()
