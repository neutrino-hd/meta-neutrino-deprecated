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
   blue key -> MyTvPro -> Settings / Select channel
   
 Stop play:
   stop key   
  
 History
 2016.02.19 v1.6
 -oklivetv update
 2016.02.07 v1.5
 - MindigTV Extra Hungarian channels (Vintage,M4 Sport, Euronews) - Hungarian ip addr. required
 - Channels maintenance (filmon: sport1,RFI LA, ..) 
 2016.01.24 v1.4
   - oklivetv (satbaby)
   - AhHbbtv update 
 2015.09.05 v1.3
  - hint icon (from fred_feuerstein)
  - filmon rtmp mode on/off (rtmp mode=off faster start, older ffmpeg version crashes) 
  - MTVA (hun) channels
  - MindigTV HbbTV (hun) channels (call curl)  
  2015.09.01 v1.2
   - GPL licence
   - (optional) curl binary for nevis (copy to /bin if not exists)
  2015.08.31 v1.1 (filmon forbidden)
  2014.10.06 Beta 2

]]


function init()
	n = neutrino();
	p = {}
	settings = {}
	settings["filmon_rtmp_mode"]="off"
	accfunc = {}
	pmid = 0
	accdefault = 1
	accfilmonsd = 2
	accfilmonhd = 3
	accahhbbtv = 4
	accmtva = 5
	accoklivetv = 6
	accmindigtv = 7
	
	--menuicon="mytvpro"
  scriptpath = debug.getinfo(2, "S").source:sub(2):match("(.*/)")
  inifile = scriptpath .. "mytvpro.ini"
  respfile = "/tmp/mytvpro_resp.txt"
  cookiefile = "/tmp/mytvpro_cookie.txt"
 
  mozilla =  "Mozilla/5.0"
  android = "Android"
  
  mindigtvm3u8={"01.m3u8","VID_854x480_HUN.m3u8","VID_704x396_HUN.m3u8"}
  --os.execute("cp -f " .. scriptpath .. menuicon .. ".png /share/tuxbox/neutrino/icons")
end

function loadsettings()
	local fp = io.open(inifile, "r")
  local i,j
  if fp==nil then
    return
  end
  local line = fp:read()
  while line~=nil do
    for k in pairs(settings) do
      i,j=line:find(k.."=")
      if i then
        settings[k]=line:sub(j+1)
      end
    end
    line=fp:read()
  end
end;

function savesettings()
	local fp = io.open(inifile, "w")
  for k,v in pairs(settings) do
    fp:write(k .."=" .. v)
    fp:write("\n")
  end
  fp:close()
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

function add_ch_mtva(t,u)
  p[#p+1]={title=t,url=u,access=accmtva}
end

function add_ch_oklivetv(t,u)
  p[#p+1]={title=t,url=u,access=accoklivetv}
end

function add_ch_mindigtv(t,u)
  p[#p+1]={title=t,url=u,access=accmindigtv}
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
  add_ch_filmonhd("5*",851);
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
  add_ch_filmonhd("ITVBe",3211)
   add_ch_filmonhd("Levant TV",3178)
  add_ch_filmonhd("Quest",2707)
  add_ch_filmonhd("Yesterday",1039)
  add_ch_filmonhd("CBS Drama",1805)
  add_ch_filmonhd("CBS Reality",1808)
  add_ch_filmonhd("CBS Reality+1",1811)
  add_ch_filmonhd("CBS Action",1952)
  add_ch_filmonhd("More4",97)
  add_ch_filmonhd("Really",372)
  add_ch_filmonhd("5USA",845)
  add_ch_filmonhd("Pick TV",371)
 add_ch_filmonhd("truTV",3707)
 
add_ch_filmonhd("FightBox (demo 3 min)",1621)
--add_ch_filmonhd("Kino Polska Muzika (demo 3 min)",3770)
  
  --add_ch_filmonhd("Your Family Entertainment",2734)
  --add_ch_filmonhd("4Music",95)
 -- add_ch_filmonhd("Viva Usa",8)
  
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
  add_ch_filmonhd("Sport1",4121)
  
  
  add_ch_filmonhd("France2",1717)
  add_ch_filmonhd("France3",1723)
  add_ch_filmonhd("France5",1720)
  add_ch_filmonhd("Arte France",1729)
  add_ch_filmonhd("France24",298)
  
  add_ch_filmonhd("SRF1",3908)
  add_ch_filmonhd("RSI LA1",3917)
  
  
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
 add_ch_filmonhd("International Jazz Radio",3503)

  add_ch_filmonhd("Live Boxing",1864)
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

  add_ch_oklivetv("mtv schweiz","mtv-schweiz-live")
  add_ch_oklivetv("srf 1","srf-1-tv-live")
  add_ch_oklivetv("srf zwei","srf-zwei-live")
  add_ch_oklivetv("3 plus","3-plus-tv-live")
  add_ch_oklivetv("4 plus","4-plus-tv-live")
  add_ch_oklivetv("5 plus","5-plus-tv-live")
  add_ch_oklivetv("orf eins","orf-eins-live")
  add_ch_oklivetv("orf 2","orf-2-live")
   add_ch_oklivetv("das erste","das-erste-live")
   add_ch_oklivetv("zdf","zdf-live")
   add_ch_oklivetv("kabel eins","kabel-eins-live")
   add_ch_oklivetv("prosieben","prosieben-pro7-live")
   add_ch_oklivetv("srf info","srf-info-live")
   add_ch_oklivetv("nickelodeon schweiz","nickelodeon-germany-live")
   add_ch_oklivetv("viva germany","viva-germany-live")
   add_ch_oklivetv("the box uk","the-box-uk-live")

  add_ch_default("Euronews (hun)","rtsp://ewns-hls-p-stream.hexaglobe.net/rtpeuronewslive/hu_vidan750_rtp.sdp") 
  add_ch_default("FixTV hd (hun)","rtmp://video.fixhd.tv/fix/hd.stream") 
  add_ch_default("FixTV sd (hun)","rtmp://video.fixhd.tv/fix/sd.stream") 
  add_ch_default("ATV Hungary (hun)","rtmp://195.228.75.100/atvliveedge/_definst_/atvstream_2_aac") 
 add_ch_default("Hir TV (hun)","http://streamserver.mno.netrix.hu/hls_live/live_ep_512k.m3u8") 
  add_ch_default("Hatos csatorna (hun)","http://hatoscsatorna.hu:1935/Hatoscsatorna/livestream/playlist.m3u8") 
  add_ch_default("Bonum TV (hun)","http://cdn.y5.hu/stream/bonum/hls/stream.m3u8") 

  add_ch_default("Budapest TV (hun)","rtmp://91.82.85.44/relay20/bptv.sdp") 
  add_ch_default("Dunaujvaros TV (hun)","rtmp://91.82.85.71/liverelay/dstv.sdp") 
  add_ch_default("Fehervar TV (hun)","rtmp://91.82.85.71/liverelay/fehervartv.sdp") 
  add_ch_default("Gyongyos TV (hun)","rtmp://91.82.85.41/liverelay/gyongyostv.sdp") 
  add_ch_default("Gyor TV (hun)","rtmp://91.82.85.44/liverelay/gyorplusz.sdp") 
  add_ch_default("Szombathely TV (hun)","rtmp://91.82.85.71/liverelay/sztv.sdp") 
  add_ch_default("Zalaegerszeg TV (hun)","rtmp://91.82.85.41/liverelay/zegtv.sdp") 

  add_ch_mtva("Duna TV HD","dunalive,2000000")
  add_ch_mtva("Duna World TV HD","dunaworldlive,2000000")
  add_ch_mtva("M1 HD","mtv1live,2000000")
  add_ch_mtva("M2 HD","mtv2live,2000000")
  --add_ch_mtva("M4 HD","mtv4live,2000000") 
  add_ch_mtva("Duna TV SD","dunalive,1000000")
  add_ch_mtva("Duna World TV SD","dunaworldlive,1000000")
  add_ch_mtva("M1 SD","mtv1live,1000000")
  add_ch_mtva("M2 SD","mtv2live,1000000")

 add_ch_ahhbbtv("Fishing and Hunting (hun)","pvtv")
 --add_ch_ahhbbtv("iConcerts","iconcerts")
 add_ch_ahhbbtv("C Music TV (hun)","cmusic")

  add_ch_mindigtv("Vintage","http://api.mindigtv.appsters.me/v1/1/hu/content/streams_by_channel/1111465/hls.json,1");
  add_ch_mindigtv("M4 sport (hun)","http://api.mindigtv.appsters.me/v1/1/hu/content/streams_by_channel/1111454/hls.json,2");
  add_ch_mindigtv("Euronews (hun)","http://chkhu.connectmedia.hu/6119/index_hu.m3u8,-3");


end

function geturlandbw(u)
  local i,j=u:find(',')
  if i then
    return u:sub(0,i-1),tonumber(u:sub(j+1))
  end
  return u,0
end

function readresponse()
  local fp = io.open(respfile, "r")
  if fp == nil then
    return nil
  end
  local s=fp:read("*a")
  fp:close()
  return s 
end

function download(url,agent)
  os.execute('wget -U "' .. agent .. '" -O ' .. respfile .. ' "' .. url .. '"');
  return readresponse(); 
end

function get_oklivetvlink(url)

  local feed_data=download('http://oklivetv.com/' ..  url,mozilla) 
  if feed_data==nil then
    return
  end
  local urlvid = feed_data:match("<div%s+class=\"screen fluid%-width%-video%-wrapper\">.-src='(.-)'.-</div>")
 if urlvid==nil then
   return
  end
 feed_data=download(urlvid,mozilla)
  local url_m3u8 = feed_data:match('|URL|%d+|%d+|%d+|%d+|m3u8|(.-)|bottom')
  if url_m3u8==nil then
    return
  end
  feed_data=download("http://46.101.231.222/live/" .. url_m3u8 .. ".m3u8",mozilla)
 
  if feed_data == nil then
    return
  end
  local quali = 0
  for band,urltmp in feed_data:gmatch('BANDWIDTH=(%d+),RESOLUTION=%d+x%d+.-(http.-)\n') do
    local bandnum= tonumber(band)
	if bandnum > quali then
	  url_m3u8  = urltmp
       quali = bandnum
    end
  end   
  return url_m3u8
end

function get_filmonlink(ch_id,ch_res)
  local s=download("http://www.filmon.com/tv/channel/info/" .. ch_id,mozilla );
  if s==nil then
    return
  end	
	local i,j=s:find('"low","url":"http')
	if j == nil then
		i,j = s:find('"high","url":"http')
		if j == nil then
	  	return nil
	  end
	  ch_res = "high"	
	elseif s:find('"high","url":"http')==nil then
	  ch_res = "low"
	end  
	local k=j+1;  
	
	i,j=s:find("live\\/",k)
	if j == nil then
	  return nil
	end
	local url=s:sub(k,j):gsub("\\/","/")
	i,j=s:find('?',j+1)
	if i == nil then
		return nil
	end
	k=i;
	i,j=s:find('"',k)
	if i == nil then
		return nil
	end
	if settings["filmon_rtmp_mode"]=="on" then
	  return "rtmp" .. url .. s:sub(k,i-1) .. "/" .. ch_id .. "." .. ch_res .. ".stream"
  else
    return "http" .. url .. ch_id .. "." .. ch_res .. ".stream/playlist.m3u8" .. s:sub(k,i-1)
  end   
end


function get_mtvalink(u)

  local ch_id,ch_bw = geturlandbw(u);
  
	local s=download("http://admin.gamaxmedia.hu/player-inside-full?streamid=" .. ch_id .. "&userid=mtva",mozilla);
	
 	i,j=s:find('file')
	if j == nil then
	  return nil
	end
	i,j=s:find('http',j+1)
	if i == nil then
	  return nil
	end
	k=i;
	
	i=s:find("'",j+1)
  
  s=s:sub(k,i-1)
  
  i=s:find("/[^/]*$")

  local urlbase=s:sub(0,i)
  
  
	os.execute('wget -U "' .. mozilla  .. '" -O ' .. respfile .. ' "' .. s .. '"');

	fp = io.open(respfile, "r")
	if fp == nil then
		print("Error opening file '" .. respfile .. "'.")
		return nil
	end
	
	local line=fp:read()
  local bw
  local sbw=0
  local surl=""	
	while line~=nil do
	  i,j=line:find("#EXT%-X%-STREAM%-INF:")
    if i~=nil then
      line=line:sub(j+1)
 		  i,j=line:find("BANDWIDTH=")
 		  if i~=nil then
        line=line:sub(j+1)
        i=line:find(",")
 		  	if i then
 		  	  line=line:sub(0,i-1)
        end
        bw=tonumber(line)
        if (bw>=ch_bw) and ((sbw==0)or(sbw>bw)) then
          sbw=bw
          surl=fp:read()
        end
 	  	end  
	  end
	  line=fp:read()
	end
  return urlbase .. surl
end

function get_ahhbbtvlink(ch_id)
	-- not works: panic! ffmpeg crash
	-- copy curl to /bin (and set attrib 755) 

	os.execute("curl --cookie-jar " .. respfile .. " http://hbbtv-as.connectmedia.hu/ah/launcher/index.php" );
	os.execute("curl -o " .. respfile .. " --cookie "  .. cookiefile .. " http://hbbtv-as.connectmedia.hu/ah/getstreamurl.php?id=" .. ch_id );
    return readresponse();
end

function get_mindigtvlink(u)
  local s,ch_bw = geturlandbw(u);
  if ch_bw >= 0 then
    s=download(s,android );
    local i,j = s:find('"url":"');
    if j==nil then
      return nil
    end
    s=s:sub(j+1);
    i,j=s:find('"');
    if j==nil then
      return nil
    end;
    s=s:sub(0,i-1);
    s=s:gsub("\\/","/");
  else
    ch_bw=-ch_bw
 end
   
  os.execute("curl -o " .. respfile .. " " .. s);
  s=readresponse();
  i,j=s:find('"http');
  if i==nil then
    return nil
  end;
  s=s:sub(i+1);
  i,j=s:find('"');
  if j==nil then
    return nil
  end;
  s=s:sub(0,i-1);
  if (ch_bw>0)  then
    s=s:gsub('index.m3u8',mindigtvm3u8[ch_bw]);
  end 
   return s;
end

function setoption(id,opt)
  settings[id]=opt
  savesettings()
end

function showsettings()
  local m=menu.new{name="MyTVPro Settings",icon=rot}
	m:addItem{type="back"};
	m:addItem{type="separatorline"};
  m:addItem{type="chooser", action="setoption", options={"off", "on" }, id="filmon_rtmp_mode", value=settings["filmon_rtmp_mode"], name="Filmon rtmp mode"}
  m:exec()
end


function set_pmid(id)
  pmid=tonumber(id);
  return MENU_RETURN["EXIT_ALL"];
end

function select_playitem()
local m=menu.new{name="MyTVPro",icon=menuicon}
  m:addItem{type="forwarder", action="set_pmid", id=-1, icon=rot, directkey=RC["red"],name="Settings"}
  m:addItem{type="separatorline", name="Channels"}
  for i,r in  ipairs(p) do
    m:addItem{type="forwarder", action="set_pmid", id=i, name=r.title}
  end  
  repeat
    pmid=0
    m:exec()
    if pmid==0 then
      return
    end  
    if pmid==-1 then
      showsettings()
    else 
      local url=accfunc[p[pmid].access](p[pmid].url)
      if url~=nil then
        n:PlayFile(p[pmid].title,url)
      end
    end  
   until false
end

--Main
init()
loadsettings()
accfunc={
  [accdefault]=function (x) return x end,
  [accfilmonsd]=function (x) return get_filmonlink(x,"low") end,
  [accfilmonhd]=function (x) return get_filmonlink(x,"high") end,
  [accahhbbtv]=function (x) return get_ahhbbtvlink(x) end,
  [accmtva]=function (x) return get_mtvalink(x) end,
  [accoklivetv]=function (x) return get_oklivetvlink(x) end,
  [accmindigtv]=function (x) return get_mindigtvlink(x) end
}
fill_playlist()
select_playitem()
--os.execute("rm /tmp/mytvpro_*.*");
collectgarbage();
