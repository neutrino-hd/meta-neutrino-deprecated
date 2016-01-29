--[[
	Anzeige der aktuellen ISS-Position in
	der linken oberen Ecke des Bildschirms

	Copyright (C) 2016,  theobald123
	License: GPL
	
	21.01.2016: Screensaver-Modus ergänzt
	25.01.2016: 2. Bild hinzugefügt und timeout korrigiert (Danke svenhoefer)

]]
	image1       = 'http://images.ontwikkel.nl/iss/iss-globe.jpg'
	image2       = 'http://thomas-wehr.eu/main-graphs/iss-location.jpg'

	image        = image1  -- Startimage für die Anzeige (Wechsel mit Taste 'Rot')
	size_tv_x    = 300     -- Breite der Anzeige im TV-Modus
	size_tv_y    = 300     -- Höhe der Anzeige im TV-Modus
	size_radio_x = 500     -- Breite der Anzeige im Radio-Modus
	size_radio_y = 500     -- Höhe der Anzeige im Radio-Modus
	timeout      = 120     -- Wartezyklen (jeweils 500 ms) 
	
function download(Url)
	if Url == nil
	then 
		return nil 
	end

	if Curl == nil
	then
		Curl = curl.new()
	end

	ret, data = Curl:download{ url=Url, A='Mozilla/5.0'}
	if ret == CURL.OK
	then
		return data
	else
		return nil
	end
end


function main()
	modus = download('http://127.0.0.1/control/getmode')
	n     = neutrino()

	if string.find(modus,'tv')
	then
		size_x = size_tv_x
		size_y = size_tv_y
	else
		size_x = size_radio_x
		size_y = size_radio_y
		x_beg  = SCREEN.OFF_X
		y_beg  = SCREEN.OFF_Y
		x_end  = SCREEN.END_X - size_x
		y_end  = SCREEN.END_Y - size_y
	end

	p_tv = cpicture.new{x=SCREEN.OFF_X, y=SCREEN.OFF_Y, dx=size_x, dy=size_y, image='/tmp/iss-location.jpg'}
	p    = p_tv

	repeat
		os.execute('wget -q -O - '..image..' > /tmp/iss-location.jpg')
		if  size_x == size_tv_x
		then
			p_tv:paint()
		else
			start_x = math.random(x_beg, x_end)
			start_y = math.random(y_beg, y_end)
			p:hide{no_restore=true}
			p = cpicture.new{x=start_x, y=start_y, dx=size_x, dy=size_y, image='/tmp/iss-location.jpg'}
			p:paint()
		end
		i = 0
		repeat
			i = i + 1
			msg, data = n:GetInput(500)
		until msg == RC.ok or msg == RC.home or msg == RC.red or i == timeout
		if msg == RC.red
		then
			if image == image1
			then
				image = image2
			else
				image = image1
			end
		end
	until msg == RC['home']

	os.execute('rm /tmp/iss-location.jpg')
end

main()
