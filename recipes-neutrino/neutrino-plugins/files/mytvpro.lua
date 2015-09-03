--[[
 MyTvPro Plugin
 
 Copyright (C) 2015 Celeburdi (intm@freestart.hu) from coolstream.to
  
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
 Install:
   copy mytvpro.* files to /var/tuxbox/plugins + (Reload plugins)
 
 Start:
   blue key -> MyTvPro -> select channel
   
 Stop play:
   stop key   
  
 History
  2015.09.01 v1.2
   - GPL licence
   - (optional) curl binary for nevis (copy to /bin)
  2015.08.31 v1.1 (filmon forbidden)
  2014.10.06 Beta 2

]]


function init()
	n = neutrino();
	p = {}
	accfunc = {}
	pmid = 0
	accdefault = 1
	accfilmonsd = 2
	accfilmonhd = 3
	accahhbbtv = 4 
end

function add_ch_default(t,u)
  p[#p+1]={title=t,url=u,access=accdefault}
end

function add_ch_filmonsd(t,u)
  p[#p+1]={title=t,url=u,access=accfilmonsd}
end

function add_ch_filmonhd(t,u)
  p[#p+1]={title=t,url=u,access=accfilmonhd}
end

function add_ch_ahhbbtv(t,u)
  p[#p+1]={title=t,url=u,access=accahhbbtv}
end


function fill_playlist()
  add_ch_filmonhd("BBC News",27)
  add_ch_filmonhd("BBC One",14)
  add_ch_filmonhd("BBC 1 North Ireland",361)
  add_ch_filmonhd("BBC 1 North Scotland",3166)
  add_ch_filmonhd("BBC Two",25)
  add_ch_filmonhd("CBBC/BBC Three",113)
  add_ch_filmonhd("CBEEBIES/BBC Four",103)
  add_ch_filmonhd("Channel 4",2)
  add_ch_filmonhd("Channel 5",22)
  add_ch_filmonhd("Dave",370)
  add_ch_filmonhd("E4",65)
  add_ch_filmonhd("Fashion TV",21)
  add_ch_filmonhd("Travel Channel+1",842)
  add_ch_filmonhd("Film4",13)
  add_ch_filmonhd("ITV",11)
  add_ch_filmonhd("ITV+1",1817)
  add_ch_filmonhd("ITV2",67)
  add_ch_filmonhd("ITV2+1",1820)
  add_ch_filmonhd("ITV3",26)
  add_ch_filmonhd("ITV3+1",1823)
  add_ch_filmonhd("ITV4",101)
  add_ch_filmonhd("ITV4+1",1826)
  add_ch_filmonhd("Levant TV",3178)
  add_ch_filmonhd("Quest",2707)
  add_ch_filmonhd("Yesterday",1039)
  add_ch_filmonhd("CBS Drama",1805)
  add_ch_filmonhd("CBS Reality",1808)
  add_ch_filmonhd("CBS Reality+1",1811)
  add_ch_filmonhd("More4",97)
  add_ch_filmonhd("Really",372)
  add_ch_filmonhd("5USA",845)
  add_ch_filmonhd("Pick TV",371)
  add_ch_filmonhd("4Music",95)
  add_ch_filmonhd("Viva Usa",8)
  add_ch_filmonhd("Zdf_Neo",360)
  add_ch_filmonhd("Zdf.kultur",359)
  add_ch_filmonhd("KIKA",2756)
  add_ch_filmonhd("ZDF",2759)
  add_ch_filmonhd("ZDF INFOKANAL",2762)
  add_ch_filmonhd("Eurosport Deutschland",2771)
  add_ch_filmonhd("Euronews German",2903)
  add_ch_filmonhd("Phoenix",424)
  add_ch_filmonhd("Tagesschau24",415)
  add_ch_filmonhd("Eins Festival",421)
  add_ch_filmonhd("Eins Plus",418)
  add_ch_filmonhd("France2",1717)
  add_ch_filmonhd("France3",1723)
  add_ch_filmonhd("France5",1720)
  add_ch_filmonhd("Arte France",1729)
  add_ch_filmonhd("France24",298)
  add_ch_filmonhd("Al Jazeera",4)
  add_ch_filmonhd("Action Cinema",500)
  add_ch_filmonhd("Sci-Fi Telly",382)
  add_ch_filmonhd("Threshold",514)
  add_ch_filmonhd("American Primetime Television",707)
  add_ch_filmonhd("NWA Wrestling Television",373)
  add_ch_filmonhd("Horror Channel",836)
  add_ch_filmonhd("Jazz and Blues",530)
  add_ch_filmonhd("MiamiTV",866)
  add_ch_filmonhd("Zuus Country",342)
  add_ch_filmonhd("iFlix TV",1991)
  add_ch_filmonhd("ShockMasters",2716)
  add_ch_filmonhd("Inspirational Films",503)
  add_ch_filmonhd("Jazz TeeVee",1687)
  add_ch_filmonhd("Rock Titan",2942)

  add_ch_filmonhd("Filmon TV Live",689)
  add_ch_filmonhd("FilmOn Jazz and Blues",530)
  add_ch_filmonhd("FilmOn Tennis",1948)
  add_ch_filmonhd("FilmOn Football",374)


  add_ch_filmonhd("Irany TV (hun)",3137)


  add_ch_default("Kiss TV","rtmp://tst.es.flash.glb.ipercast.net/tst.es-live/live") 
  add_ch_default("Virgin Radio TV","rtmp://fms.105.net/live/virgin1") 
  add_ch_default("Beatz 1","rtmp://rtmp.infomaniak.ch/livecast/beats_1") 
  add_ch_default("Euronews (eng)","rtsp://ewns-hls-p-stream.hexaglobe.net/rtpeuronewslive/en_vidan750_rtp.sdp") 
  add_ch_default("Euronews (deu)","rtsp://ewns-hls-p-stream.hexaglobe.net/rtpeuronewslive/de_vidan750_rtp.sdp") 

  add_ch_default("Euronews (hun)","rtsp://ewns-hls-p-stream.hexaglobe.net/rtpeuronewslive/hu_vidan750_rtp.sdp") 
  add_ch_default("FixTV hd (hun)","rtmp://video.fixhd.tv/fix/hd.stream") 
  add_ch_default("FixTV sd (hun)","rtmp://video.fixhd.tv/fix/sd.stream") 
  add_ch_default("ATV Hungary (hun)","rtmp://195.228.75.100/atvliveedge/_definst_/atvstream_2_aac") 
  add_ch_default("Budapest TV (hun)","rtmp://91.82.85.44/relay20/bptv.sdp") 
  add_ch_default("Dunaujvaros TV (hun)","rtmp://91.82.85.71/liverelay/dstv.sdp") 
  add_ch_default("Fehervar TV (hun)","rtmp://91.82.85.71/liverelay/fehervartv.sdp") 
  add_ch_default("Gyongyos TV (hun)","rtmp://91.82.85.41/liverelay/gyongyostv.sdp") 
  add_ch_default("Gyor TV (hun)","rtmp://91.82.85.44/liverelay/gyorplusz.sdp") 
  add_ch_default("Szombathely TV (hun)","rtmp://91.82.85.71/liverelay/sztv.sdp") 
  add_ch_default("Zalaegerszeg TV (hun)","rtmp://91.82.85.41/liverelay/zegtv.sdp") 

-- add_ch_ahhbbtv("Fishing and Hunting (hun)","pvtv")
-- add_ch_ahhbbtv("iConcerts","iconcerts")

   
end


function get_filmonlink(ch_id,ch_res)
	local lfnresponse = "/tmp/mytvpro_resp.txt";
  local lagent = '"User-Agent: Mozilla/5.0"';     
	os.execute("wget -U " .. lagent .. " -O " .. lfnresponse .. " http://www.filmon.com/tv/channel/info/" .. ch_id );

	local fp = io.open(lfnresponse, "r")
	if fp == nil then
		print("Error opening file '" .. lfnresponse .. "'.")
		return nil
	end
	local s=fp:read("*a")
	fp:close()
	local i,j=s:find('"low","url":"http')
	if j == nil then
		i,j = s:find('"high","url":"http')
		if j == nil then
  		print("url error")
	  	return nil
	  end
	  ch_res = "high"	
	end
	
	local k=j+1;  
	
	i,j=s:find("live\\/",k)
	if j == nil then
	  print('live\\/ error')
	  return nil
	end
	local url=s:sub(k,j):gsub("\\/","/")
	i,j=s:find('?',j+1)
	if i == nil then
		print("? error")
		return nil
	end
	k=i;
	i,j=s:find('"',k)
	if i == nil then
		print('" error')
		return nil
	end
	return "rtmp" .. url .. s:sub(k,i-1) .. "/" .. ch_id .. "." .. ch_res .. ".stream"
end

function get_ahhbbtvlink(ch_id)
	-- not works: panic! ffmpeg crash
	-- copy curl to /bin (and set attrib 755) 
	local lfnresponse = "/tmp/mytvpro_resp.txt";
	local lfncookie = "/tmp/mytvpro_cookie.txt";

    
	os.execute("curl --cookie-jar " .. lfncookie .. " http://hbbtv-as-dtx.connectmedia.hu/ah/launcher/index.php" );
	os.execute("curl -o " .. lfnresponse .. " --cookie "  .. lfncookie .. " http://hbbtv-as-dtx.connectmedia.hu/ah/getstreamurl.php?id=" .. ch_id );

	local fp = io.open(lfnresponse, "r")
	if fp == nil then
		print("Error opening file '" .. lfnresponse .. "'.")
		return nil
	end
	local s=fp:read("*a")
	fp:close()
	return s
end



function set_pmid(id)
  pmid=tonumber(id);
  return MENU_RETURN["EXIT_ALL"];
end

function select_playitem()
local m=menu.new{name="MyTVPro Channels"}
  for i,r in  ipairs(p) do
    m:addItem{type="forwarder", action="set_pmid", id=i, name=r.title}
  end  
  repeat
    pmid=0
    m:exec()
    if pmid==0 then
      return
    end  
    local url=accfunc[p[pmid].access](p[pmid].url)
    if url~=nil then
      n:PlayFile(p[pmid].title,url)
    end
  until false
end

--Main
init()
accfunc={
  [accdefault]=function (x) return x end,
  [accfilmonsd]=function (x) return get_filmonlink(x,"low") end,
  [accfilmonhd]=function (x) return get_filmonlink(x,"high") end,
  [accahhbbtv]=function (x) return get_ahhbbtvlink(x) end
}
fill_playlist()
select_playitem()
os.execute("rm /tmp/mytvpro_*.*");
