-- Lua Wetter App
-- version 1.0 - 1.3 (c) by tischi
-- version 1.4 by db2w-user
-- Lizenz: GPL 2
-- Stand: 25.10.2015

-- V1.4 -- add. apikey thx. GetAway
-- apikey shamelessly stolen from the source code of the page http://openweathermap.org/current

--Eigenen Pfad ermitteln
function script_path()
	local str = debug.getinfo(2, "S").source:sub(2)
	return str:match("(.*/)")
end

--Variablen
pfad=script_path() .. "LuaWetterApp/"
txtpfad="/tmp/Lua_Wetter/"
daten=txtpfad .. "luawetter.txt"
datentxt=txtpfad .. "wetterdaten.txt"
confPfad="/var/tuxbox/config/"
confFile= confPfad .. "luawetterapp.conf"
appicon="luawettericon.png"
stadt_name={}
stadt_name["name"]="Koeln"
stadt_name["land"]="de"
wochentag=os.date("%w")
wochentag2="0"
wochentag3="0"
wochentag4="0"
config = configfile.new()
conf={}
conf["name"]="Koeln"
conf["farbe"]="COL.MENUCONTENT"
conf["txtfarbe"]="COL.MENUCONTENT_TEXT"
conf["apikey"]="bd82977b86bf27fb59a04b61b657fb6f"
hintfarbe=COL.MENUCONTENT
textfarbe=COL.MENUCONTENT_TEXT
local posix	= require "posix"
local json = require "json"
local n = neutrino()
tagname={}
tagname["0"]="Sonntag"
tagname["1"]="Montag"
tagname["2"]="Dienstag"
tagname["3"]="Mittwoch"
tagname["4"]="Donnerstag"
tagname["5"]="Freitag"
tagname["6"]="Samstag"
iconurl="http://icons.iconarchive.com/icons/oxygen-icons.org/oxygen/128/"

--Ordner anlegen
os.execute("mkdir -p " .. txtpfad)
os.execute("cp -f " .. script_path() .. "/" .. appicon .. " /share/tuxbox/neutrino/icons")

--Infofenster
function printinfo(t)
	local dx = (SCREEN.END_X - SCREEN.OFF_X) / 2
	local dy = 155
	local x = ((SCREEN.END_X - SCREEN.OFF_X) - dx) / 2
	local y = ((SCREEN.END_Y - SCREEN.OFF_Y) - dy) / 2

	local wh = cwindow.new{x=x, y=y, dx=dx, dy=dy, title="Info", icon="info", has_shadow=true, show_footer=false}
	ctext.new{parent=wh, x=30, y=5, dx=dx-60, dy=110, text=t, font_text=FONT['MENU'], mode="ALIGN_CENTER"}
	wh:paint()

	local i = 0
	repeat
		i = i + 1
		msg1, data1 = n:GetInput(500)
	until msg1 == RC['home'] or msg1 == RC['setup'] or msg1 == RC['ok'] or i == 12; -- 6 seconds

	wh:hide{no_restore=true}
end

--zuordnung Wochentage
function wochentage()
wochentag2 = tostring((tonumber(wochentag) + 1) % 7)
wochentag3 = tostring((tonumber(wochentag) + 2) % 7)
wochentag4 = tostring((tonumber(wochentag) + 3) % 7)
end

--Wetterdaten holen und auslesen
function get_weather()
	wochentage()
	local hb = hintbox.new{ title="Info", text="Daten werden geladen", icon="info", has_shadow=true, show_footer=false}
	hb:paint()
	os.execute("wget -O " .. daten .. " -U Mozilla 'http://api.openweathermap.org/data/2.5/forecast/daily?q=" .. conf["name"] .. "&units=metric&cnt=4&lang=de&APPID=" .. conf["apikey"] .. "'" )
	fp = io.open(daten, "r")
		if fp == nil then
			error("Kann nicht geladen werden: " .. daten)
		else
			s = fp:read("*a")
			fp:close()
		end

	local j_table = json:decode(s)
		
	stadt = j_table.city.name
		if stadt == nil then
			printinfo("Nicht gefunden!")
			hb:hide()
			addMenue()
		end	
		
	zahl = 1
	repeat
		j_table.list[zahl].speed=math.floor(j_table.list[zahl].speed + 0.5)
		j_table.list[zahl].temp.eve=math.floor(j_table.list[zahl].temp.eve + 0.5)
		j_table.list[zahl].temp.day=math.floor(j_table.list[zahl].temp.day + 0.5)
		j_table.list[zahl].temp.min=math.floor(j_table.list[zahl].temp.min + 0.5)
		j_table.list[zahl].temp.max=math.floor(j_table.list[zahl].temp.max + 0.5)
		j_table.list[zahl].temp.night=math.floor(j_table.list[zahl].temp.night + 0.5)
		zahl = zahl + 1
	until zahl == 5
	
	local daten=io.open(datentxt, "w")
	if daten == nil then
		error("Kann nicht geladen werden: " .. datentxt)
	else
		daten:write(tagname[wochentag] .. "\n" .. j_table.list[1].weather[1].icon .. "\n" .. j_table.list[1].weather[1].description .. "\n" .. "Tag: " .. j_table.list[1].temp.day .. "°C" .. " " .. "Abends: " .. j_table.list[1].temp.eve .. "°C" .. " " .. "Nachts: " .. j_table.list[1].temp.night .. "°C" .. "\n" .. "minimal: " .. j_table.list[1].temp.min .. "°C" .. " " .. "maximal: " .. j_table.list[1].temp.max .. "°C" .. "\n" .. "Windgeschwindigkeit: " .. j_table.list[1].speed .. " kmh" .. "\n" .. "Luftfeuchtigkeit: " .. j_table.list[1].humidity .. "%" .. "\n" .. tagname[wochentag2] .. "\n" .. j_table.list[2].weather[1].icon .. "\n" .. j_table.list[2].weather[1].description .. "\n" .. "minimal: " .. j_table.list[2].temp.min .. "°C" .. " " .. "maximal: " .. j_table.list[2].temp.max .. "°C" .. "\n" .. tagname[wochentag3] .. "\n" .. j_table.list[3].weather[1].icon .. "\n" .. j_table.list[3].weather[1].description .. "\n" .. "minimal: " .. j_table.list[3].temp.min .. "°C" .. " " .. "maximal: " .. j_table.list[3].temp.max .. "°C" .. "\n" .. tagname[wochentag4] .. "\n" .. j_table.list[4].weather[1].icon .. "\n" .. j_table.list[4].weather[1].description .. "\n" .. "minimal: " .. j_table.list[4].temp.min .. "°C" .. " " .. "maximal: " .. j_table.list[4].temp.max .. "°C" .. "\n" .. stadt)
		daten:close()
	end
	
	lines={}
	for line in io.lines(datentxt) do
		lines[#lines + 1]=line
	end
	hb:hide()
	return lines
end

--config laden
function loadConfig()
	config:loadConfig(confFile)
 
	conf["farbe"] = config:getString("farbe", "COL.MENUCONTENT")
	conf["name"] = config:getString("name", "Koeln")
	conf["txtfarbe"] = config:getString("txtfarbe", "COL.MENUCONTENT_TEXT")
	conf["apikey"]= config:getString("apikey", "bd82977b86bf27fb59a04b61b657fb6f")

	end

--Funktion zum speichern der Config
function saveConfig()
	if configChanged == 1 then
		local h = hintbox.new{caption="Info", text="Einstellungen werden gespeichert...", icon="info", has_shadow=true, show_footer=false};
		h:paint();
		
		config:setString("farbe", conf["farbe"])
		config:setString("name", conf["name"])
		config:setString("txtfarbe", conf["txtfarbe"])
 		config:setString("apikey", conf["apikey"])

		config:saveConfig(confFile)
 
		configChanged = 0
		posix.sleep(1)
		h:hide();
	end
end

--Farbvariablen zuordnen
function farbAuswahl()
	if conf["farbe"] == "weiss" then
		hintfarbe=COL.WHITE
	elseif conf["farbe"] == "schwarz" then
		hintfarbe=COL.BLACK
	elseif conf["farbe"] == "grau" then
		hintfarbe=COL.DARK_GRAY
	elseif conf["farbe"] == "rot" then
		hintfarbe=COL.RED
	elseif conf["farbe"] == "grün" then
		hintfarbe=COL.GREEN
	elseif conf["farbe"] == "blau" then
		hintfarbe=COL.BLUE
	elseif conf["farbe"] == "gelb" then
		hintfarbe=COL.YELLOW
	else
		hintfarbe=COL.MENUCONTENT
	end
	
	if conf["txtfarbe"] == "weiss" then
		textfarbe=COL.WHITE
	elseif conf["txtfarbe"] == "schwarz" then
		textfarbe=COL.BLACK
	elseif conf["txtfarbe"] == "grau" then
		textfarbe=COL.DARK_GRAY
	elseif conf["txtfarbe"] == "rot" then
		textfarbe=COL.RED
	elseif conf["txtfarbe"] == "grün" then
		textfarbe=COL.GREEN
	elseif conf["txtfarbe"] == "blau" then
		textfarbe=COL.BLUE
	elseif conf["txtfarbe"] == "gelb" then
		textfarbe=COL.YELLOW
	else
		textfarbe=COL.MENUCONTENT_TEXT
	end
	
end

--Wetterdaten anzeigen im Fenster
function anzeigepaint()
	count = 1
	while count <= 16 do
		anz[count]:paint()
		count = count + 1
	end
end

--Wetterdaten verbergen
function anzeigehide()
	count = 1
	while count <= 16 do
		anz[count]:hide{no_restore=true}
		count = count + 1
	end
end

--Variablen conf[] setzen
function set_string(k, v)
	conf[k]=v
	configChanged = 1
end

--löscht den tmp Ordner
function beenden()
os.execute("rm -rf " .. txtpfad)
end

--Bilder und Text auf den TV malen
function wetterfenster()
wochentage()
anz={}
local dx = (SCREEN.END_X - SCREEN.OFF_X) / 2 + 10
local dy = (SCREEN.END_Y - SCREEN.OFF_Y) / 2 + 10
local x = SCREEN.OFF_X
local y = SCREEN.OFF_Y
local xx = SCREEN.END_X
local yy = SCREEN.END_Y

anz[16]=ctext.new{parent=w, x=dx-200, y=y+30, dx=450, dy=30, text=lines[20], color_body=hintfarbe, color_text=textfarbe, font_text=FONT['MENU_TITLE'], mode="ALIGN_CENTER" }
anz[3]=ctext.new{parent=w, x=dx-200, y=y+188, dx=450, dy=175, text=lines[4] .. "\n" .. lines[5] .. "\n" .. lines[6] .. "\n" .. lines[7], color_body=hintfarbe, color_text=textfarbe, font_text=FONT['MENU'], mode="ALIGN_CENTER" }
anz[2]=ctext.new{parent=w, x=dx-73, y=y+60, dx=323, dy=128, text="Heute: " .. lines[1] .. "\n" .. lines[3], color_body=hintfarbe, color_text=textfarbe, font_text=FONT['MENU'], mode="ALIGN_CENTER" }
anz[1]=cpicture.new{parent=w, x=dx-200, y=y+60 , dx=128, dy=128, image=pfad .. lines[2] .. ".png", transparency=2, color_background=hintfarbe, mode="ALIGN_RIGHT"}

anz[4]=cpicture.new{parent=w, x=dx-562, y=yy-248 , dx=128, dy=128, image=pfad .. lines[9] .. ".png", transparency=2, color_background=hintfarbe, mode="ALIGN_RIGHT"}
anz[5]=ctext.new{parent=w, x=dx-434, y=yy-248, dx=250, dy=128, text=lines[8] .. "\n" .. lines[10], color_body=hintfarbe, color_text=textfarbe, font_text=FONT['MENU'], mode="ALIGN_CENTER" }
anz[10]=ctext.new{parent=w, x=dx-562, y=yy-120, dx=378, dy=50, text=lines[11], color_body=hintfarbe, color_text=textfarbe, font_text=FONT['MENU'], mode="ALIGN_CENTER" }

anz[6]=cpicture.new{parent=w, x=dx-164, y=yy-248 , dx=128, dy=128, image=pfad .. lines[13] .. ".png", transparency=2, color_background=hintfarbe, mode="ALIGN_RIGHT"}
anz[7]=ctext.new{parent=w, x=dx-36, y=yy-248, dx=250, dy=128, text=lines[12] .. "\n" .. lines[14], color_body=hintfarbe, color_text=textfarbe, font_text=FONT['MENU'], mode="ALIGN_CENTER" }
anz[11]=ctext.new{parent=w, x=dx-164, y=yy-120, dx=378, dy=50, text=lines[15], color_body=hintfarbe, color_text=textfarbe, font_text=FONT['MENU'], mode="ALIGN_CENTER" }

anz[8]=cpicture.new{parent=w, x=dx+234, y=yy-248 , dx=128, dy=128, image=pfad .. lines[17] .. ".png", transparency=2, color_background=hintfarbe, mode="ALIGN_RIGHT" }
anz[9]=ctext.new{parent=w, x=dx+362, y=yy-248, dx=250, dy=128, text=lines[16] .. "\n" .. lines[18], color_body=hintfarbe, color_text=textfarbe, font_text=FONT['MENU'], mode="ALIGN_CENTER" }
anz[12]=ctext.new{parent=w, x=dx+234, y=yy-120, dx=378, dy=50, text=lines[19], color_body=hintfarbe, color_text=textfarbe, font_text=FONT['MENU'], mode="ALIGN_CENTER" }

anz[13]=ctext.new{parent=w, x=x+100, y=yy-50, dx=400, dy=20, text="www.openweathermap.org", color_body=0xFF, color_text=COL['WHITE'], font_text=FONT['MENU'], mode="ALIGN_CENTER" }
anz[14]=cpicture.new{parent=w, x=xx-310, y=yy-45 , dx=20, dy=10, image="menu", transparency=2, color_background=0xFF, mode="ALIGN_RIGHT"}
anz[15]=ctext.new{parent=w, x=xx-280, y=yy-50, dx=200, dy=20, text="Stadt-PLZ", color_body=0xFF, color_text=COL['WHITE'], font_text=FONT['MENU'], mode="ALIGN_LEFT" }

anzeigepaint()

repeat
	msg, data = n:GetInput(500)
	if (msg == RC['setup']) then
		anzeigehide()
		addMenue()
	end
until msg == RC['home']
	anzeigehide()
	beenden()
end

--Prüfen ob Pluginverezechnis existiert
function FolderExists()
	local fileHandle, strError = io.open(pfad .. "01d.png", "r")
	if fileHandle ~= nil then
		io.close(fileHandle)
		return true
	else
		logos()
	end
end

--Anlegen der Verzeichnise und Logos
function logos()
	local hb = hintbox.new{ title="Info", text="Verzeichnis " .. pfad .. " nicht vorhanden!" .. "\n" .. "Verzeichnisse werden erstellt und Icons geladen!" .. "\n" .. "Bitte warten....", has_shadow=true, show_footer=false}
	hb:paint()
	os.execute("mkdir -p " .. pfad)
		os.execute("wget -q -O - " .. iconurl .. "Status-weather-clear-icon.png > " .. pfad .. "01d.png")
		os.execute("wget -q -O - " .. iconurl .. "Status-weather-clear-night-icon.png > " .. pfad .. "01n.png")
		os.execute("wget -q -O - " .. iconurl .. "Status-weather-few-clouds-icon.png > " .. pfad .. "02d.png")
		os.execute("wget -q -O - " .. iconurl .. "Status-weather-few-clouds-night-icon.png > " .. pfad .. "02n.png")
		os.execute("wget -q -O - " .. iconurl .. "Status-weather-clouds-icon.png > " .. pfad .. "03d.png")
		os.execute("wget -q -O - " .. iconurl .. "Status-weather-clouds-night-icon.png > " .. pfad .. "03n.png")	
		os.execute("wget -q -O - " .. iconurl .. "Status-weather-many-clouds-icon.png > " .. pfad .. "04d.png")
		os.execute("wget -q -O - " .. iconurl .. "Status-weather-many-clouds-icon.png > " .. pfad .. "04n.png")
		os.execute("wget -q -O - " .. iconurl .. "Status-weather-showers-scattered-day-icon.png > " .. pfad .. "09d.png")
		os.execute("wget -q -O - " .. iconurl .. "Status-weather-showers-scattered-night-icon.png > " .. pfad .. "09n.png")
		os.execute("wget -q -O - " .. iconurl .. "Status-weather-showers-scattered-icon.png > " .. pfad .. "10d.png")
		os.execute("wget -q -O - " .. iconurl .. "Status-weather-showers-scattered-icon.png > " .. pfad .. "10n.png")
		os.execute("wget -q -O - " .. iconurl .. "Status-weather-storm-icon.png > " .. pfad .. "11d.png")
		os.execute("wget -q -O - " .. iconurl .. "Status-weather-storm-icon.png > " .. pfad .. "11n.png")
		os.execute("wget -q -O - " .. iconurl .. "Status-weather-snow-icon.png > " .. pfad .. "13d.png")
		os.execute("wget -q -O - " .. iconurl .. "Status-weather-snow-icon.png > " .. pfad .. "13d.png")
		
	hb:hide()
end

function handle_key(a)
	if (confChanged == 0) then return MENU_RETURN.EXIT end
	local res = messagebox.exec{title="Änderungen verwerfen?", text="Sollen die Änderungen verworfen werden?", buttons={ "yes", "no" }, has_shadow=true }
	if (res == "yes") then return MENU_RETURN.EXIT end
	return MENU_RETURN.EXIT_REPAINT
end

--Menü anzeigen
function addMenue()
	local m = menu.new{name="Wetter - Suche", has_shadow=true}
	m:addKey{directkey = RC["home"], id = "home", action = "handle_key"}
	m:addItem{type = "back"}
	m:addItem{type="separatorline"}
	m:addItem{type="keyboardinput", action="set_string", id="name", value=conf["name"],  sms=1, name="PLZ oder Name", directkey=RC["1"]}
	m:addItem{type="separatorline"}
	m:addItem{type="chooser", action="set_string", options={"Theme-Farbe", "weiss", "schwarz", "grau", "rot", "grün", "blau", "gelb"}, id="farbe", value=conf["farbe"], name="Hintergrundfarbe", directkey=RC["2"]}
	m:addItem{type="chooser", action="set_string", options={"Theme-Farbe", "weiss", "schwarz", "grau", "rot", "grün", "blau", "gelb"}, id="txtfarbe", value=conf["txtfarbe"], name="Textfarbe", directkey=RC["3"]}
	m:addItem{type="separatorline"}
	m:addItem{type="keyboardinput", size=32, action="set_string", id="apikey", value=conf["apikey"],  sms=1, name="apikey", directkey=RC["4"]}
	m:addItem{type="separatorline"}
	m:addItem{type="forwarder", name="Speichern", action="saveConfig", icon="rot", directkey=RC["red"]}
	m:exec()
	loadConfig()
	get_weather()
	farbAuswahl()
	wetterfenster()
end

FolderExists()
loadConfig()
farbAuswahl()
get_weather()
wetterfenster()
