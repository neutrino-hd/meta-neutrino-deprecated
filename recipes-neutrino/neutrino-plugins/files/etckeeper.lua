-- locales
locale = {}
locale["deutsch"] = {
	caption = "etc Ordner sichern",
	success = "Einstellungen gesichert",
	no_success = "Nichts zu erledigen",
	msg_wait = "bitte warten ...",
	etckeeper_hint = "Sichert alle Datein des Ordners etc in einen Git Remote",
	remote = "Zielordner",
	remote_hint = "Geben sie den Zielordner für die Sicherung an",
	create = "Speichern",
	create_hint = "Speichert den Pfad und startet neu"
}
locale["english"] = {
	caption = "Save etc folder",
	success = "Settings have been saved",
	no_success = "Nothing to do",
	msg_wait = "please wait ...",
	etckeeper_hint = "Saves the content of the folder etc into a git remote",
	remote = "Destination",
	remote_hint = "Specify the destination folder where the git remote will be created",
	create = "Save",
	create_hint = "Saves the destination path and reboot"
}

-- variables
local n = neutrino()
commit_message = "'committed by neutrino'"
executable = "/usr/bin/etckeeper"
command = "commit"

-- functions

function file_exists(name)
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end


function commit() 
	local cmd = executable .. " " .. command .. " " .. commit_message
	local h = hintbox.new{caption=locale[lang].caption, text=locale[lang].msg_wait}	
        h:paint()
	print(cmd) 
	local ret = os.execute(cmd)
        	if ret==true then
                text=locale[lang].success 
	        else
                text=locale[lang].no_success
        	end
        local h = hintbox.new{caption=locale[lang].caption, text=text}            
	h:paint()
	local i = 0
		repeat
                        i = i + 1
                        msg, data = n:GetInput(500)
                until msg == RC.ok or msg == RC.home or i == 10
                h:hide()
	return MENU_RETURN.EXIT_ALL
end

function key_home()
	return MENU_RETURN.EXIT
end

function key_setup()
	return MENU_RETURN.EXIT_ALL
end

function set_path(value) 
	dest = "'" .. value .. "'"
end

function modify_files()
	local spath = { "/etc/init.d/update_etc.sh", "/etc/init.d/create_etc.sh" }
	for index, wert in ipairs(spath) do
	local hFile = io.open(wert, "r")
	local lines = {}
	local restOfFile
	local lineCt = 1
	for line in hFile:lines() do
	  if string.find(line, "'(.-)'") then --Is this the line to modify?
	    lines[#lines + 1] = string.gsub(line, "'(.-)'", dest) --Change old line into new line.
	    restOfFile = hFile:read("*a")
	    break
	  else
	    lineCt = lineCt + 1
	    lines[#lines + 1] = line
	  end
	end
	hFile:close()

	hFile = io.open(wert, "w") --write the file.
	for i, line in ipairs(lines) do
	  hFile:write(line, "\n")
	end
	hFile:write(restOfFile)
	hFile:close()
	end
end
----------------------------------------------------------------------

local neutrino_conf = configfile.new()
neutrino_conf:loadConfig("/etc/neutrino/config/neutrino.conf")
lang = neutrino_conf:getString("language", "english")
if locale[lang] == nil then
	lang = "english"
end

local m = menu.new{name=locale[lang].caption, icon="settings"}
m:addKey{directkey=RC["home"], id="home", action="key_home"}
m:addKey{directkey=RC["setup"], id="setup", action="key_setup"}
m:addItem{type="separator"}
m:addItem{type="back"}
m:addItem{type="separatorline"}
m:addItem{
	type="forwarder",
	name=locale[lang].caption,
	enabled=file_exists(executable),
	action="commit",
	icon="gruen",
	directkey=RC["green"],
	hint_icon="hint_service",
        hint=locale[lang].etckeeper_hint
}
m:addItem{
	type="filebrowser",
	dir_mode="1",
	name=locale[lang].remote,
	action="set_path",
	enabled=file_exists(executable),
	value=dest,
	icon="rot",
	directkey=RC["red"],
	hint_icon="hint_service",
	hint=locale[lang].remote_hint
}
m:addItem{
	type="forwarder",
	name=locale[lang].create,
	action="modify_files",
	icon="gelb",
	directkey=RC["yellow"],
	hint_icon="hint_service",
	hint=locale[lang].create_hint
}
m:exec()
