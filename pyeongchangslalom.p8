pico-8 cartridge // http://www.pico-8.com
version 15
__lua__
-- pyeongchang slalom
-- by mario zoth radek jedrasiak klemens kunz

-- todos:
-- sfx/music
--  start musik
--  startsignal
--  ski fx
--  ski schwung fx
--  crash fx
--  publikum zieleinfahrt
--  fanfare

--code:
-- tab1=init u. startscreen
-- tab2=game

function update_start()
	if btn(5) then countin=0 end
end

function draw_start()
	cls()
	--himmel
	rectfill(0,0,127,150,12)
	--berg
	circfill(64,288-scene_offset,200,7)
	if countin!=-1 then
		countin=mid(1,countin+1,180)
		scene_offset=mid(0,scene_offset+1,35)
		if countin==180 then
			print("los!",58,50)
			timer.paused=false
			skier.spr_nr=34
			skier.speed=2
			skier.y=54
			_update60=update_game
			_draw=draw_game
		elseif countin>119 then
			print("1",62,60-scene_offset)
		elseif countin>59 then
			print("2",62,60-scene_offset)
		else
			print("3",62,60-scene_offset)
		end
	else
		--titeltext
 	print("derstandard.at slalom",23,11,0)
 	print("derstandard.at slalom",22,10,7)
 	print("olypia 2018",43,43,0)
 	print("olypia 2018",42,42,7)
 	--olympische ringe
 	local ring_x=49
 	local ring_y=25
 	local ring_rad=6
 	circ(ring_x,ring_y,ring_rad,1)
 	circ(ring_x+7,ring_y+7,ring_rad,10)
 	circ(ring_x+14,ring_y,ring_rad,0)
 	circ(ring_x+21,ring_y+7,ring_rad,3)
 	circ(ring_x+28,ring_y,ring_rad,8)
 	print("starte mit ❎",38,55,7)
 	print("steuere mit ⬅️➡️",34,62,7)
	end
	--map
	map(0,0,0,120-scene_offset,16,64)
	--starthaus
	spr(0,57,80-scene_offset,2,2)
	--rennlaeufer
	spr(skier.spr_nr,skier.x,skier.y-scene_offset,1,2)
end

function _init()
	countin=-1
	timer={
		frames=0,
		seconds=0,
		minutes=0,
		output="00:00:00",
		paused=true
	}
	camera_x=0
	camera_y=0
	scene_offset=0
	skier={
		spr_nr=33,
		x=60,
		y=89,
		speed=1
	}
 
	_update60=update_start
	_draw=draw_start
end

function _update60() end
function _draw() end
-->8

	
function write_timer_output(f,s,m)
	local h=flr(f*1.6)
	local fstr=tostr(h)
	local sstr=tostr(s)
	local mstr=tostr(m)
	if h<10 then fstr="0"..fstr end
	if s<10 then sstr="0"..sstr end
	if m<10 then mstr="0"..mstr end
	timer.output=mstr..":"..sstr..":"..fstr
end

function update_timer()
	local f=timer.frames
	local s=timer.seconds
	local m=timer.minutes
	if f < 59 then f+=1 else
		f=0
		
		if s < 59 then s+=1 else
			s=0
			m+=1
		end
	end
	timer.frames=f
	timer.seconds=s
	timer.minutes=m
	write_timer_output(f,s,m)
end

function update_game()
	if not timer.paused then
		update_timer()
	end
	camera_y=mid(0,camera_y+skier.speed,1621)
	if camera_y==1621 then
		timer.paused=true
	end
	if btnp(0) then
		skier.speed=mid(0.5,skier.speed-1,2)
		skier.spr_nr=mid(32,skier.spr_nr-1,36)
	end
	if btnp(1) then
		skier.spr_nr=mid(32,skier.spr_nr+1,36)
	end
	if skier.spr_nr==34 then
		skier.speed=2
	elseif skier.spr_nr==33
					or skier.spr_nr==35 then
		skier.speed=1
	elseif skier.spr_nr==32
					or	skier.spr_nr==36 then
		skier.speed=0.5	
	end
	if skier.spr_nr > 34 then
		skier.x=mid(0,skier.x+skier.speed,120)
	elseif skier.spr_nr < 34 then
		skier.x=mid(0,skier.x-skier.speed,120)
	end
end

function draw_game()
	cls()
	camera(camera_x,camera_y)
	--himmel
	rectfill(0,0,127,150,12)
	--berg
	circfill(64,253,200,7)
	print("los!",58,25)
	--map
	map(0,0,0,85,16,64) --teil1
	map(16,0,0,597,16,64) --teil2
	map(32,0,0,1109,16,64) --teil3
	map(48,0,0,1621,16,32) --ziel
	--starthaus
	spr(0,57,45,2,2)
	--rennlaeufer
	spr(skier.spr_nr,camera_x+skier.x,camera_y+skier.y,1,2)
	map(114,60,8,1645,16,32) --zielbanner
	--bannerbeschriftung
	print("▒ziel▒",51,1652,1)
	print("▒ziel▒",50,1651,7)
	print(timer.output,80,camera_y+118,0)
end
__gfx__
00000000000000000000000000000000000000007777777777777765567777777777777557777777568888888888888888888865000000000000000000000000
000ee000000000000000000000000000000000007777777777777657756777777777775665777777568888888888888888888865000000000000000000000000
00ee8008800000000000000000000000000000007777777777776577775677777777756776576777568888888888888888888865000000000000000000000000
008280e8880000000000000000000000000000007777777777765777777567777767567777657777568888888888888888888865000000000000000000000000
00828e8e888000000000000000000000000000007777777777657777776756777775677777765777568888888888888888888865000000000000000000000000
0082e828e88800000000000000000000000000007777777776576777777775677756777777776577568888888888888888888865000000000000000000000000
008e82e28e8880000000000000000000000000007777777765777777777777567567777777777657568888888888888888888865000000000000000000000000
00e82eee28e888000000000000000000000000007777777757777777777777755677777777777765568888888888888888888865000000000000000000000000
0e82eeeee28e88800000000000000000000000007777777756777777777777650000000000000000568888000000000000888865000000000000000000000000
e82eeeeeee28e8200000000000000000000000007677777756777777777777650000000000000000568880000000000000088865000000000000000000000000
82eeeeeeeee282200000000000000000000000007777777756777777777777650000000000000000568800000000000000008865000000000000000000000000
0eeee828eeee22200000000000000000000000007777777756777777777777650000000000000000568000000000000000000865000000000000000000000000
0eeee282eeee22200000000000000000000000007777777756777777777777650000000000000000568000000000000000000865000000000000000000000000
0eeee828eeee22200000000000000000000000007777767756777777777777650000000000000000568000000000000000000865000000000000000000000000
0eeee282eeee22000000000000000000000000007777777756777777777777650000000000000000568000000000000000000865000000000000000000000000
0eeee828eeee20000000000000000000000000007777777756777777777777650000000000000000568000000000000000000865000000000000000000000000
00000000000000000000000000000000000000007777777777777777000000000000000000000000568000000000000000000865000000000000000000000000
00000000000000000000000000000000000000007777777777777777000000000000000000000000568000000000000000000865000000000000000000000000
00888000008880000088800000888000008880007777777777777777000000000000000000000000568000000000000000000865000000000000000000000000
08888800088888000888880008888800088888005557777777777555000000000000000000000000568000000000000000000865000000000000000000000000
0ff88800084f4800084f4800084f48000888ff005555577777755555000000000000000000000000568000000000000000000865000000000000000000000000
0ff8880008fff80008fff80008fff8000888ff005555557777555555000000000000000000000000568000000000000000000865000000000000000000000000
00fff00000fff00000fff00000fff00000fff0005555577777755555000000000000000000000000568000000000000000000865000000000000000000000000
00888000888888808888888088888880008880005557777777777555000000000000000000000000568000000000000000000865000000000000000000000000
00888000808880808088808080888080008880005777777777777775000000000000000000000000000000000000000000000000000000000000000000000000
00858000808880808088808080888080008580005777777777777775000000000000000000000000000000000000000000000000000000000000000000000000
00885000508880505088805050888050005880005777777777777775000000000000000000000000000000000000000000000000000000000000000000000000
00080500058080550580800505808050050800005777777777777775000000000000000000000000000000000000000000000000000000000000000000000000
00080000008585000085800000858505000800005777777777777775000000000000000000000000000000000000000000000000000000000000000000000000
55555550005050000050500000505000555555505777777777777775000000000000000000000000000000000000000000000000000000000000000000000000
00000000050500000050500000050500000000005777777777777775000000000000000000000000000000000000000000000000000000000000000000000000
00000000505000000050500000005050000000005777777777777775000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505151515050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505051515050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505051515050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0b0b0b0b0b0b0b0b0b0b0b0b0c0
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0b0b0b0b0b0b0b0b0b0b0b0b0c0
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a1818181818181818181818181c1
51615050505050505050505050507151516150505050505050505050505071515161505050505050505050505050715100000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a2818181818181818181818181c2
__map__
0705050505050505050505050505050615160505050505050505050505051715151605050505050505050505050517151516050505050505050505050505171500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505050505050505050505171515160505050505050505050505051715151605050505050505050505050517151516050505050505050505050505171500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505050505050505050505171515160505050505050505050505051715151605050505050505050505050517151516050505050505050505050505171500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505050505050505050505171515160505050505050505050505051715151605050505050505050505050517151516050505050505050505050505171500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505050505050505050505171515160505050505050505050505051715151605050505050505050505050517151516050505050505050505050505171500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505050505050505050505171515160505050505050505050505051715151605050505050505050505050517151516050505050505050505050505171500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505050505050505050505171515160505050505050505050505051715151605050505050505050505050517151516050505050505050505050505171500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505050505050505050505171515160505050505050505050505051715151605050505050505050505050517150805050505050505050505050505050900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505050505050505050505171515160505050505050505050505051715151605050505050505050505050517150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505050525050505050505171515160505050505050505050505051715151605050505050505050505050517150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505050535050505050505171515160505050505050505050505051715151605050505050505050505050517150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505050505050505050505171515160505050505050505050505051715151605050505050505050505050517150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505050505050505050505171515160505050505050505050505051715151605050505050505050505050517150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505050505050505050505171515160505050505050505050505051715151605050505050505050505050517150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505050505050505050505171515160505050505050505050505051715151605050505050505050505050517150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505050505050505050505171515160505050505050505050505051715151605050505050505050505050517150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505050505052605050505171515160505050505050505050505051715151605050505050505050505050517150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505050505053605050505171515160505050505050505050505051715151605050505050505050505050517150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505050505050505050505171515160505050505050505050505051715151605050505050505050505050517150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505050505050505050505171515160505050505050505050505051715151605050505050505050505050517150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505050505050505050505171515160505050505050505050505051715151605050505050505050505050517150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505050505050505050505171515160505050505050505050505051715151605050505050505050505050517150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505050505050505050505170515160505050505050505050505051715151605050505050505050505050517150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505050505050505050505171515160505050505050505050505051715151605050505050505050505050517150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505050505050505050505171515160505050505050505050505051715151605050505050505050505050517150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505051515050505050505171515160505050505050505050505051715151605050505050505050505050517150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505051515050505050505171515160505050505050505050505051715151605050505050505050505050517150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050515151515050505050505171515160505050505050505050505051715151605050505050505050505050517150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050515151515050505050505171515160505050505050505050505051715151605050505050505050505050517150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050515151515050505050505171515160505050505050505050505051715151605050505050505050505050517150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505151515050505050505171515160505050505050505050505051715151605050505050505050505050517150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516050505151515050505050505171515160505050505050505050505051715151605050505050505050505050517150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000400001605017600166001660016600176000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
