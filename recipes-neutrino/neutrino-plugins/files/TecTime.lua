function __LINE__() return debug.getinfo(2, 'l').currentline end
local json = require "json"

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
function curl_get_data_from_url(url)
	local cURL = require "cURL"
	local function fetch(url)
		local res = {}
		local res_code, res_message = "500", ""
	
		curl = cURL.easy_init()
		curl:setopt_url(url)
		curl:setopt_header(0)
		curl:setopt_timeout(2)
		curl:setopt_ssl_verifypeer(0)
		curl:setopt_ssl_verifyhost(0)
		curl:setopt_followlocation(1)
		curl:setopt_maxredirs(10)
		curl:perform({
			headerfunction = function(s)
				local code, message = string.match(s, "^HTTP/.* (%d+) (.+)$")
				if code then res_code, res_message = code, message end
			end,
			writefunction = function(buf) table.insert(res, buf) end
		})		
	 	if res_code == "200" then return true, table.concat(res)
		else return false, res_code .. ": " .. res_message end
	end

	local ok, r1, r2 = pcall(fetch, url)
	if ok then return r1, r2 else return ok, r1 end
end

function main()
	local url="https://www.youtube.com/watch?v=dvblFe1W5Q8"
	local res,data = curl_get_data_from_url(url)
	if res then
		local m3u_url = data:match('hlsvp.:.(https:\\.-m3u8)') 
		m3u_url = m3u_url:gsub("\\", "")
		local res,videdata= curl_get_data_from_url(m3u_url)
		if res then
			for line in string.gmatch(videdata,'[^\r\n]+') do 
				if( string.find( line, "itag/96" ) ) then
					local n = neutrino()
					n:PlayFile("TecTime", line);
				end
			end
		end
	end
end

main()
