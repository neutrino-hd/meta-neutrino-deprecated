-------- oklivetv switzerland 30 12 2015

local Curl = nil
local V = nil
local m = nil
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

function download(Url)
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

function getvideourl(url)
	local name=string.gsub(url,'-',' ')
	local feed_data=download('http://oklivetv.com/' ..  url)
	if feed_data then
		local urlvid = feed_data:match("<div%s+class=\"screen fluid%-width%-video%-wrapper\">.-src='(.-)'.-</div>")
		feed_data=download(urlvid)
		local url_m3u8 = feed_data:match('|URL|%d+|%d+|%d+|%d+|m3u8|(.-)|bottom')
		if url_m3u8 then
			feed_data=download("http://46.101.171.43/live/" .. url_m3u8 .. ".m3u8")
			if feed_data == nil then
				return
			end
		else
			return
		end
		local quali = 0
		local url = url_m3u8
		for band,urltmp in feed_data:gmatch('BANDWIDTH=(%d+),RESOLUTION=%d+x%d+.-(http.-)\n') do
			local bandnum= tonumber(band)
			if bandnum > quali then
				url = urltmp
				quali = bandnum
			end
		end
		if V == nil then
			V   = video.new()
		end
		if V and m and url then
			m:hide()
			V:setSinglePlay(true)
 			V:PlayFile(name, url)
		end
	end
end

function main()
	m = menu.new{name="OKLIVETV", icon="icon_blue"}
	m:addItem{type="separator"}
	m:addItem{type="back"}
	m:addItem{type="separatorline"}
	local d = 0 -- directkey
	local ch_feeds= { "das-erste-live", "zdf-live", "3sat-live", "arte-germany-live"
	  , "zdf-infokanal-live", "zdf-neo-live", "kika-live", "nickelodeon-germany-live"
		, "kabel-eins-live", "prosieben-pro7-live", "prosieben-pro7-maxx-live"
		, "orf-eins-live", "orf-2-live", "srf-1-tv-live", "srf-zwei-live", "3-plus-tv-live"
		, "4-plus-tv-live", "5-plus-tv-live", "srf-info-live", "mtv-schweiz-live" }
	for i, feed in ipairs(ch_feeds) do
		d = d + 1
		local dkey = godirectkey(d)
		m:addItem{type="forwarder", name=string.gsub(feed,'-',' '), action="getvideourl",id=feed, directkey=dkey }
	end
	m:exec()
	return MENU_RETURN.EXIT_REPAINT
end
main()
