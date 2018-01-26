pico-8 cartridge // http://www.pico-8.com
version 15
__lua__
-- pyeongchang slalom
-- by mario zoth and klemens kunz

-- todos:
-- sfx/music
--  start musik
--  publikum zieleinfahrt
--  fanfare

--code:
-- tab1=init u. startscreen
-- tab2=game
-- spriteflags:
--  x-------/1 = rough ground
--  -x------/2 = missed pole
--  --x-----/4 = crash
--  ---x----/8 = finish line

function update_start()
	if btn(5) and countin==-1 then
		countin=0
	end
end

function draw_start()
	cls()
	camera(camera_x,camera_y)
	--map
 map(0,0,0,0,16,64)
 --himmel
 rectfill(0,0,127,90-scene_offset,12)
 if countin!=-1 then
  countin=mid(1,countin+1,90)
  scene_offset=mid(0,scene_offset+1,35)
  if countin==90 then
   timer.paused=false
   skier.spr_nr=34
   skier.speed=2
   skier.y=54
   print("los!",58,50,7)
   sfx(9)
   _update=update_game
   _draw=draw_game
  elseif countin>59 then
   print("1",62,60-scene_offset,7)
   if (countin < 66) sfx(8)
  elseif countin>29 then
   print("2",62,60-scene_offset,7)
   if (countin < 36) sfx(8)
  else
   print("3",62,60-scene_offset,7)
   if (countin < 5)	sfx(8)
  end
 else
  --titeltext
   print("derstandard.at slalom",23,11,0)
   print("derstandard.at slalom",22,10,7)
   print("olympia 2018",41,43,0)
   print("olympia 2018",41,42,7)
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
	--starthaus
	spr(0,57,80-scene_offset,2,2)
	--rennlaeufer
	spr(skier.spr_nr,skier.x,skier.y-scene_offset,1,2)
end

function reset_game()
	countin=-1
	camera_x=0
	camera_y=0
	camera_y_max=1560
	scene_offset=0
	
	skier.spr_nr=33
	skier.x=60
	skier.y=89
	skier.cel_x=0
	skier.cel_y=0
	skier.coll_cel=0
	skier.collision=0
	skier.speed=2
	skier.over_finishline=false
	skier.disqualified=false
	
	
	timer.x=80
	timer.y=118
	timer.colour=0
	timer.frames=0
	timer.seconds=0
	timer.minutes=0
	timer.output="00:00:00"
	timer.paused=true

 map_part=0
	_update=update_start
	_draw=draw_start
end

function _init()
	game_over=false
	countin=-1
	camera_x=0
	camera_y=0
	camera_y_max=1560
	scene_offset=0
	skier={
		spr_nr=33,
		x=60,
		y=89,
		cel_x=0,
		cel_y=0,
		coll_cel=0,
		collision=0,
		speed=2,
		over_finishline=false,
		disqualified=false
	}
	timer={
		x=80,
		y=118,
		colour=0,
		frames=0,
		seconds=0,
		minutes=0,
		output="00:00:00",
		paused=true
	}
 map_part=0
 
	_update=update_start
	_draw=draw_start
end

function _update() end
function _draw() end
-->8
function write_timer_output(f,s,m)
	local h=flr(f*3.2)
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
	if f < 29 then f+=1 else
		f=0
		
		if s < 29 then s+=1 else
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
	if btn(5) then
			if (game_over) _init()
	end
	
	map_part=flr((camera_y+skier.y)/512)
	--skier.cel_x=flr((skier.x)/8)+(map_part*16)
	--skier.cel_y=flr((camera_y+skier.y)/8)-(map_part*64)

   skier.cel_x=flr((skier.x+4)/8) + (map_part*16) 
   skier.cel_y=flr((camera_y+skier.y+4)/8) - (map_part*64)
	
	skier.coll_cel=mget(skier.cel_x,skier.cel_y+1)
	skier.collision=fget(skier.coll_cel)
	
	if skier.collision==1 or skier.collision==3 then
		skier.speed=1
	end
	
	if skier.collision==2 or skier.collision==3  then
		skier.disqualified=true
	end
	
	if skier.collision==8 then
	 sfx(10)
	 sfx(12)
	 sfx(13)
		skier.over_finishline=true
		timer.paused=true
	end
	
	if not timer.paused then
		update_timer()
	end
	
	camera_y=mid(0,camera_y+skier.speed,camera_y_max)
	
	if camera_y==camera_y_max then
		timer.paused=true
	end
	
	if skier.disqualified then
		timer.paused=true
		skier.speed=mid(0,skier.speed-0.1,2)
		game_over=true
	else
	
 	if btnp(0) then
 		skier.speed=mid(0.5,skier.speed-1,4)
 		skier.spr_nr=mid(32,skier.spr_nr-1,36)
 		if skier.spr_nr == 33 then
 				sfx(10,-1,0,2)
 		end
 	elseif btnp(1) then
 		skier.spr_nr=mid(32,skier.spr_nr+1,36)
 		if skier.spr_nr == 35 then
 				sfx(10,-1,0,2)
 		end
 	end
 	
 	if skier.over_finishline then
 		skier.speed=mid(0,skier.speed-0.1,4)
 		skier.spr_nr=mid(32,skier.spr_nr-1,36)
 		game_over=true
 	else
  	
  	if skier.spr_nr>34 then
  		skier.x=mid(0,skier.x+skier.speed,120)
  	elseif skier.spr_nr<34 then
  		skier.x=mid(0,skier.x-skier.speed,120)
  	end
  	
  	if skier.spr_nr==34 then
  		skier.speed=4
  	elseif skier.spr_nr==33
  					or skier.spr_nr==35 then
  		skier.speed=2
  	elseif skier.spr_nr==32
  					or	skier.spr_nr==36 then
  		skier.speed=1
  	end
  end
	end
end

function draw_game()
	cls()
	camera(camera_x,camera_y)
	--map
	map(0,0,0,0,16,64) --teil1
	--himmel
 rectfill(0,0,127,90-scene_offset,12)
	map(16,0,0,512,16,64) --teil2
	map(32,0,0,1024,16,64) --teil3
	map(48,0,0,1536,16,32) --ziel
	--starthaus
	spr(0,57,45,2,2)
	--rennlaeufer
	spr(skier.spr_nr,skier.x,camera_y+skier.y,1,2)
	print("los!",58,50-scene_offset,7)
	map(114,60,8,1560,16,32) --zielbanner
	--bannerbeschriftung
 print("▒ziel▒",50,1566,1)
 print("▒ziel▒",49,1566,7)

 if skier.over_finishline then
		rectfill(0,camera_y+80,127,camera_y+90,8)
		timer.x=50
		timer.y=83
		timer.colour=7
		print(timer.output,timer.x+1,camera_y+timer.y+1,0)
 elseif skier.disqualified then
 	rectfill(0,camera_y+80,127,camera_y+90,8)
 	print("disqualifiziert!",36,camera_y+83,7)
 else
 end

 if not skier.disqualified then
	 print(timer.output,timer.x,camera_y+timer.y,timer.colour)
	end
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
0e82eeeee28e88800000000000000000000000006777677777777765567777777777777777777777568888000000000000888865000000000000000000000000
e82eeeeeee28e8200000000000000000000000007777777775777765567777577777777777777777568880000000000000088865000000000000000000000000
82eeeeeeeee282200000000000000000000000007757776777777765567777777777777777777777568800000000000000008865000000000000000000000000
0eeee828eeee22200000000000000000000000007777777777777765567777777777777777777777568000000000000000000865000000000000000000000000
0eeee282eeee22200000000000000000000000006777677777777765567777777777777777777777568000000000000000000865000000000000000000000000
0eeee828eeee22200000000000000000000000007777777777777665566777777777777777777777568000000000000000000865000000000000000000000000
0eeee282eeee22000000000000000000000000007767775777777765567777777777777777777777568000000000000000000865000000000000000000000000
0eeee828eeee20000000000000000000000000007777777777777765567777777777777777777777568000000000000000000865000000000000000000000000
00000000000000000000000000000000000000007777777777777777777777777777777711111111568000000000000000000865000000000000000000000000
00000000000000000000000000000000000000007777777777777777777777777777777711111111568000000000000000000865000000000000000000000000
00888000008880000088800000888000008880007777777777777777777777777777777711111111568000000000000000000865000000000000000000000000
0888880008888800088888000888880008888800877777777777777c77777778c777777711111111568000000000000000000865000000000000000000000000
0ff88800084f4800084f4800084f48000888ff00877777777777777c77777778c777777711111111568000000000000000000865000000000000000000000000
0ff8880008fff80008fff80008fff8000888ff00877777777777777c77777778c777777711111111568000000000000000000865000000000000000000000000
00fff00000fff00000fff00000fff00000fff000877777777777777c77777778c777777711111111568000000000000000000865000000000000000000000000
0088800088888880888888808888888000888000877777777777777c77777778c777777711111111568000000000000000000865000000000000000000000000
0088800080888080808880808088808000888000877777777777777c77777778c777777767776777677777777777777600000000000000000000000000000000
0085800080888080808880808088808000858000877777777777777c77777778c777777777777777677777777777777600000000000000000000000000000000
0088500050888050508880505088805000588000877777777777777c77777778c777777777577767767777777777776700000000000000000000000000000000
0008050005808055058080050580805005080000877777777777777c77777778c777777777777777767777777777776700000000000000000000000000000000
0008000000858500008580000085850500080000877777777777777c77777778c777777767776777776777777777767700000000000000000000000000000000
5555555000505000005050000050500055555550877777777777777c77777778c777777777777777776777777777767700000000000000000000000000000000
0000000005050000005050000005050000000000877777777777777c77777778c777777777677757777677777777677700000000000000000000000000000000
0000000050500000005050000000505000000000877777777777777c77777778c777777777777777777677777777677700000000000000000000000000000000
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
5150505050505050b350505050b35051515052505072505050505050505050515151515050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505050505050505051939353505073938181818181818181935151515150505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
515050505050505050505050505050515150a3505050a35050505050505050515151515150505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505050505050505051515050505050505050505050505050515151515152505072505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505050505050505051515050505050505050505050505050519393939353505073938181818181819300000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
515050505050505050505050505050515150505050505050505050505050505151505151a3505050a35050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505050505050505051515050505050505050505050505050515150515151505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51825050506250505050505050505051515050505050505050505050505050515150505051505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
93835050506393818181818181818193515050505050505050505050505050515150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51a350505050a3505050505050505051515050505050505050825050625050515150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505050505050505051938181818181818193835050639381935150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
515050505050505050505050505050515150505050505050b3505050b35050515150505050505050508250506250505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505050505050505051515050505050505050505050505050519381818181818181938350506393819300000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505050505050505051515050505050505050505050505050515150505050505050b3505050b350505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505050505050505051515050505050505050505050505050515150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505050505050505051515050505050505050505050505050515150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505052505050725051515050505050505050505050505050515150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
93818181818181819353505050739393515050505050505050505050505050515150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5150505050505050b350505050b35051515050505050505050505050505050515150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505050505050505051515050505250505072505050505050515150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505050505050505051938181935350505073938181818181935150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5150505050505050505050505050505151505050a350505050a35050505050515150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050825050625050505051515050505050505050505050505050515150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
93818181818193835050639381818193515050505050505050505050505050515150505050525050725050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050a3505050a350505051515050505050505050505050505050519381818193535050739381818181819300000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505050505050505051515050505050505050505050505050515150505050a3505050a350505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505050505050505051515050505050505050505050505050515150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505050505050505051515050505050505050505050505050515150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505050505050505051515050505050505050505050505050515150505050505050505050505050505100000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0b0b0b0b0b0b0b0b0b0b0b0b0c0
51505050505050505050505050505051515050505050505050505050505050515150505050505050505050505050505100000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0b0b0b0b0b0b0b0b0b0b0b0b0c0
51505050505050505052505050725051515050505050505050505050505050515150505050505050505050505050505100000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a1202020202020202020202020c1
93818181818181819353505050739393515050505050505050505050505050515150505050505050505050505050505100000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a2202020202020202020202020c2
__gff__
0000000000000000000000000000000000000000000101010208000000000000000000000000000000040000000000000000000000000000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0505050505050505050505050505050515050505050505053b050505053b0515150505050505050505050505050505151505050505050505050505050505051500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050515050505050505050505050505050515150505050505050505050505050505151505050505050505050505050505051500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050515050505050505050505050505050515150505050505250505270505050505151505050505050505050505050505051500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050515050505050505050505050505050515391818181839350505373918181818391505050505050505050505050505051500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05050505050505050505050505050505150505050505050505050505050505151505050505053a0505053a05050505151505050505050505050505050505051500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050515050505050505050505050505050515150505050505050505050505050505151505050505050505050505050505051500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050515050505050505050505050505050515150505050505050505050505050505151505050505050505050505050505051500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050515050505050505050505050505050515150505050505050505050505050505151519191919191919191919191919191500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050515050505050505050505050505050515150505050505050505050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050515050505050505050505050505050515150505050505050505050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050515050505050505050505050505050515150505050505151515050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050515050505050505050505050505050515150505050515151515050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050515050505050505050505050505050515150505050515151515050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050515050505050505050505050505050515150505050505151515050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050515050505050528050505260505050515150505050515151515050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1505050505050505050505050505051539181818183938050505363918181839150505050515151515050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1505050505050505050505050505051515050505053b050505053b0505050515150505050515151515050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1505050505050505050505050505051515050505050505050505050505050515150505050505051515150505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1505050505050505050505050505051515050505050505050505050505050515150505050505051515050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1505050505050505050505050505051515050505050505050505050505050515150505050505050505050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1505280505052605050505050505051515050505050505150505050505050515150505050505050505050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3939380505053639181818181818183915050505050515151505050505050515150505050505050505050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
15053a050505053a050505050505051515050505051515151515050505050515150505050505050505050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1505050505050505050505050505051515050505051515151515150505050515150505050505050528050505052605150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1505050505050505050505050505051515050505151515151515150505050515391818181818183938050505053639390505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1505050505050505050505050505051515050505151515151515150505050515150505050505053b05050505053b05150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1505050505050505050505050505051515050505151515151515050505050515150505050505050505050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1505050505050505050505050505051515050505051515151505050505050515150505050505050505050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1505050505050505050505050505051515050505050515150505050505050515150505050505050505050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1505050505050505050505050505051515050505050505050505050505050515150505050505050505050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1505050505050505052505050527051515050505050505050505050505050515150505050505050505050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3918181818181818393505050537393915050505050505050505050505050515150505050505050505050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000400002200022000166001660016600176000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000002e0002e0002e0002e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400002205022050166001660016600176000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000002e0502e0502e0502e05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010b00002361123621236212363123631236212361100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000112501420016250000001a250000001d2501d200000001a2001a250182001d2501d2501d2001d20000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00003f6373a63230640336402f65036650346403a6403c630356303c6303a6303f6203b62036610396103760000000000001a000000000000000000000000000000000000000000000000000000000000000
001100001b7751b7751b7751b7751b7751b7751b7751b775000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000003f0573f0573f0570000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 4c424344

