-- satbaby 25.03.2016
local json = require "json"

if #arg < 1 then return nil end
local _url = arg[1]
local ret = {}

function getdata(Url,Postfields,pass_headers)
	if Url == nil then return nil end
	if Curl == nil then
		Curl = curl.new()
	end
	local ret, data = Curl:download{ url=Url, A="Mozilla/5.1", postfields=Postfields,header=pass_headers }
	if ret == CURL.OK then
		return data
	else
		return nil
	end
end

function getVideoData(id)
	if id == nil then return 0 end
	local jnTab = nil
	local h,data=nil,nil
	local hosturl = 'http://www.telewizjada.net/'

	data= getdata(hosturl .. 'get_mainchannel.php','cid='..id,0)
	if data == false then
		return 0
	end
	jnTab = json:decode(data)
	if jnTab.online == 0 then
		return 0
	end
	local name = ""
	if jnTab.displayName then
		name  = jnTab.displayName
	end
	local url =hosturl .. "set_cookie.php"
	data= getdata(url,"url="..jnTab.url,true)
	local tmp = data:match('sessid=(.-);')
	local sessid = "" 
	local msec = ""
	if tmp then
		sessid = tmp
	end
	tmp = data:match('msec=(.-);')
	if tmp then
		msec = tmp
	end

	data= getdata(hosturl .. 'get_channel_url.php','cid='..id,0)
	if data == false then
		return 0
	end
	jnTab = json:decode(data)
	if jnTab.url then
		entry = {}
		entry['url']  = jnTab.url
		entry['name'] = name
		entry['header'] = 'Cookie: msec='.. msec .. ';sessid=' .. sessid
		entry['band'] = "1"-- dummy
		entry['res1'] = "720"
		entry['res2'] = "576"
		ret[1] = {}
		ret[1] = entry
		return 1
	end
	return 0
end

if (getVideoData(_url) > 0) then
	return json:encode(ret)
end

return ""
