--[[
	WDR Rockpalast-App
	Vers.: 0.3
	Copyright (C) 2016, bazi98, SatBaby

        App Description:
        There the player links are respectively read about the recent news reports of the NRW German Television "WDR"
        from the WDR library, displays and allows them to play with the neutrino-movie player.

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

        Copyright (C) for the linked videos and for the Rockpalast-Logo by the WDR or the respective owners!
]]

local json = require "json"

--Objekte
function script_path()
	local str = debug.getinfo(2, "S").source:sub(2)
	return str:match("(.*/)")
end

function init()
	n = neutrino();
	p = {}
	func = {}
	pmid = 0
	stream = 1
        tmpPath = "/tmp"
	rockplast = decodeImage("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACsAAAAYCAYAAABjswTDAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYdEVYdFNvZnR3YXJlAHBhaW50Lm5ldCA0LjAuOWwzfk4AAAT2SURBVFhH7ZZ5SN9lHMd/P+/7zHm15tThhcc0xXmgA4cGzpQmamKmuRSHB2rMo/DAowlNNpcahuKZB97Di5UgBv1RSWJUIgYDi/oji6Ko1j69Px/8/XDru7YfTgbRAy+e5/k83+P9fI7n+1X93x5f07e1tbUODw833Z8/sWYMXA0MDJ5F/zwoBI2gFyyBL8DParX6DvqXwZE0NbA2MjLy0dfXjzM0NHwJ8ypwA0yCj8A3gEXc3YceQg3QqekBDscz4AyEvACvFEHMm5gPgPcBe+Mn8CgCdOFtoG2G4CngD+JBrp6e3usQ1Il+BvNPwffgD/CvQkxNTSkoKIhSU1Pp0qVLFBoaqnidjkwDaV+C38CjhuQfuLi4UFFREU1OTtLs7Cw1NjZSX18fra+vk6enp+I9uoC8/ZiIOL1UXx9c0AUfHx8aHR2loaEhSkpKIhMTE0JqUH19PW1ublJxcTHV1dXRtWvXqKOjg65evUqVlZUUFham+LwHgejuolerEOoP2YCCkJCVl5eLgIWFBUpMTFS8WQOOFHJycrrHFhMTQwMDA1RWVkbnz5+n4OBgOnHihHjf3d2dIiMjKS4u7p57HgY8+zt6AxUGY2yorq4WL5w9e5bMzMzo9OnT1NXVpXizhuvXr5Ovr6/i2oNISUkRjyutHcTLy+t+29Mstu2gsbCwkLKzs2lra0s8obHb2NiQo6OjlmPHjlFISAg1NzeTtbU1eXh4yHUcIe5PnTpFlpaWMjY3NydjY2MZj42NkZWVlYx5HaeJjBlOI419aWmJjh8/rn0GOANUr+1P2N1SIIGBgVRaWkozMzNi8/b2pqamJtrb26Pu7m7a3d2liYkJCfHOzg5NT0/TxsaGPJiLan5+XgqMI5OWliYptbKyQs7OznItP5Odwu+6deuWiEdeyr3nzp2T9Nve3qa2tjZKTk7WiL0AVC/uT7Riuef53NycFBGHm+cNDQ2Sh5zTPD958qSsce729vaKl/jl7KH8/HzKzMwUD7GQ+Ph4KikpEbGcZjdv3pT3cBR5Q7GxsdTa2krLy8vaTWl07VMMVDEaw0GxfF5OTU1RVFQUXb58WdYvXrxIFRUVUtU8Z7G8e/Y2FyeL5eMLRSsvZdH8DL42ICBATgkW4eDgQD09PWLnTbCXh4eHRSSf0e3t7UpirwCVp8bg5+cnnuCxv78/ra6uSiqsra1JwS0uLsqLuI+OjpZNsFg3NzeJQkFBgfR8IrS0tIjHbt++LaHl+8fHx+VI4+OL7REREZSQkECDg4PU398v+c73cMpx6uTl5Yloe3t7duAgi7UAf+Xm5lJnZ6fkJ4tlr+Xk5JCFhYVsgl/OBcVrXGB8cmRlZUlasI1zKyMjQzzJ4kdGRiQSrq6uVFNTI/nNJw7XAovnI6+2tlbsHC07OztxUFVVlUSEr0lPT9cWHcSuqPBZ1EdO/cCGw6JJA6W1wwKxX6HHp0Gt3tQYD8MRib0LZ/4CjZ9jLG0BKF2oE1xYnI9Kaw/gT/AdxHwGMfMYvwvqQT5IBEHAFjVggF7+DbjxRUoPOwy/gm2IWAXvYfwWKAPpIBq4ASOg1vykPGrj3Si98H74r4y/09+CT8AcflzegWfeAK9g/hwIAPaA/3+PpL2K3d8BP2LMifwB4KPiCs7bEoT3AkSFY+4KTIBOnnisDZ83M/yQ8BHG3nhyQv47TaX6G9OMz5CnBF8RAAAAAElFTkSuQmCC")
end

function add_stream(t,u)
  p[#p+1]={title=t,url=u,access=stream}
end

function getdata(Url,outputfile)
	if Url == nil then return nil end
	if Curl == nil then
		Curl = curl.new()
	end
	local ret, data = Curl:download{url=Url,A="Mozilla/5.0;",followRedir=true,o=outputfile }
	if ret == CURL.OK then
		return data
	else
		return nil
	end
end

-- function from http://lua-users.org/wiki/BaseSixtyFour

-- character table string
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

-- decode
function dec(data)
	data = string.gsub(data, '[^'..b..'=]', '')
	return (data:gsub('.', function(x)
    	if (x == '=') then return '' end
    	local r,f='',(b:find(x)-1)
    	for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
    	return r;
	end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
    	if (#x ~= 8) then return '' end
    	local c=0
    	for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
    	return string.char(c)
	end))
end

function decodeImage(b64Image)
	local imgTyp = b64Image:match("data:image/(.-);base64,")
	local repData = "data:image/" .. imgTyp .. ";base64,"
	local b64Data = string.gsub(b64Image, repData, "");

	local tmpImg = os.tmpname()
	local retImg = tmpImg .. "." .. imgTyp

	local f = io.open(retImg, "w+")
	f:write(dec(b64Data))
	f:close()
	os.remove(tmpImg)

	return retImg
end

-- UTF8 in Umlaute wandeln
function conv_str(_string)
	if _string == nil then return _string end
	_string = string.gsub(_string,"&amp;","&");
	return _string
end

function fill_playlist() --- > begin playlist

--- WDR Rockpalast
	local data = getdata('http://www1.wdr.de/mediathek/video/sendungen/rockpalast/rockpalast-106.html',nil) 
	if data then
         for  rockpalast_seite,title  in  data:gmatch('headline.-<a href="(/mediathek/video/sendungen/rockpalast/video%-rockpalast.-%d+.html)".-title="(.-)">')  do
                if rockpalast_seite and title  then
                       add_stream(conv_str(title), 'http://www1.wdr.de'.. rockpalast_seite) 
                end
            end
	end
--end WDR Rockpalast
end --- > end of playlist

function set_pmid(id)
  pmid=tonumber(id);
  return MENU_RETURN["EXIT_ALL"];
end

function select_playitem()
  local m=menu.new{name="WDR: Rockpalast", icon=rockplast} 
  for i,r in  ipairs(p) do
    m:addItem{type="forwarder", action="set_pmid", id=i, icon="streaming", name=r.title, hint=r.title, hint_icon="hint_reload"}
  end  
  repeat
    pmid=0
    m:exec()
    if pmid==0 then
      return
    end  

    local vPlay = nil 
    local url=func[p[pmid].access](p[pmid].url)
    if url~=nil then
      if  vPlay  ==  nil  then
	vPlay  =  video.new()
      end
	local js_data = getdata(url,nil)
	local js_url = js_data:match("'(http://.-/ondemand/.-.js)'")
	js_data = getdata(js_url,nil)
	local video_url = js_data:match('"alt":{"videoURL":"(http.-%.csmil/)master.m3u8"')
	local titel = js_data:match('trackerClipTitle":"(.-)",')
	if titel == nil then
		titel = p[pmid].title
	end
	if video_url then
		video_url = video_url .. "index_2_av.m3u8"
		vPlay:PlayFile("WDR: Rockpalast",video_url ,titel,video_url);
	else
		print("Video URL not  found")
	end
   end
  until false
end

--Main
init()
func={
  [stream]=function (x) return x end,
}
fill_playlist()
select_playitem()
os.execute("rm /tmp/lua*.png");
