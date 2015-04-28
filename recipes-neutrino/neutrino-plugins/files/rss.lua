--[[
	RSS READER Plugin
	Copyright (C) 2014,  Jacek Jendrzej 'satbaby'

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

--dependencies:  feedparser http://feedparser.luaforge.net/ ,libexpat,  lua-expat , luacURL for https
rssReaderVersion="Lua RSS READER v0.09c Beta"

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

function curl_get_data_from_url(url)
	local cURL = require "cURL"
	ch = cURL.easy_init()
	ch:setopt_url(url)
	ch:setopt_ssl_verifypeer(0) --disable cert curl -k
	local data = {}
	ch:perform( { writefunction = function(str) table.insert(data, str) end} )
	data = table.concat(data)
	return data;
end

function getdatafromurl(url)
	local data = nil
	local nBeginn, nEnde  

	if url:sub(1, 6) == 'https:' then
		data = curl_get_data_from_url(url)
	else
		local host,link = getDomainandLink(url)
		data = gethttpdata(host,link)
		local f =string.find(data,"HTTP/1.1 301")--remove header
		if f then
			url = data:match('Location:%s+(.-)\n')
			print(url)
			info("Use new url: "..url)
			host,link = getDomainandLink(url) 
			data = gethttpdata(host,link) --FIXME relink dont work
		end
		nBeginn, nEnde, data = string.find(data, "^.-\r\n\r\n(.*)") -- skip header
	end
	if data ~= nil then
--		fix for >>> couldn't parse xml. lxp says: junk after document element 
		nBeginn, nEnde = data.find(data, "</rss>")
		if nEnde and #data > nEnde then
			data = string.sub(data,0,nEnde)
		end
	else 
	  	print("DEBUG ".. __LINE__())
	end

	local error = nil
	require "feedparser"
	fp,error = feedparser.parse(data)
	if error then
		print("DEBUG ".. __LINE__())
		print(data) --  DEBUG
		print ("ERROR >> ".. error .. "\n###")
	end

	return fp
end

function home()
	return MENU_RETURN["EXIT"]
end

function info(infotxt)
	local h = hintbox.new{caption="Information", text=infotxt}
	h:paint()
	repeat
		msg, data = n:GetInput(500)
	until msg == RC.ok or msg == RC.home
	h:hide()
end

-- ---------------------------------------------------------------------------
function file_exists(file)
	local f = io.open(file, "rb")
	if f then f:close() end
	return f ~= nil
end

function links2_exists()
	local links2 = "/var/tuxbox/plugins/links.so"
	local check = file_exists(links2)
	if  check == false then 
		return nil 
	end

	return links2
end

function show_link_httml(id)
	local links2 = links2_exists()
	if links2 and fp.entries[tonumber(id)].link then
		os.execute(links2 .. " -g " .. fp.entries[tonumber(id)].link)
	end
end

function get_input(ct)
	local exit = false
	repeat
		msg, data = n:GetInput(500)

		if (msg == RC['up'] or msg == RC['page_up']) then
			ct:scroll{dir="up"};
		elseif (msg == RC['down'] or msg == RC['page_down']) then
			ct:scroll{dir="down"};
		elseif (msg == RC['red']) then
			exit = true
-- 		elseif (msg == RC['green']) then
-- 			ct:paint()
		end

	until msg == RC['home'] or msg == RC['setup'] or exit;
	
	return exit
end

function tounicode(c)
	c=tonumber(c)
	if c > 64 then
		c=c-64
		return "\xC3" .. string.format('%c', c)
	else
		return string.format('%c', c)
	end
end

function convHTMLentities(summary)
	if summary ~= nil then
		summary = summary:gsub("&#([0-9]+);",function(c) return tounicode(c) end)
	end
	return summary
end
function redbut(have_browser,mp4_video)
	if mp4_video then
		return "Show link Video" 
	elseif have_browser then
		return "Show link with Browser"
	end
		return nil
end
function exec(id)
	m:hide()

	local text1    = fp.entries[tonumber(id)].title;
	local text2    = fp.entries[tonumber(id)].summary;
--	print(fp.entries[tonumber(id)].link)
---------------------------------------------FIXME in feedparser ------------------------------------------------------
--	print(text2)	
	text2 = text2:gsub([[<.->]], "") -- remove  "<" alles zwischen ">"
	text2 = text2:gsub([[%s%s%s]], "") -- rmeove alle triple Leerzeichen
	text2 = convHTMLentities(text2)
-----------------------------------------------------------------------------------------------------------------------

	local txtsize = n:getRenderWidth(FONT['MENU'],text2 .."w")
	local txtsize1 = n:getRenderWidth(FONT['MENU_TITLE'],text1 .."w")

	local spacer   = 8;
	local x        = SCREEN.OFF_X;
	local y        = SCREEN.OFF_Y;
	local w        = SCREEN.END_X - x;
	local h        = SCREEN.END_Y - y;
	local fh_title = n:FontHeight(FONT['MENU_TITLE']);
	local fh_text = n:FontHeight(FONT['MENU']);
	local width = txtsize1 + (2*spacer) + 40 -- 40 for icon 
	local w_width =  math.floor((w/1.5)) 
	if( width > w_width ) then
		if(width > w) then
			w_width = w-20
		else
			w_width = width
		end 
	end

	local w_high = math.floor((h/2))
	local high = ((math.floor(txtsize / (w_width - (2*spacer)))+1) * (fh_text + 4)) + (2 * fh_title) + spacer

	if w_high > high then
		w_high = high
	end
	local y_off = math.floor((h-w_high)/2)
	local x_off =  math.floor((w-w_width)/2)

	local x1 = x + x_off
	local y1 = y + y_off
	local w1 = w_width
	local h1 = w_high 
	
	local w = nil

	local have_browser = links2_exists() ~= nil
	local mp4_url = nil
	local mp4_video = fp.entries[tonumber(id)].link:sub(#fp.entries[tonumber(id)].link-3, #fp.entries[tonumber(id)].link) == '.mp4'
	if mp4_video == true then
		mp4_url =  fp.entries[tonumber(id)].link
	elseif 	fp.entries[tonumber(id)].enclosures[1] then
		local type =fp.entries[tonumber(id)].enclosures[1].type 
		if type == 'video/mp4' or  type == 'video/mpeg' or  type == 'video/x-m4v' or  type == 'video/quicktime' then
			mp4_url = fp.entries[tonumber(id)].enclosures[1].url
			mp4_video = true
		end
	end
	w = cwindow.new{x=x1, y=y1, dx=w1, dy=h1, title=text1, has_shadow=true, btnRed= redbut(have_browser,mp4_video) };
	w:paint();
 
	x1 = x1 + spacer
	y1 = y1 + w:headerHeight()
	w1 = w1 - spacer 
	h1 = h1-(2 * w:headerHeight()) 	

	local ct = ctext.new{x=x1, y=y1, dx=w1, dy=h1, text=text2, mode="ALIGN_AUTO_WIDTH | ALIGN_AUTO_HIGH | ALIGN_TOP | ALIGN_SCROLL | DECODE_HTML", font_text=FONT['MENU']};--, color_text =0xFFFFFF00
 	ct:paint();

	local browser_mode =  get_input(ct)

	ct:hide{no_restore=true}
	w:hide{no_restore=true}
--	show link with browser
	if have_browser and browser_mode and fp.entries[tonumber(id)].link and not mp4_video then
			show_link_httml(id)
	elseif browser_mode and  mp4_video and  mp4_url then
		if mp4_url:sub(1, 6) == 'https:' then
			mp4_url =  'http' .. mp4_url:sub(6, #mp4_url)
		end
			n:PlayFile(fp.entries[tonumber(id)].title, mp4_url);
	end 
end

-- ---------------------------------------------------------------------------
function rssurlmenu(url)
	local feedpersed = getdatafromurl(url)
	if feedpersed == nil then return end 
	n = neutrino()
	d = 0 -- directkey
	m = menu.new{name=feedpersed.feed.title, icon="icon_blue"}
	m:addKey{directkey=RC["home"], id="home", action="home"}
	m:addKey{directkey=RC["info"], id="FEED Version: " .. fp.version, action="info"}
	m:addItem{type="separator"}
	m:addItem{type="back"}
	m:addItem{type="separatorline"}
	for i = 1, #feedpersed.entries do
		d = d + 1
		local _icon = ""
		local _directkey = ""
		if d == 1 then
			_icon = "rot"
			_directkey = RC["red"]
		elseif d == 2 then
			_icon = "gelb"
			_directkey = RC["yellow"]
		elseif d == 3 then
			_icon = "gruen"
			_directkey = RC["green"]
		elseif d == 4 then
			_icon = "blau"
			_directkey = RC["blue"]
		elseif d < 14 then
			_icon = d - 4
			_directkey = RC[""..d - 4 ..""]
		elseif d == 14 then
			_icon = "0"
			_directkey = RC["0"]
		else
			-- reset
			_icon = ""
			_directkey = ""
		end
		local t =""
		if fp.entries[i].updated_parsed then
		      t = os.date("%d.%m %H:%M",fp.entries[i].updated_parsed)
		end
		t= t .. " "..feedpersed.entries[i].title
		m:addItem{type="forwarder", name=t, action="exec", id=i, icon=_icon, directkey=_directkey }
	end
	m:exec()
end

function exec_url(id)
	sm:hide()
	rssurlmenu(id)
end

function start()
	local config="/var/tuxbox/config/rssreader.conf"
	feedentries = {}
	dofile(config)

	if next(feedentries) == nil then
		print("DEBUG ".. __LINE__())
		print("failed while loading " ..config)
		return
	end

	n = neutrino()
	d = 0 -- directkey
	sm = menu.new{name="Lua RSS READER", icon="icon_blue"}
	sm:addKey{directkey=RC["home"], id="home", action="home"}
	sm:addKey{directkey=RC["info"], id=rssReaderVersion, action="info"}
	sm:addItem{type="back"}
	sm:addItem{type="separatorline"}
	for v, w in ipairs(feedentries) do
		if w.exec == "SEPARATOR" then
			sm:addItem{type="separator"}
		elseif w.exec == "SEPARATORLINE" then
			sm:addItem{type="separatorline", name=w.name}
		else
			d = d + 1
			local _icon = ""
			local _directkey = ""
			if d == 1 then
				_icon = "rot"
				_directkey = RC["red"]
			elseif d == 2 then
				_icon = "gelb"
				_directkey = RC["yellow"]
			elseif d == 3 then
				_icon = "gruen"
				_directkey = RC["green"]
			elseif d == 4 then
				_icon = "blau"
				_directkey = RC["blue"]
			elseif d < 14 then
				_icon = d - 4
				_directkey = RC[""..d - 4 ..""]
			elseif d == 14 then
				_icon = "0"
				_directkey = RC["0"]
			else
			  -- reset
				_icon = ""
				_directkey = ""
			end
			sm:addItem{type="forwarder", name=w.name, action="exec_url", id=w.exec, icon=_icon, directkey=_directkey }
		end
	end
	sm:exec()
end

start()
