-- Bundesliga Liveticker Lua
-- (c) Tischi www.coolstream.to
-- Lizenz: GPL 2
-- Version: 1.3
-- Stand: 14.11.2014

--Eigenen Pfad ermitteln
function script_path()
	local str = debug.getinfo(2, "S").source:sub(2)
	return str:match("(.*/)")
end

--Plugin Pfad
pfad=script_path() .. "liveticker/"
------------------------------

--Datein und Verzeichnisse...
txtpfad="/tmp/liveticker/"
logopfad={}
logopfad[1]=pfad .. "1/"
logopfad[2]=pfad .. "2/"
logopfad[3]=pfad .. "3/"
logopfad[4]=pfad .. "4/"
bllogo="buliliveticker"
blicon="buliliveicon.png"
json_url_live="http://liveticker.bundesliga.de/json_live/"
jsonconfig="http://liveticker.bundesliga.de/de/json_config/"
jsonconfig_full="http://liveticker.bundesliga.de/de/json_eventlist/"
logo_url_60="http://liveticker.bundesliga.de/global/gfx/emblem/60x60/"
logo_url_40="http://liveticker.bundesliga.de/global/gfx/emblem/40x40/"
ergebnistxt=txtpfad .. "ergebnis.txt"
matchdaytxt=txtpfad .. "matchday.txt"
matchdaytxt2=txtpfad .. "matchday2.txt"
tabelle1=txtpfad .. "tabelle1.txt"
score=txtpfad .. "score.txt"
eventtxt=txtpfad .. "event.txt"
eventtxt2=txtpfad .. "event2.txt"
bldate={}
bldate[1]="co12"
bldate[2]="co03"
local json = require "json"
local posix	= require "posix"
confFile	= "/var/tuxbox/config/liveticker.conf"
config		= configfile.new()
configChanged	= 0
conf={}
conf["autostart_pip"]=0
conf["sekunden"]=30
conf["hinter_grau"]=0
n = neutrino()
ligawahl=1

os.execute("cp -f " .. script_path() .. "/" .. bllogo .. ".png /share/tuxbox/neutrino/icons")
os.execute("cp -f " .. script_path() .. "/" .. blicon .. " /share/tuxbox/neutrino/icons")
os.execute("mkdir -p " .. txtpfad)

--Infofenster
function printinfo(t)
	local dx = (SCREEN.END_X - SCREEN.OFF_X) / 2
	local dy = 155
	local x = ((SCREEN.END_X - SCREEN.OFF_X) - dx) / 2
	local y = ((SCREEN.END_Y - SCREEN.OFF_Y) - dy) / 2

	local wh = cwindow.new{x=x, y=y, dx=dx, dy=dy, title="Info", icon=bllogo, has_shadow=true, show_footer=false}
	ctext.new{parent=wh, x=30, y=5, dx=dx-60, dy=110, text=t, font_text=FONT['MENU'], mode="ALIGN_CENTER"}
	wh:paint()

	local i = 0
	repeat
		i = i + 1
		msg1, data1 = n:GetInput(500)
	until msg1 == RC['home'] or msg1 == RC['setup'] or msg1 == RC['ok'] or i == 12; -- 6 seconds

	wh:hide{no_restore=true}
end

--Auslesen von Saison und Spieltag
function get_matchday()
	local hb3 = hintbox.new{ title="Info", text="Spieltage der 1. und 2. Bundesliga werden geladen...", icon=bllogo}
	hb3:paint()
	os.execute("wget -O " .. matchdaytxt .. " -U Mozilla '" .. jsonconfig .. bldate[1] .. "/'" )
	fm = io.open(matchdaytxt, "r")
	if fm == nil then
		error("Kann nicht geladen werden: " .. matchdaytxt)
	else
		m = fm:read("*a")
		fm:close()
	local j_table_match = json:decode(m)
		matchday=j_table_match.currentEvent.matchday
		seasonid=j_table_match.currentEvent.season_id
	end
	
	os.execute("wget -O " .. matchdaytxt2 .. " -U Mozilla '" .. jsonconfig .. bldate[2] .. "/'" )
	fm2 = io.open(matchdaytxt2, "r")
	if fm2 == nil then
		error("Kann nicht geladen werden: " .. matchdaytxt2)
	else
		m2 = fm2:read("*a")
		fm2:close()
	local j_table_match2 = json:decode(m2)
		matchday2=j_table_match2.currentEvent.matchday
		seasonid2=j_table_match2.currentEvent.season_id
	end
	
	os.execute("wget -O " .. eventtxt .. " -U Mozilla '" .. jsonconfig_full .. bldate[1] .. "/se" .. seasonid .. "/md" .. matchday .. "/'" )
	fm3 = io.open(eventtxt, "r")
	if fm3 == nil then
		error("Kann nicht geladen werden: " .. eventtxt)
	else
		m3 = fm3:read("*a")
		fm3:close()
	local j_table_event = json:decode(m3)
		event1={}
		event1[1]=j_table_event[1]
		event1[2]=j_table_event[2]
		event1[3]=j_table_event[3]
		event1[4]=j_table_event[4]
		event1[5]=j_table_event[5]
		event1[6]=j_table_event[6]
		event1[7]=j_table_event[7]
		event1[8]=j_table_event[8]
		event1[9]=j_table_event[9]
	end
	
	os.execute("wget -O " .. eventtxt2 .. " -U Mozilla '" .. jsonconfig_full .. bldate[2] .. "/se" .. seasonid2 .. "/md" .. matchday2 .. "/'" )
	fm4 = io.open(eventtxt2, "r")
	if fm4 == nil then
		error("Kann nicht geladen werden: " .. eventtxt2)
	else
		m4 = fm4:read("*a")
		fm4:close()
	local j_table_event2 = json:decode(m4)
		event2={}
		event2[1]=j_table_event2[1]
		event2[2]=j_table_event2[2]
		event2[3]=j_table_event2[3]
		event2[4]=j_table_event2[4]
		event2[5]=j_table_event2[5]
		event2[6]=j_table_event2[6]
		event2[7]=j_table_event2[7]
		event2[8]=j_table_event2[8]
		event2[9]=j_table_event2[9]
	end
	
	hb3:hide{no_restore=true}
end

function get_result_start()
	local hb2 = hintbox.new{ title="Info", text="Ergebnisse der " .. ligawahl .. ". Bundesliga werden geladen...", icon=bllogo}
	hb2:paint()
	get_result()
	hb2:hide{no_restore=true}
end

--Ergebnisse lesen
function get_result()
	if ligawahl == 1 then
		bldatewahl = bldate[1]
		seasonidwahl=seasonid
		matchdaywahl=matchday
	end
	if ligawahl == 2 then
		bldatewahl = bldate[2]
		seasonidwahl=seasonid2
		matchdaywahl=matchday2
	end
	erghome={}
	ergaway={}
	finished={}
	farbe={}
	laeuft={}
	zeit={}
	datum={}
	
	os.execute("wget -O " .. ergebnistxt .. " -U Mozilla '" .. json_url_live .. bldatewahl .. "/se" .. seasonidwahl .. "/md" .. matchdaywahl .. "'" );
	fp = io.open(ergebnistxt, "r")
	if fp == nil then
		error("Kann nicht geladen werden: " .. ergebnistxt)
	else
		s = fp:read("*a")
		fp:close()
	end
	
	local j_table_ergebnis = json:decode(s)
	
	if ligawahl == 1 then
	zahl=1
		repeat
			erghome[zahl]=j_table_ergebnis.event[event1[zahl]].home_score[1]
			ergaway[zahl]=j_table_ergebnis.event[event1[zahl]].away_score[1]
			finished[zahl]=j_table_ergebnis.event[event1[zahl]].finished
			laeuft=j_table_ergebnis.event[event1[zahl]].date
			laeuft=laeuft:gsub("-", "")
			laeuft=laeuft:sub(3,8)
			datum[zahl]=laeuft
			uhr=j_table_ergebnis.event[event1[zahl]].date
			uhr=uhr:gsub(":", "")
			uhr=uhr:sub(12,19)
			zeit[zahl]=uhr
			zahl=zahl + 1
		until zahl==10
	end
	
	if ligawahl == 2 then
	zahl=1
		repeat
			erghome[zahl]=j_table_ergebnis.event[event2[zahl]].home_score[1]
			ergaway[zahl]=j_table_ergebnis.event[event2[zahl]].away_score[1]
			finished[zahl]=j_table_ergebnis.event[event2[zahl]].finished
			laeuft=j_table_ergebnis.event[event2[zahl]].date
			laeuft=laeuft:gsub("-", "")
			laeuft=laeuft:sub(3,8)
			datum[zahl]=laeuft
			uhr=j_table_ergebnis.event[event2[zahl]].date
			uhr=uhr:gsub(":", "")
			uhr=uhr:sub(12,19)
			zeit[zahl]=uhr
			zahl=zahl + 1
		until zahl==10
	end

	zahl = 1
	repeat
		if finished[zahl] == "no" and datum[zahl] ~= os.date("%y%m%d") or  datum[zahl] == os.date("%y%m%d") and zeit[zahl] >= os.date("%H%M%S") then
			erghome[zahl] = "-"
			ergaway[zahl] = "-"
		end
		if datum[zahl] == os.date("%y%m%d") and zeit[zahl] <= os.date("%H%M%S") and finished[zahl] == "no" then
			farbe[zahl]=COL.RED
		else
			farbe[zahl]=COL.WHITE
		end
	zahl = zahl + 1
	until zahl == 10

	local f=io.open(score, "w")
	if f == nil then
		error("Kann nicht geladen werden: " .. score)
	else
		f:write(erghome[1] .. " : " .. ergaway[1] .. "\n" .. erghome[2] .. " : " .. ergaway[2] .. "\n" .. erghome[3] .. " : " .. ergaway[3] .. "\n" .. erghome[4] .. " : " .. ergaway[4] .. "\n" .. erghome[5] .. " : " .. ergaway[5] .. "\n" .. erghome[6] .. " : " .. ergaway[6] .. "\n" .. erghome[7] .. " : " .. ergaway[7] .. "\n" .. erghome[8] .. " : " .. ergaway[8] .. "\n" .. erghome[9] .. " : " .. ergaway[9] .. "\n" .. farbe[1] .. "\n" .. farbe[2] .. "\n" .. farbe[3] .. "\n" .. farbe[4] .. "\n" .. farbe[5] .. "\n" .. farbe[6] .. "\n" .. farbe[7] .. "\n" .. farbe[8] .. "\n" .. farbe[9])
		f:close()
	end
	lines={}
	for line in io.lines(score) do
		lines[#lines + 1]=line
	end
	return lines
end

--LogoID lesen
function get_logos()
	idaway={}
	idhome={}
	local j_table_logos = json:decode(s)
	
	if ligawahl== 1 then
		zahl=1
		repeat
			idhome[zahl]=j_table_logos.event[event1[zahl]].home
			idaway[zahl]=j_table_logos.event[event1[zahl]].away
			zahl=zahl +1
		until zahl == 10
	end
	
	if ligawahl == 2 then
		zahl=1
		repeat
			idhome[zahl]=j_table_logos.event[event2[zahl]].home
			idaway[zahl]=j_table_logos.event[event2[zahl]].away
			zahl=zahl +1
		until zahl == 10
	end
	return idhome, idaway
end

--Anlegen der Verzeichnise und Logos
function logos()
	ligawahl=1
	local hb = hintbox.new{ title="Info", text="Verzeichnis " .. pfad .. " nicht vorhanden!" .. "\n" .. "Verzeichnisse werden erstellt und Logos geladen!" .. "\n" .. "Bitte warten....", icon=bllogo}
	hb:paint()
	os.execute("mkdir -p " .. pfad)
	os.execute("mkdir -p " .. logopfad[1])
	os.execute("mkdir -p " .. logopfad[2])
	os.execute("mkdir -p " .. logopfad[3])
	os.execute("mkdir -p " .. logopfad[4])
	get_matchday()
	get_result()
	get_logos()
	count = 1
	while count <= 9 do
		os.execute("wget -q -O - " .. logo_url_60 .. idhome[count] .. ".png > " .. logopfad[1] .. idhome[count] .. ".png")
		os.execute("wget -q -O - " .. logo_url_60 .. idaway[count] .. ".png > " .. logopfad[1] .. idaway[count] .. ".png")
		os.execute("wget -q -O - " .. logo_url_40 .. idhome[count] .. ".png > " .. logopfad[3] .. idhome[count] .. ".png")
		os.execute("wget -q -O - " .. logo_url_40 .. idaway[count] .. ".png > " .. logopfad[3] .. idaway[count] .. ".png")
		count = count + 1
	end
	
	ligawahl=2
	get_result()
	get_logos()
	count=1
	while count <= 9 do
		os.execute("wget -q -O - " .. logo_url_60 .. idhome[count] .. ".png > " .. logopfad[2] .. idhome[count] .. ".png")
		os.execute("wget -q -O - " .. logo_url_60 .. idaway[count] .. ".png > " .. logopfad[2] .. idaway[count] .. ".png")
		os.execute("wget -q -O - " .. logo_url_40 .. idhome[count] .. ".png > " .. logopfad[4] .. idhome[count] .. ".png")
		os.execute("wget -q -O - " .. logo_url_40 .. idaway[count] .. ".png > " .. logopfad[4] .. idaway[count] .. ".png")
		count = count + 1
	end
	hb:hide()
end

--Prüfen ob Pluginverezechnis existiert
function FolderExists()
	local fileHandle, strError = io.open(logopfad[1], "r")
	if fileHandle ~= nil then
		io.close(fileHandle)
		return true
	else
		logos()
	end
end

--Ergebnisse anzeigen im Fenster
function ergebnispaint()
	count = 1
	while count <= 9 do
		e[count]:paint()
		e[count]:setText{color_text=lines[count + 9]}
		e[count]:setText{text=lines[count]}
		count = count + 1
	end
	e[10]:paint()
	e[11]:paint()
end

--Ergebnisse verbergen
function ergebnishide()
	count = 1
	while count <= 9 do
		e[count]:hide{no_restore=true}
		count = count + 1
	end
	e[10]:hide()
	e[11]:hide()
end

--Bilder anzeigen
function bilderpaint()
	count = 1
	while count <= 20 do
		p[count]:paint()
		count = count + 1
	end
end

--Bilder verbergen
function bilderhide()
	count = 1
	while count <= 20 do
		p[count]:hide()
		count = count + 1
	end
end

function tabelle_paint()
	count = 1
	while count <= 181 do
		ta[count]:paint()
		count = count + 1
	end
end

--Tabelle verbergen
function tabelle_hide()
	count = 1
	while count <= 181 do
		ta[count]:hide{no_restore=true}
		count = count + 1
	end
end

--automatische aktualisierung der Ergebnisse
function aktua()
	bilderpaint()
	aktuasec = conf["sekunden"] * 1000
	repeat
	    get_result()
	    ergebnishide()
	    ergebnispaint()
	    msg, data = n:GetInput(aktuasec)
        until msg == RC.red or msg == RC.home or msg == RC.green
		if msg == RC.red then
			ergebnishide()
			bilderhide()
			tickerfenster()
		elseif msg == RC.home then
			ergebnishide()
			bilderhide()
			beenden()
		elseif msg == RC.green then
			ergebnishide()
			bilderhide()
			pipmode=1
			get_tabelle()
			blitztabelle()
		end
end

--tmp-Ordner löschen
function beenden()
	os.execute("rm -rf /tmp/liveticker/")
end

--Funktion zum laden der Config
function loadConfig()
	config:loadConfig(confFile)
 
	conf["autostart_pip"] = config:getString("autostart_pip", "aus")
	conf["sekunden"]  = config:getString("sekunden",  30)
	conf["hinter_grau"]  = config:getString("hinter_grau",  "aus")
	conf["ligastart"]  = config:getString("ligastart",  "1.Liga")
end

--Funktion zum speichern der Config
function saveConfig()
	if configChanged == 1 then
		local h = hintbox.new{caption="Info", text="Einstellungen werden gespeichert...", icon="info"};
		h:paint();
 
		config:setString("autostart_pip", conf["autostart_pip"])
		config:setString("sekunden",  conf["sekunden"])
		config:setString("hinter_grau",  conf["hinter_grau"])
		config:setString("ligastart",  conf["ligastart"])
 
		config:saveConfig(confFile)
 
		configChanged = 0
		posix.sleep(1)
		h:hide();
	end
end

function get_tabelle()
	if ligawahl == 1 then
		bldatewahl = bldate[1]
		seasonidwahl=seasonid
		matchdaywahl=matchday
	end
	if ligawahl == 2 then
		bldatewahl = bldate[2]
		seasonidwahl=seasonid2
		matchdaywahl=matchday2
	end

	os.execute("wget -O " .. ergebnistxt .. " -U Mozilla '" .. json_url_live .. bldatewahl .. "/se" .. seasonidwahl .. "/md" .. matchdaywahl .. "'" )
tt = io.open(ergebnistxt, "r")
if tt == nil then
		error("Kann nicht geladen werden: " .. ergebnistxt)
	else
 td = tt:read("*a")
		tt:close()
	end
	
	local j_table = json:decode(td)
	
	zaehler = 1
	repeat
	diffrank=j_table.ranking[zaehler].rank - j_table.ranking[zaehler].last_rank
		if diffrank < 0 then
		j_table.ranking[zaehler].last_rank = "up"
		end
		if  diffrank > 0 then
		j_table.ranking[zaehler].last_rank = "down"
		end
		if diffrank == 0 then
		j_table.ranking[zaehler].last_rank = "left"
		end
	zaehler = zaehler + 1
	until zaehler == 19
	
	local f=io.open(tabelle1, "w")
	if f == nil then
		error("Kann nicht geladen werden: " .. tabelle1)
	else
		for i = 1, 18 do
				f:write(j_table.ranking[i].rank .. "\n" .. j_table.ranking[i].team_id .. "\n" .. j_table.ranking[i].games_played .. "\n" .. j_table.ranking[i].win .. "\n" .. j_table.ranking[i].draw .. "\n" .. j_table.ranking[i].lost .. "\n" .. j_table.ranking[i].difference .. "\n" .. j_table.ranking[i].points .. "\n" .. j_table.ranking[i].last_rank .. "\n")
				end
		f:close()
	end

	lines={}
	for line in io.lines(tabelle1) do
		lines[#lines + 1]=line
	end
	return lines
	end

--Liveticker im Fenster anzeigen
function tickerfenster()
	if ligawahl == 1 then
		knop="2"
		matchdaywahl=matchday
	end
	if ligawahl == 2 then
		knop="1"
		matchdaywahl=matchday2
	end
	local dxpic = 60
	local dypic = 60
	local dx = ((SCREEN.END_X - SCREEN.OFF_X) / 2) +300
	local dy = 450
	local x = ((SCREEN.END_X - SCREEN.OFF_X) - dx) / 2
	local y = ((SCREEN.END_Y - SCREEN.OFF_Y) - dy) / 2 
	
	
	
	
	w = cwindow.new{x=x, y=y, dx=dx, dy=dy, name="Bundesliga Liveticker - " .. ligawahl .. ". Bundesliga", icon=bllogo, has_shadow=true, btnRed="PIP-Einstellungen", btnGreen="Liveticker PIP", btnYellow="Blitztabelle", btnBlue=knop .. ". Bundesliga"}

	ctext.new{parent=w, x=350, y=5, dx=200, dy=60, text=matchdaywahl .. ". Spieltag", mode="ALIGN_AUTO_WIDTH | ALIGN_CENTER", font_text=FONT['MENU_TITLE']}
	
	ctext.new{parent=w, x=149, y=70 , dx=80, dy=60, text=lines[1], color_text=lines[10]}
	ctext.new{parent=w, x=429, y=70 , dx=80, dy=60, text=lines[2], color_text=lines[11]}
	ctext.new{parent=w, x=709, y=70 , dx=80, dy=60, text=lines[3], color_text=lines[12]}
	ctext.new{parent=w, x=149, y=170 , dx=80, dy=60, text=lines[4], color_text=lines[13]}
	ctext.new{parent=w, x=429, y=170 , dx=80, dy=60, text=lines[5], color_text=lines[14]}
	ctext.new{parent=w, x=709, y=170 , dx=80, dy=60, text=lines[6], color_text=lines[15]}
	ctext.new{parent=w, x=149, y=270 , dx=80, dy=60, text=lines[7], color_text=lines[16]}
	ctext.new{parent=w, x=429, y=270 , dx=80, dy=60, text=lines[8], color_text=lines[17]}
	ctext.new{parent=w, x=709, y=270 , dx=80, dy=60, text=lines[9], color_text=lines[18]}

	cpicture.new{parent=w, x=60, y=70 , dx=dxpic, dy=dypic, image=logopfad[ligawahl] .. idhome[1] .. ".png", transparency=2}
	cpicture.new{parent=w, x=220, y=70 , dx=dxpic, dy=dypic, image=logopfad[ligawahl] .. idaway[1] .. ".png", transparency=2}
	cpicture.new{parent=w, x=340, y=70 , dx=dxpic, dy=dypic, image=logopfad[ligawahl] .. idhome[2] .. ".png", transparency=2}
	cpicture.new{parent=w, x=500, y=70 , dx=dxpic, dy=dypic, image=logopfad[ligawahl] .. idaway[2] .. ".png", transparency=2}
	cpicture.new{parent=w, x=620, y=70 , dx=dxpic, dy=dypic, image=logopfad[ligawahl] .. idhome[3] .. ".png", transparency=2}
	cpicture.new{parent=w, x=780, y=70 , dx=dxpic, dy=dypic, image=logopfad[ligawahl] .. idaway[3] .. ".png", transparency=2}
	cpicture.new{parent=w, x=60, y=170 , dx=dxpic, dy=dypic, image=logopfad[ligawahl] .. idhome[4] .. ".png", transparency=2}
	cpicture.new{parent=w, x=220, y=170 , dx=dxpic, dy=dypic, image=logopfad[ligawahl] .. idaway[4] .. ".png", transparency=2}
	cpicture.new{parent=w, x=340, y=170 , dx=dxpic, dy=dypic, image=logopfad[ligawahl] .. idhome[5] .. ".png", transparency=2}
	cpicture.new{parent=w, x=500, y=170 , dx=dxpic, dy=dypic, image=logopfad[ligawahl] .. idaway[5] .. ".png", transparency=2}
	cpicture.new{parent=w, x=620, y=170 , dx=dxpic, dy=dypic, image=logopfad[ligawahl] .. idhome[6] .. ".png", transparency=2}
	cpicture.new{parent=w, x=780, y=170 , dx=dxpic, dy=dypic, image=logopfad[ligawahl] .. idaway[6] .. ".png", transparency=2}
	cpicture.new{parent=w, x=60, y=270 , dx=dxpic, dy=dypic, image=logopfad[ligawahl] .. idhome[7] .. ".png", transparency=2}
	cpicture.new{parent=w, x=220, y=270 , dx=dxpic, dy=dypic, image=logopfad[ligawahl] .. idaway[7] .. ".png", transparency=2}
	cpicture.new{parent=w, x=340, y=270 , dx=dxpic, dy=dypic, image=logopfad[ligawahl] .. idhome[8] .. ".png", transparency=2}
	cpicture.new{parent=w, x=500, y=270 , dx=dxpic, dy=dypic, image=logopfad[ligawahl] .. idaway[8] .. ".png", transparency=2}
	cpicture.new{parent=w, x=620, y=270 , dx=dxpic, dy=dypic, image=logopfad[ligawahl] .. idhome[9] .. ".png", transparency=2}
	cpicture.new{parent=w, x=780, y=270 , dx=dxpic, dy=dypic, image=logopfad[ligawahl] .. idaway[9] .. ".png", transparency=2}
	w:paint()

	repeat
		msg, data = n:GetInput(500)
		if (msg == RC['red']) then
			w:hide{no_restore=true}
			addMenue()
		elseif (msg == RC['green']) then
			w:hide{no_restore=true}
			loadConfig()
			get_result()
			tickertv()
		elseif (msg == RC['yellow']) then
			w:hide{no_restore=true}
			pipmode=0
			get_tabelle()
			blitztabelle()			
		elseif (msg == RC['blue']) then
			w:hide{no_restore=true}
			if ligawahl == 1 then
				ligawahl = 2
			elseif ligawahl == 2 then
				ligawahl = 1
			end
			loadConfig()
			get_result_start()
			get_logos()
			tickerfenster()	
		elseif (msg == RC['setup']) then
			w:hide{no_restore=true}
			addMenue()
		end
	until msg == RC['home']
	w:hide{no_restore=true}
	beenden()
end

--Liveticker anzeigen ohne Window
function tickertv()
	hint_farbe()
	local dx = (SCREEN.END_X - SCREEN.OFF_X) / 2
	local dy = (SCREEN.END_Y - SCREEN.OFF_Y) / 2
	local x = SCREEN.OFF_X
	local y = SCREEN.OFF_Y
	local yy = SCREEN.END_Y
	local dxpic = 40
	local dypic = 40
	e={}
	p={}

	e[1]=ctext.new{x=dx-465, y=yy-120 , dx=60, dy=40, text=lines[1],  color_body=hinterfarbe, color_text=lines[10], mode="ALIGN_CENTER"}
	e[2]=ctext.new{x=dx-235, y=yy-120 , dx=60, dy=40, text=lines[2], color_body=hinterfarbe, color_text=lines[11], mode="ALIGN_CENTER"}
	e[3]=ctext.new{x=dx, y=yy-125 , dx=60, dy=40, text=lines[3], color_body=hinterfarbe, color_text=lines[12], mode="ALIGN_CENTER"}
	e[4]=ctext.new{x=dx+225, y=yy-120 , dx=60, dy=40, text=lines[4], color_body=hinterfarbe, color_text=lines[13], mode="ALIGN_CENTER"}

	e[5]=ctext.new{x=dx-465, y=yy-60 , dx=60, dy=40, text=lines[5], color_body=hinterfarbe, color_text=lines[14], mode="ALIGN_CENTER"}
	e[6]=ctext.new{x=dx-235, y=yy-60 , dx=60, dy=40, text=lines[6], color_body=hinterfarbe, color_text=lines[15], mode="ALIGN_CENTER"}
	e[7]=ctext.new{x=dx - 5, y=yy-60 , dx=60, dy=40, text=lines[7], color_body=hinterfarbe, color_text=lines[16], mode="ALIGN_CENTER"}
	e[8]=ctext.new{x=dx+225, y=yy-60 , dx=60, dy=40, text=lines[8], color_body=hinterfarbe, color_text=lines[17], mode="ALIGN_CENTER"}

	e[9]=ctext.new{x=dx+455, y=yy-120 , dx=60, dy=40, text=lines[9], color_body=hinterfarbe, color_text=lines[18], mode="ALIGN_CENTER"}

	e[10]=ctext.new{x=dx+385, y=yy-60 , dx=80, dy=40, text="zurück", color_body=0xFF, mode="ALIGN_LEFT"}
	e[11]=ctext.new{x=dx+515, y=yy-60 , dx=60, dy=40, text="BT", color_body=0xFF, mode="ALIGN_LEFT"}

	p[1]=cpicture.new{x=dx-515, y=yy-120 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. idhome[1] .. ".png", transparency=2, color_background=0xFF}
	p[2]=cpicture.new{x=dx-395, y=yy-120 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. idaway[1] .. ".png", transparency=2, color_background=0xFF}
	p[3]=cpicture.new{x=dx-285, y=yy-120 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. idhome[2] .. ".png", transparency=2, color_background=0xFF}
	p[4]=cpicture.new{x=dx-165, y=yy-120 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. idaway[2] .. ".png", transparency=2, color_background=0xFF}
	p[5]=cpicture.new{x=dx-55, y=yy-120 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. idhome[3] .. ".png", transparency=2, color_background=0xFF}
	p[6]=cpicture.new{x=dx+65, y=yy-120 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. idaway[3] .. ".png", transparency=2, color_background=0xFF}
	p[7]=cpicture.new{x=dx+175, y=yy-120 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. idhome[4] .. ".png", transparency=2, color_background=0xFF}
	p[8]=cpicture.new{x=dx+295, y=yy-120 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. idaway[4] .. ".png", transparency=2, color_background=0xFF}

	p[9]=cpicture.new{x=dx-515, y=yy-60 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. idhome[5] .. ".png", transparency=2, color_background=0xFF}
	p[10]=cpicture.new{x=dx-395, y=yy-60 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. idaway[5] .. ".png", transparency=2, color_background=0xFF}
	p[11]=cpicture.new{x=dx-285, y=yy-60 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. idhome[6] .. ".png", transparency=2, color_background=0xFF}
	p[12]=cpicture.new{x=dx-165, y=yy-60 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. idaway[6] .. ".png", transparency=2, color_background=0xFF}
	p[13]=cpicture.new{x=dx-55, y=yy-60 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. idhome[7] .. ".png", transparency=2, color_background=0xFF}
	p[14]=cpicture.new{x=dx+65, y=yy-60 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. idaway[7] .. ".png", transparency=2, color_background=0xFF}
	p[15]=cpicture.new{x=dx+175, y=yy-60 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. idhome[8] .. ".png", transparency=2, color_background=0xFF}
	p[16]=cpicture.new{x=dx+295, y=yy-60 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. idaway[8] .. ".png", transparency=2, color_background=0xFF}
	p[17]=cpicture.new{x=dx+405, y=yy-120 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. idhome[9] .. ".png", transparency=2, color_background=0xFF}
	p[18]=cpicture.new{x=dx+525, y=yy-120 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. idaway[9] .. ".png", transparency=2, color_background=0xFF}

	p[19]=cpicture.new{x=dx+360, y=yy-50 , dx=20, dy=20, image="rot", transparency=2, color_background=0xFF, mode="ALIGN_CENTER"}
	p[20]=cpicture.new{x=dx+485, y=yy-50 , dx=20, dy=20, image="gruen", transparency=2, color_background=0xFF, mode="ALIGN_CENTER"}

	aktua()
end

--Blitztabelle 1. und 2. Bundesliga
function blitztabelle()
local dxpic = 40
local dypic = 40
local dx = ((SCREEN.END_X - SCREEN.OFF_X) / 2) +30
local dy = (SCREEN.END_Y - SCREEN.OFF_Y) / 2
local y = SCREEN.OFF_Y + 60
ta={}

ta[1]=cpicture.new{x=dx-420, y=y+100 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. lines[2] .. ".png", transparency=2, mode="ALIGN_CENTER", color_background=COL['BLACK']}
ta[2]=cpicture.new{x=dx-420, y=y+150 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. lines[11] .. ".png", transparency=2, mode="ALIGN_CENTER", color_background=COL['BLACK']}
ta[3]=cpicture.new{x=dx-420, y=y+200 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. lines[20] .. ".png", transparency=2, mode="ALIGN_CENTER", color_background=COL['BLACK']}
ta[4]=cpicture.new{x=dx-420, y=y+250 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. lines[29] .. ".png", transparency=2, mode="ALIGN_CENTER", color_background=COL['DARK_GRAY']}
ta[5]=cpicture.new{x=dx-420, y=y+300 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. lines[38] .. ".png", transparency=2, mode="ALIGN_CENTER", color_background=COL['DARK_GRAY']}
ta[6]=cpicture.new{x=dx-420, y=y+350 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. lines[47] .. ".png", transparency=2, mode="ALIGN_CENTER", color_background=COL['DARK_GRAY']}
ta[7]=cpicture.new{x=dx-420, y=y+400 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. lines[56] .. ".png", transparency=2, mode="ALIGN_CENTER", color_background=COL['LIGHT_GRAY']}
ta[8]=cpicture.new{x=dx-420, y=y+450 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. lines[65] .. ".png", transparency=2, mode="ALIGN_CENTER", color_background=COL['LIGHT_GRAY']}
ta[9]=cpicture.new{x=dx-420, y=y+500 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. lines[74] .. ".png", transparency=2, mode="ALIGN_CENTER", color_background=COL['LIGHT_GRAY']}

ta[10]=cpicture.new{x=dx+100, y=y+100 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. lines[83] .. ".png", transparency=2, mode="ALIGN_CENTER", color_background=COL['LIGHT_GRAY']}
ta[11]=cpicture.new{x=dx+100, y=y+150 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. lines[92] .. ".png", transparency=2, mode="ALIGN_CENTER", color_background=COL['LIGHT_GRAY']}
ta[12]=cpicture.new{x=dx+100, y=y+200 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. lines[101] .. ".png", transparency=2, mode="ALIGN_CENTER", color_background=COL['LIGHT_GRAY']}
ta[13]=cpicture.new{x=dx+100, y=y+250 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. lines[110] .. ".png", transparency=2, mode="ALIGN_CENTER", color_background=COL['LIGHT_GRAY']}
ta[14]=cpicture.new{x=dx+100, y=y+300 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. lines[119] .. ".png", transparency=2, mode="ALIGN_CENTER", color_background=COL['LIGHT_GRAY']}
ta[15]=cpicture.new{x=dx+100, y=y+350 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. lines[128] .. ".png", transparency=2, mode="ALIGN_CENTER", color_background=COL['LIGHT_GRAY']}
ta[16]=cpicture.new{x=dx+100, y=y+400 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. lines[137] .. ".png", transparency=2, mode="ALIGN_CENTER", color_background=COL['DARK_GRAY']}
ta[17]=cpicture.new{x=dx+100, y=y+450 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. lines[146] .. ".png", transparency=2, mode="ALIGN_CENTER", color_background=COL['BLACK']}
ta[18]=cpicture.new{x=dx+100, y=y+500 , dx=dxpic, dy=dypic, image=logopfad[ligawahl + 2] .. lines[155] .. ".png", transparency=2, mode="ALIGN_CENTER", color_background=COL['BLACK']}

ta[164]=cpicture.new{x=dx-50, y=y+110 , dx=20, dy=20, image=lines[9], transparency=2, mode="ALIGN_CENTER", color_background=0xFF}
ta[165]=cpicture.new{x=dx-50, y=y+160 , dx=20, dy=20, image=lines[18], transparency=2, mode="ALIGN_CENTER", color_background=0xFF}
ta[166]=cpicture.new{x=dx-50, y=y+210 , dx=20, dy=20, image=lines[27], transparency=2, mode="ALIGN_CENTER", color_background=0xFF}
ta[167]=cpicture.new{x=dx-50, y=y+260 , dx=20, dy=20, image=lines[36], transparency=2, mode="ALIGN_CENTER", color_background=0xFF}
ta[168]=cpicture.new{x=dx-50, y=y+310 , dx=20, dy=20, image=lines[45], transparency=2, mode="ALIGN_CENTER", color_background=0xFF}
ta[169]=cpicture.new{x=dx-50, y=y+360 , dx=20, dy=20, image=lines[54], transparency=2, mode="ALIGN_CENTER", color_background=0xFF}
ta[170]=cpicture.new{x=dx-50, y=y+410 , dx=20, dy=20, image=lines[63], transparency=2, mode="ALIGN_CENTER", color_background=0xFF}
ta[171]=cpicture.new{x=dx-50, y=y+460 , dx=20, dy=20, image=lines[72], transparency=2, mode="ALIGN_CENTER", color_background=0xFF}
ta[172]=cpicture.new{x=dx-50, y=y+510 , dx=20, dy=20, image=lines[81], transparency=2, mode="ALIGN_CENTER", color_background=0xFF}

ta[173]=cpicture.new{x=dx+470, y=y+110 , dx=20, dy=20, image=lines[90], transparency=2, mode="ALIGN_CENTER", color_background=0xFF}
ta[174]=cpicture.new{x=dx+470, y=y+160 , dx=20, dy=20, image=lines[99], transparency=2, mode="ALIGN_CENTER", color_background=0xFF}
ta[175]=cpicture.new{x=dx+470, y=y+210 , dx=20, dy=20, image=lines[108], transparency=2, mode="ALIGN_CENTER", color_background=0xFF}
ta[176]=cpicture.new{x=dx+470, y=y+260 , dx=20, dy=20, image=lines[117], transparency=2, mode="ALIGN_CENTER", color_background=0xFF}
ta[177]=cpicture.new{x=dx+470, y=y+310 , dx=20, dy=20, image=lines[126], transparency=2, mode="ALIGN_CENTER", color_background=0xFF}
ta[178]=cpicture.new{x=dx+470, y=y+360 , dx=20, dy=20, image=lines[135], transparency=2, mode="ALIGN_CENTER", color_background=0xFF}
ta[179]=cpicture.new{x=dx+470, y=y+410 , dx=20, dy=20, image=lines[144], transparency=2, mode="ALIGN_CENTER", color_background=0xFF}
ta[180]=cpicture.new{x=dx+470, y=y+460 , dx=20, dy=20, image=lines[153], transparency=2, mode="ALIGN_CENTER", color_background=0xFF}
ta[181]=cpicture.new{x=dx+470, y=y+510 , dx=20, dy=20, image=lines[162], transparency=2, mode="ALIGN_CENTER", color_background=0xFF}

ta[159]=cpicture.new{x=dx-330, y=y+560 , dx=20, dy=10, image="rot", transparency=2, color_background=0xFF, mode="ALIGN_RIGHT"}
ta[160]=ctext.new{x=dx-300, y=y+550, dx=200, dy=20, text="aktualisieren", color_body=0xFF, color_text=COL['WHITE'], font_text=FONT['MENU'], mode="ALIGN_LEFT" }
ta[161]=cpicture.new{x=dx+220, y=y+560 , dx=20, dy=10, image="gruen", transparency=2, color_background=0xFF, mode="ALIGN_RIGHT"}
ta[162]=ctext.new{x=dx+250, y=y+550, dx=200, dy=20, text="zurück", color_body=0xFF, color_text=COL['WHITE'], font_text=FONT['MENU'], mode="ALIGN_LEFT" }
ta[163]=ctext.new{x=dx-460, y=y-20, dx=920, dy=70, text="Blitztabelle " .. ligawahl .. ". Bundesliga", color_body=COL['MENUCONTENT'], color_text=COL['MENUCONTENT_TEXT'], font_text=FONT['MENU_TITLE'], mode="ALIGN_CENTER" }

ta[19]=ctext.new{x=dx-460, y=y+50 , dx=40, dy=dxpic, text="PL", mode="ALIGN_RIGHT", color_body=COL['MENUCONTENT'], color_text=COL['MENUCONTENT_TEXT']}
ta[20]=ctext.new{x=dx-420, y=y+50 , dx=90, dy=dxpic, text="SP", mode="ALIGN_RIGHT", color_body=COL['MENUCONTENT'], color_text=COL['MENUCONTENT_TEXT']}
ta[21]=ctext.new{x=dx-330, y=y+50 , dx=50, dy=dxpic, text="S", mode="ALIGN_RIGHT", color_body=COL['MENUCONTENT'], color_text=COL['MENUCONTENT_TEXT']}
ta[22]=ctext.new{x=dx-280, y=y+50 , dx=40, dy=dxpic, text="U", mode="ALIGN_RIGHT", color_body=COL['MENUCONTENT'], color_text=COL['MENUCONTENT_TEXT']}
ta[23]=ctext.new{x=dx-240, y=y+50 , dx=40, dy=dxpic, text="N", mode="ALIGN_RIGHT", color_body=COL['MENUCONTENT'], color_text=COL['MENUCONTENT_TEXT']}
ta[24]=ctext.new{x=dx-200, y=y+50 , dx=70, dy=dxpic, text="TD", mode="ALIGN_RIGHT", color_body=COL['MENUCONTENT'], color_text=COL['MENUCONTENT_TEXT']}
ta[25]=ctext.new{x=dx-130, y=y+50 , dx=70, dy=dxpic, text="PKT", mode="ALIGN_RIGHT", color_body=COL['MENUCONTENT'], color_text=COL['MENUCONTENT_TEXT']}

ta[26]=ctext.new{x=dx-460, y=y+100 , dx=40, dy=dxpic, text=lines[1], color_body=COL['BLACK'], mode="ALIGN_CENTER"}
ta[27]=ctext.new{x=dx-380, y=y+100 , dx=50, dy=dxpic, text=lines[3], color_body=COL['BLACK'], mode="ALIGN_RIGHT"}
ta[28]=ctext.new{x=dx-330, y=y+100 , dx=50, dy=dxpic, text=lines[4], color_body=COL['BLACK'], mode="ALIGN_RIGHT"}
ta[29]=ctext.new{x=dx-280, y=y+100 , dx=40, dy=dxpic, text=lines[5], color_body=COL['BLACK'], mode="ALIGN_RIGHT"}
ta[30]=ctext.new{x=dx-240, y=y+100 , dx=40, dy=dxpic, text=lines[6], color_body=COL['BLACK'], mode="ALIGN_RIGHT"}
ta[31]=ctext.new{x=dx-200, y=y+100 , dx=70, dy=dxpic, text=lines[7], color_body=COL['BLACK'], mode="ALIGN_RIGHT"}
ta[32]=ctext.new{x=dx-130, y=y+100 , dx=70, dy=dxpic, text=lines[8], color_body=COL['BLACK'], mode="ALIGN_RIGHT"}

ta[33]=ctext.new{x=dx-460, y=y+150 , dx=40, dy=dxpic, text=lines[10], color_body=COL['BLACK'], mode="ALIGN_CENTER"}
ta[34]=ctext.new{x=dx-380, y=y+150 , dx=50, dy=dxpic, text=lines[12], mode="ALIGN_RIGHT", color_body=COL['BLACK']}
ta[35]=ctext.new{x=dx-330, y=y+150 , dx=50, dy=dxpic, text=lines[13], mode="ALIGN_RIGHT", color_body=COL['BLACK']}
ta[36]=ctext.new{x=dx-280, y=y+150 , dx=40, dy=dxpic, text=lines[14], mode="ALIGN_RIGHT", color_body=COL['BLACK']}
ta[37]=ctext.new{x=dx-240, y=y+150 , dx=40, dy=dxpic, text=lines[15], mode="ALIGN_RIGHT", color_body=COL['BLACK']}
ta[38]=ctext.new{x=dx-200, y=y+150 , dx=70, dy=dxpic, text=lines[16], mode="ALIGN_RIGHT", color_body=COL['BLACK']}
ta[39]=ctext.new{x=dx-130, y=y+150 , dx=70, dy=dxpic, text=lines[17], mode="ALIGN_RIGHT", color_body=COL['BLACK']}

ta[40]=ctext.new{x=dx-460, y=y+200 , dx=40, dy=dxpic, text=lines[19], color_body=COL['BLACK'], mode="ALIGN_CENTER"}
ta[41]=ctext.new{x=dx-380, y=y+200 , dx=50, dy=dxpic, text=lines[21], mode="ALIGN_RIGHT", color_body=COL['BLACK']}
ta[42]=ctext.new{x=dx-330, y=y+200 , dx=50, dy=dxpic, text=lines[22], mode="ALIGN_RIGHT", color_body=COL['BLACK']}
ta[43]=ctext.new{x=dx-280, y=y+200 , dx=40, dy=dxpic, text=lines[23], mode="ALIGN_RIGHT", color_body=COL['BLACK']}
ta[44]=ctext.new{x=dx-240, y=y+200 , dx=40, dy=dxpic, text=lines[24], mode="ALIGN_RIGHT", color_body=COL['BLACK']}
ta[45]=ctext.new{x=dx-200, y=y+200 , dx=70, dy=dxpic, text=lines[25], mode="ALIGN_RIGHT", color_body=COL['BLACK']}
ta[46]=ctext.new{x=dx-130, y=y+200 , dx=70, dy=dxpic, text=lines[26], mode="ALIGN_RIGHT", color_body=COL['BLACK']}

ta[47]=ctext.new{x=dx-460, y=y+250 , dx=40, dy=dxpic, text=lines[28], color_body=COL['DARK_GRAY'], mode="ALIGN_CENTER"}
ta[48]=ctext.new{x=dx-380, y=y+250 , dx=50, dy=dxpic, text=lines[30], mode="ALIGN_RIGHT", color_body=COL['DARK_GRAY']}
ta[49]=ctext.new{x=dx-330, y=y+250 , dx=50, dy=dxpic, text=lines[31], mode="ALIGN_RIGHT", color_body=COL['DARK_GRAY']}
ta[50]=ctext.new{x=dx-280, y=y+250 , dx=40, dy=dxpic, text=lines[32], mode="ALIGN_RIGHT", color_body=COL['DARK_GRAY']}
ta[51]=ctext.new{x=dx-240, y=y+250 , dx=40, dy=dxpic, text=lines[33], mode="ALIGN_RIGHT", color_body=COL['DARK_GRAY']}
ta[52]=ctext.new{x=dx-200, y=y+250 , dx=70, dy=dxpic, text=lines[34], mode="ALIGN_RIGHT", color_body=COL['DARK_GRAY']}
ta[53]=ctext.new{x=dx-130, y=y+250 , dx=70, dy=dxpic, text=lines[35], mode="ALIGN_RIGHT", color_body=COL['DARK_GRAY']}

ta[54]=ctext.new{x=dx-460, y=y+300 , dx=40, dy=dxpic, text=lines[37], color_body=COL['DARK_GRAY'], mode="ALIGN_CENTER"}
ta[55]=ctext.new{x=dx-380, y=y+300 , dx=50, dy=dxpic, text=lines[39], mode="ALIGN_RIGHT", color_body=COL['DARK_GRAY']}
ta[56]=ctext.new{x=dx-330, y=y+300 , dx=50, dy=dxpic, text=lines[40], mode="ALIGN_RIGHT", color_body=COL['DARK_GRAY']}
ta[57]=ctext.new{x=dx-280, y=y+300 , dx=40, dy=dxpic, text=lines[41], mode="ALIGN_RIGHT", color_body=COL['DARK_GRAY']}
ta[58]=ctext.new{x=dx-240, y=y+300 , dx=40, dy=dxpic, text=lines[42], mode="ALIGN_RIGHT", color_body=COL['DARK_GRAY']}
ta[59]=ctext.new{x=dx-200, y=y+300 , dx=70, dy=dxpic, text=lines[43], mode="ALIGN_RIGHT", color_body=COL['DARK_GRAY']}
ta[60]=ctext.new{x=dx-130, y=y+300 , dx=70, dy=dxpic, text=lines[44], mode="ALIGN_RIGHT", color_body=COL['DARK_GRAY']}

ta[61]=ctext.new{x=dx-460, y=y+350 , dx=40, dy=dxpic, text=lines[46], color_body=COL['DARK_GRAY'], mode="ALIGN_CENTER"}
ta[62]=ctext.new{x=dx-380, y=y+350 , dx=50, dy=dxpic, text=lines[48], mode="ALIGN_RIGHT", color_body=COL['DARK_GRAY']}
ta[63]=ctext.new{x=dx-330, y=y+350 , dx=50, dy=dxpic, text=lines[49], mode="ALIGN_RIGHT", color_body=COL['DARK_GRAY']}
ta[64]=ctext.new{x=dx-280, y=y+350 , dx=40, dy=dxpic, text=lines[50], mode="ALIGN_RIGHT", color_body=COL['DARK_GRAY']}
ta[65]=ctext.new{x=dx-240, y=y+350 , dx=40, dy=dxpic, text=lines[51], mode="ALIGN_RIGHT", color_body=COL['DARK_GRAY']}
ta[66]=ctext.new{x=dx-200, y=y+350 , dx=70, dy=dxpic, text=lines[52], mode="ALIGN_RIGHT", color_body=COL['DARK_GRAY']}
ta[67]=ctext.new{x=dx-130, y=y+350 , dx=70, dy=dxpic, text=lines[53], mode="ALIGN_RIGHT", color_body=COL['DARK_GRAY']}

ta[68]=ctext.new{x=dx-460, y=y+400 , dx=40, dy=dxpic, text=lines[55], color_body=COL['LIGHT_GRAY'], mode="ALIGN_CENTER"}
ta[69]=ctext.new{x=dx-380, y=y+400 , dx=50, dy=dxpic, text=lines[57], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[70]=ctext.new{x=dx-330, y=y+400 , dx=50, dy=dxpic, text=lines[58], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[71]=ctext.new{x=dx-280, y=y+400 , dx=40, dy=dxpic, text=lines[59], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[72]=ctext.new{x=dx-240, y=y+400 , dx=40, dy=dxpic, text=lines[60], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[73]=ctext.new{x=dx-200, y=y+400 , dx=70, dy=dxpic, text=lines[61], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[74]=ctext.new{x=dx-130, y=y+400 , dx=70, dy=dxpic, text=lines[62], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}

ta[75]=ctext.new{x=dx-460, y=y+450 , dx=40, dy=dxpic, text=lines[64], color_body=COL['LIGHT_GRAY'], mode="ALIGN_CENTER"}
ta[76]=ctext.new{x=dx-380, y=y+450 , dx=50, dy=dxpic, text=lines[66], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[77]=ctext.new{x=dx-330, y=y+450 , dx=50, dy=dxpic, text=lines[67], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[78]=ctext.new{x=dx-280, y=y+450 , dx=40, dy=dxpic, text=lines[68], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[79]=ctext.new{x=dx-240, y=y+450 , dx=40, dy=dxpic, text=lines[69], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[80]=ctext.new{x=dx-200, y=y+450 , dx=70, dy=dxpic, text=lines[70], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[81]=ctext.new{x=dx-130, y=y+450 , dx=70, dy=dxpic, text=lines[71], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}

ta[82]=ctext.new{x=dx-460, y=y+500 , dx=40, dy=dxpic, text=lines[73], color_body=COL['LIGHT_GRAY'], mode="ALIGN_CENTER"}
ta[83]=ctext.new{x=dx-380, y=y+500 , dx=50, dy=dxpic, text=lines[75], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[84]=ctext.new{x=dx-330, y=y+500 , dx=50, dy=dxpic, text=lines[76], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[85]=ctext.new{x=dx-280, y=y+500 , dx=40, dy=dxpic, text=lines[77], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[86]=ctext.new{x=dx-240, y=y+500 , dx=40, dy=dxpic, text=lines[78], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[87]=ctext.new{x=dx-200, y=y+500 , dx=70, dy=dxpic, text=lines[79], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[88]=ctext.new{x=dx-130, y=y+500 , dx=70, dy=dxpic, text=lines[80], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}


ta[89]=ctext.new{x=dx-60, y=y+50 , dx=160, dy=dxpic, text="PL", mode="ALIGN_RIGHT", color_body=COL['MENUCONTENT'], color_text=COL['MENUCONTENT_TEXT']}
ta[90]=ctext.new{x=dx+100, y=y+50 , dx=90, dy=dxpic, text="SP", mode="ALIGN_RIGHT", color_body=COL['MENUCONTENT'], color_text=COL['MENUCONTENT_TEXT']}
ta[91]=ctext.new{x=dx+190, y=y+50 , dx=50, dy=dxpic, text="S", mode="ALIGN_RIGHT", color_body=COL['MENUCONTENT'], color_text=COL['MENUCONTENT_TEXT']}
ta[92]=ctext.new{x=dx+240, y=y+50 , dx=40, dy=dxpic, text="U", mode="ALIGN_RIGHT", color_body=COL['MENUCONTENT'], color_text=COL['MENUCONTENT_TEXT']}
ta[93]=ctext.new{x=dx+280, y=y+50 , dx=40, dy=dxpic, text="N", mode="ALIGN_RIGHT", color_body=COL['MENUCONTENT'], color_text=COL['MENUCONTENT_TEXT']}
ta[94]=ctext.new{x=dx+320, y=y+50 , dx=70, dy=dxpic, text="TD", mode="ALIGN_RIGHT", color_body=COL['MENUCONTENT'], color_text=COL['MENUCONTENT_TEXT']}
ta[95]=ctext.new{x=dx+390, y=y+50 , dx=70, dy=dxpic, text="PKT", mode="ALIGN_RIGHT", color_body=COL['MENUCONTENT'], color_text=COL['MENUCONTENT_TEXT']}

ta[96]=ctext.new{x=dx+60, y=y+100 , dx=40, dy=dxpic, text=lines[82], color_body=COL['LIGHT_GRAY'], mode="ALIGN_CENTER"}
ta[97]=ctext.new{x=dx+140, y=y+100 , dx=50, dy=dxpic, text=lines[84], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[98]=ctext.new{x=dx+190, y=y+100 , dx=50, dy=dxpic, text=lines[85], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[99]=ctext.new{x=dx+240, y=y+100 , dx=40, dy=dxpic, text=lines[86], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[100]=ctext.new{x=dx+280, y=y+100 , dx=40, dy=dxpic, text=lines[87], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[101]=ctext.new{x=dx+320, y=y+100 , dx=70, dy=dxpic, text=lines[88], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[102]=ctext.new{x=dx+390, y=y+100 , dx=70, dy=dxpic, text=lines[89], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}

ta[103]=ctext.new{x=dx+60, y=y+150 , dx=40, dy=dxpic, text=lines[91], color_body=COL['LIGHT_GRAY'], mode="ALIGN_CENTER"}
ta[104]=ctext.new{x=dx+140, y=y+150 , dx=50, dy=dxpic, text=lines[93], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[105]=ctext.new{x=dx+190, y=y+150 , dx=50, dy=dxpic, text=lines[94], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[106]=ctext.new{x=dx+240, y=y+150 , dx=40, dy=dxpic, text=lines[95], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[107]=ctext.new{x=dx+280, y=y+150 , dx=40, dy=dxpic, text=lines[96], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[108]=ctext.new{x=dx+320, y=y+150 , dx=70, dy=dxpic, text=lines[97], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[109]=ctext.new{x=dx+390, y=y+150 , dx=70, dy=dxpic, text=lines[98], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}

ta[110]=ctext.new{x=dx+60, y=y+200 , dx=40, dy=dxpic, text=lines[100], color_body=COL['LIGHT_GRAY'], mode="ALIGN_CENTER"}
ta[111]=ctext.new{x=dx+140, y=y+200 , dx=50, dy=dxpic, text=lines[102], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[112]=ctext.new{x=dx+190, y=y+200 , dx=50, dy=dxpic, text=lines[103], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[113]=ctext.new{x=dx+240, y=y+200 , dx=40, dy=dxpic, text=lines[104], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[114]=ctext.new{x=dx+280, y=y+200 , dx=40, dy=dxpic, text=lines[105], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[115]=ctext.new{x=dx+320, y=y+200 , dx=70, dy=dxpic, text=lines[106], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[116]=ctext.new{x=dx+390, y=y+200 , dx=70, dy=dxpic, text=lines[107], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}

ta[117]=ctext.new{x=dx+60, y=y+250 , dx=40, dy=dxpic, text=lines[109], color_body=COL['LIGHT_GRAY'], mode="ALIGN_CENTER"}
ta[118]=ctext.new{x=dx+140, y=y+250 , dx=50, dy=dxpic, text=lines[111], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[119]=ctext.new{x=dx+190, y=y+250 , dx=50, dy=dxpic, text=lines[112], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[120]=ctext.new{x=dx+240, y=y+250 , dx=40, dy=dxpic, text=lines[113], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[121]=ctext.new{x=dx+280, y=y+250 , dx=40, dy=dxpic, text=lines[114], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[122]=ctext.new{x=dx+320, y=y+250 , dx=70, dy=dxpic, text=lines[115], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[123]=ctext.new{x=dx+390, y=y+250 , dx=70, dy=dxpic, text=lines[116], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}

ta[124]=ctext.new{x=dx+60, y=y+300 , dx=40, dy=dxpic, text=lines[118], color_body=COL['LIGHT_GRAY'], mode="ALIGN_CENTER"}
ta[125]=ctext.new{x=dx+140, y=y+300 , dx=50, dy=dxpic, text=lines[120], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[126]=ctext.new{x=dx+190, y=y+300 , dx=50, dy=dxpic, text=lines[121], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[127]=ctext.new{x=dx+240, y=y+300 , dx=40, dy=dxpic, text=lines[122], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[128]=ctext.new{x=dx+280, y=y+300 , dx=40, dy=dxpic, text=lines[123], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[129]=ctext.new{x=dx+320, y=y+300 , dx=70, dy=dxpic, text=lines[124], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[130]=ctext.new{x=dx+390, y=y+300 , dx=70, dy=dxpic, text=lines[125], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}

ta[131]=ctext.new{x=dx+60, y=y+350 , dx=40, dy=dxpic, text=lines[127], color_body=COL['LIGHT_GRAY'], mode="ALIGN_CENTER"}
ta[132]=ctext.new{x=dx+140, y=y+350 , dx=50, dy=dxpic, text=lines[129], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[133]=ctext.new{x=dx+190, y=y+350 , dx=50, dy=dxpic, text=lines[130], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[134]=ctext.new{x=dx+240, y=y+350 , dx=40, dy=dxpic, text=lines[131], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[135]=ctext.new{x=dx+280, y=y+350 , dx=40, dy=dxpic, text=lines[132], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[136]=ctext.new{x=dx+320, y=y+350 , dx=70, dy=dxpic, text=lines[133], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}
ta[137]=ctext.new{x=dx+390, y=y+350 , dx=70, dy=dxpic, text=lines[134], mode="ALIGN_RIGHT", color_body=COL['LIGHT_GRAY']}

ta[138]=ctext.new{x=dx+60, y=y+400 , dx=40, dy=dxpic, text=lines[136], color_body=COL['DARK_GRAY'], mode="ALIGN_CENTER"}
ta[139]=ctext.new{x=dx+140, y=y+400 , dx=50, dy=dxpic, text=lines[138], mode="ALIGN_RIGHT", color_body=COL['DARK_GRAY']}
ta[140]=ctext.new{x=dx+190, y=y+400 , dx=50, dy=dxpic, text=lines[139], mode="ALIGN_RIGHT", color_body=COL['DARK_GRAY']}
ta[141]=ctext.new{x=dx+240, y=y+400 , dx=40, dy=dxpic, text=lines[140], mode="ALIGN_RIGHT", color_body=COL['DARK_GRAY']}
ta[142]=ctext.new{x=dx+280, y=y+400 , dx=40, dy=dxpic, text=lines[141], mode="ALIGN_RIGHT", color_body=COL['DARK_GRAY']}
ta[143]=ctext.new{x=dx+320, y=y+400 , dx=70, dy=dxpic, text=lines[142], mode="ALIGN_RIGHT", color_body=COL['DARK_GRAY']}
ta[144]=ctext.new{x=dx+390, y=y+400 , dx=70, dy=dxpic, text=lines[143], mode="ALIGN_RIGHT", color_body=COL['DARK_GRAY']}

ta[145]=ctext.new{x=dx+60, y=y+450 , dx=40, dy=dxpic, text=lines[145], color_body=COL['BLACK'], mode="ALIGN_CENTER"}
ta[146]=ctext.new{x=dx+140, y=y+450 , dx=50, dy=dxpic, text=lines[147], mode="ALIGN_RIGHT", color_body=COL['BLACK']}
ta[147]=ctext.new{x=dx+190, y=y+450 , dx=50, dy=dxpic, text=lines[148], mode="ALIGN_RIGHT", color_body=COL['BLACK']}
ta[148]=ctext.new{x=dx+240, y=y+450 , dx=40, dy=dxpic, text=lines[149], mode="ALIGN_RIGHT", color_body=COL['BLACK']}
ta[149]=ctext.new{x=dx+280, y=y+450 , dx=40, dy=dxpic, text=lines[150], mode="ALIGN_RIGHT", color_body=COL['BLACK']}
ta[150]=ctext.new{x=dx+320, y=y+450 , dx=70, dy=dxpic, text=lines[151], mode="ALIGN_RIGHT", color_body=COL['BLACK']}
ta[151]=ctext.new{x=dx+390, y=y+450 , dx=70, dy=dxpic, text=lines[152], mode="ALIGN_RIGHT", color_body=COL['BLACK']}

ta[152]=ctext.new{x=dx+60, y=y+500 , dx=40, dy=dxpic, text=lines[154], color_body=COL['BLACK'], mode="ALIGN_CENTER"}
ta[153]=ctext.new{x=dx+140, y=y+500 , dx=50, dy=dxpic, text=lines[156], mode="ALIGN_RIGHT", color_body=COL['BLACK']}
ta[154]=ctext.new{x=dx+190, y=y+500 , dx=50, dy=dxpic, text=lines[157], mode="ALIGN_RIGHT", color_body=COL['BLACK']}
ta[155]=ctext.new{x=dx+240, y=y+500 , dx=40, dy=dxpic, text=lines[158], mode="ALIGN_RIGHT", color_body=COL['BLACK']}
ta[156]=ctext.new{x=dx+280, y=y+500 , dx=40, dy=dxpic, text=lines[159], mode="ALIGN_RIGHT", color_body=COL['BLACK']}
ta[157]=ctext.new{x=dx+320, y=y+500 , dx=70, dy=dxpic, text=lines[160], mode="ALIGN_RIGHT", color_body=COL['BLACK']}
ta[158]=ctext.new{x=dx+390, y=y+500 , dx=70, dy=dxpic, text=lines[161], mode="ALIGN_RIGHT", color_body=COL['BLACK']}

tabelle_paint()

repeat
	msg, data = n:GetInput(500)
	if (msg == RC['red']) then
		tabelle_hide()
		get_tabelle()
		blitztabelle()
	elseif (msg == RC['green']) then
		tabelle_hide()
		get_result()
		if pipmode == 1 then
		tickertv()
		pipmode=0
		else
		tickerfenster()
		end
	end
	until msg == RC['home']
	tabelle_hide()
	beenden()
end

--farbe bestimmen des Ergebnishintergrund
function hint_farbe()
	if conf["hinter_grau"] == "hellgrau" then
		hinterfarbe=COL.LIGHT_GRAY
	elseif conf["hinter_grau"] == "dunkelgrau" then
		hinterfarbe=COL.DARK_GRAY
	elseif conf["hinter_grau"] == "schwarz" then
		hinterfarbe=COL.BLACK
	else
		hinterfarbe="0xFF"
	end
end

function set_var(k,v) 
conf[k]=v
configChanged=1
end

--Menü anzeigen
function addMenue()
	m = menu.new{name="Bundesliga Liveticker - PIP Einstellungen", icon=bllogo, has_shadow=true}
	m:addItem{type = "back"}
	m:addItem{type="separatorline"}
	m:addItem{type="chooser", action="set_var", options={ 30, 60, 90, 120 }, id="sekunden", value=conf["sekunden"], name="PIP-Aktualisierung in sek.", directkey=RC["1"]}
	m:addItem{type="chooser", action="set_var", options={ "1.Liga", "2.Liga" }, id="ligastart", value=conf["ligastart"], name="Liga-Start", directkey=RC["2"]}
	m:addItem{type="chooser", action="set_var", options={ "aus", "an" }, id="autostart_pip", value=conf["autostart_pip"], name="PIP-Autostart", directkey=RC["3"]}
	m:addItem{type="chooser", action="set_var", options={ "aus", "hellgrau", "dunkelgrau", "schwarz" }, id="hinter_grau", value=conf["hinter_grau"], name="PIP-Ergebnisse grau hinterlegt", directkey=RC["3"]}
	m:addItem{type="separatorline"}
	m:addItem{type="forwarder", name="Speichern", action="saveConfig", icon="rot", directkey=RC["red"]}
	m:exec()
	tickerfenster()
end

FolderExists()
loadConfig()
get_matchday()

if conf["ligastart"] == "1.Liga" and conf["autostart_pip"] == "aus" then
	ligawahl=1	
	get_result_start()
	get_logos()
	tickerfenster()
elseif conf["ligastart"] == "2.Liga" and conf["autostart_pip"] == "aus" then
	ligawahl=2
	get_result_start()
	get_logos()
	tickerfenster()
elseif conf["ligastart"] == "1.Liga" and conf["autostart_pip"] == "an" then
	ligawahl=1
	get_result_start()
	get_logos()
	tickertv()
elseif conf["ligastart"] == "2.Liga" and conf["autostart_pip"] == "an" then
	ligawahl=2
	get_result_start()
	get_logos()
	tickertv()
end