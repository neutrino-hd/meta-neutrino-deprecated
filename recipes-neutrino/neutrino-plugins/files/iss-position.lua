--[[
	Anzeige der aktuellen ISS-Position in
	der linken oberen Ecke des Bildschirms

	Copyright (C) 2016,  theobald123
	License: GPL
	
	21.01.2016: Screensaver-Modus ergänzt

]]

function download(Url)
	if Url == nil then 
		return nil 
	end

	if Curl == nil then
		Curl = curl.new()
	end

	ret, data = Curl:download{ url=Url, A='Mozilla/5.0'}
	if ret == CURL.OK then
		return data
	else
		return nil
	end
end

n = neutrino()
modus=download('http://127.0.0.1/control/getmode')

if string.find(modus,'tv')
then
	size = 300
else
	size = 500
	x_beg = SCREEN.OFF_X
	y_beg = SCREEN.OFF_Y
	x_end = SCREEN.END_X - size
	y_end = SCREEN.END_Y - size
end

p_tv = cpicture.new{x=SCREEN.OFF_X, y=SCREEN.OFF_Y, dx=size, dy=size, image='/tmp/iss-location.jpg'}
p = p_tv

repeat
	os.execute('wget -q -O - http://thomas-wehr.eu/main-graphs/iss-location.jpg > /tmp/iss-location.jpg')
	if  size == 300 then
		p_tv:paint()
	else
		start_x = math.random(x_beg, x_end)
		start_y = math.random(y_beg, y_end)
		p:hide()
		p = cpicture.new{x=start_x, y=start_y, dx=size, dy=size, image='/tmp/iss-location.jpg'}
		p:paint()
	end
	msg, data = n:GetInput(60000)
until msg == RC['home']

os.execute('rm /tmp/iss-location.jpg')
