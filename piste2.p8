pico-8 cartridge // http://www.pico-8.com
version 15
__lua__
-- durchgang 2
-- by mario zoth and klemens kunz

music(0)

function load_cart(cart_name)
	load(cart_name,cart.curr)
end

function update_start()
	if btnp(5) and countin==-1 then
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
   music(-1)
  end
 else
  --titeltext
   print("2. durchgang",40,46,0)
   print("2. durchgang",40,45,7)
   --olympische ringe
   local ring_x=49
   local ring_y=20
   local ring_rad=6
   circ(ring_x,ring_y,ring_rad,1)
   circ(ring_x+7,ring_y+7,ring_rad,10)
   circ(ring_x+14,ring_y,ring_rad,0)
   circ(ring_x+21,ring_y+7,ring_rad,3)
   circ(ring_x+28,ring_y,ring_rad,8)
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
 
 cart={
 	prev="piste1",
 	curr="piste2",
 	next=nil
 }
 
 drone={
 	sprite=13,
 	x=108,
 	y=6
 }
 
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
	if drone.sprite==13 then
		drone.sprite+=1
	else
		drone.sprite-=1
	end
	
	if btnp(5) then
			if (skier.disqualified) _init()
	end
	
	if btnp(4) and cart.next != nil then
			if (skier.over_finishline) load_cart(cart.next)
	end
	
	map_part=flr((camera_y+skier.y)/512)
 skier.cel_x=flr((skier.x+4)/8) + (map_part*16) 
 skier.cel_y=flr((camera_y+skier.y+4)/8) - (map_part*64)	
	skier.coll_cel=mget(skier.cel_x,skier.cel_y+1)
	skier.collision=fget(skier.coll_cel)
	
	if skier.collision==2 or skier.collision==3  then
  sfx(15)
		skier.disqualified=true
	end
	
	if skier.collision==1 or skier.collision==3 then
		skier.speed=1
	end
	
	if skier.collision==8 then
	 sfx(10)
	 sfx(12)
	 sfx(13)
	 sfx(14)
	 sfx(16)
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
	else
	
 	if btnp(0) then
 		skier.speed=mid(0.5,skier.speed-1,4)
 		skier.spr_nr=mid(32,skier.spr_nr-1,36)
 		if skier.spr_nr == 33 then
 				sfx(10)
 		end
 	elseif btnp(1) then
 		skier.spr_nr=mid(32,skier.spr_nr+1,36)
 		if skier.spr_nr == 35 then
 				sfx(10)
 		end
 	end
 	
 	if skier.over_finishline then
 		skier.speed=mid(0,skier.speed-0.1,4)
 		skier.spr_nr=mid(32,skier.spr_nr-1,36)
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
 	local rectheight=10
 	
 	if (cart.next!=nil) rectheight=20
		
		rectfill(0,camera_y+80,127,camera_y+80+rectheight,8)
		timer.x=50
		timer.y=83
		timer.colour=7
		print(timer.output,timer.x+1,camera_y+timer.y+1,0)
		if cart.next != nil then
			print("naechste piste mit [c]",23,camera_y+timer.y+11,0)
			print("naechste piste mit [c]",22,camera_y+timer.y+10,7)
		end
 elseif skier.disqualified then
 	rectfill(0,camera_y+80,127,camera_y+90,8)
 	print("disqualifiziert!",36,camera_y+83,7)
 else
 end

 if not skier.disqualified then
	 print(timer.output,timer.x,camera_y+timer.y,timer.colour)
	end
	
	if timer.frames<16 then
		pal(3,8)
		pal(11,1)
	else
		pal(3,1)
		pal(11,8)
	end
	spr(drone.sprite,drone.x,camera_y+drone.y)
	pal()
end
__gfx__
00000000000000000000000000000000000000007777777777777765567777777777777557777777568888888888888888888865000000000000000000000000
000ee000000000000000000000000000000000007777777777777657756777777777775665777777568888888888888888888865000000000000000000000000
00ee8008800000000000000000000000000000007777777777776577775677777777756776576777568888888888888888888865555000500500055500000000
008280e8880000000000000000000000000000007777777777765777777567777767567777657777568888888888888888888865010000100100001000000000
00828e8e888000000000000000000000000000007777777777657777776756777775677777765777568888888888888888888865011111100111111000000000
0082e828e888000000000000000000000000000077777777765767777777756777567777777765775688888888888888888888650013b1000013b10000000000
008e82e28e8880000000000000000000000000007777777765777777777777567567777777777657568888888888888888888865000000000000000000000000
00e82eee28e888000000000000000000000000007777777757777777777777755677777777777765568888888888888888888865000000000000000000000000
0e82eeeee28e88800000000000000000000000006777677767776777677767767777777777777777568888000000000000888865000000000000000000000000
e82eeeeeee28e8200000000000000000000000007777777767777777777777767777777777777777568880000000000000088865000000000000000000000000
82eeeeeeeee282200000000000000000000000007757776776577767775777677777777777777777568800000000000000008865000000000000000000000000
0eeee828eeee22200000000000000000000000007777777776777777777777677777777777777777568000000000000000000865000000000000000000000000
0eeee282eeee22200000000000000000000000006777677767676777677766777777777777777777568000000000000000000865000000000000000000000000
0eeee828eeee22200000000000000000000000007777777777677777777776777777777777777777568000000000000000000865000000000000000000000000
0eeee282eeee22000000000000000000000000007767775777767757776767577777777777777777568000000000000000000865000000000000000000000000
0eeee828eeee20000000000000000000000000007777777777767777777767777777777777777777568000000000000000000865000000000000000000000000
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
51505050505050505050505050505051515050505050505050505050505050519381818181819383506393818181819300000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5150505050505050505050505050505151505050505050505050505050505051515050505050b35050b350505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050825050625050505050505051515050505050825062505050505050515150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
93818193835050639381818181818193938181818193835063938181818181935150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050a3505050a3505050505050515150505050b35050b3505050505050515150505050505050515050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505050505050505051515050505050505050505050505050515150505050505051515050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505050505050505051515050505050505050505050505050515150505050505151515150505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505050525050507251515050505050505050505050505050515150505050505151515150505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
93818181818181818193535050507393515050505050505050505050505050515150505050515151515150505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
515050505050505050b350505050b351515250725050505050505050505050515150505050515151515151505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505050505050505051935350739381818181818181818181935152505072515151515151505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5150505051505050505050505050515151a35050a350505050505050505050519353505073939393939381818181819300000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
515050515151505050505050505051515150505050505050505050505050505151a3505050a35151515150505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505151515151505050505050515151515050505050505050505050505050515150505050505051515050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51515151515151505050505050505051515050505050505050505050505050515150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51515151515151518250506250505051515050505050505050505050505050515150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
93818181939393938350506393939393515050505050505050505050505050515150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505151b3505050b350515151515050505050505050505050505050515150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505051505050505050515151515050505050505050505050505050515150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505050505050515151515050505050505050505050505050515150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505050505050505151515050505050505050505050505050515150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505050505050505051515050505050505050505050505050515150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505050505050505051515050505050505050505050505050515150505050505050825050625050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505050505050505051515050505050505050505082505062519381818181818193835050639381819300000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
515050505050505050505050505050519381818181818181818193835050639351505050505050b3505050b35050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5150505052505072505050505050505151505050505050505050b3505050b3515150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
93818193535050739381818181818193515050505050505050505050505050515150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050a3505050a350505050505051515050505050505050505050505050515150505050505050505050505050505100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51505050505050505050505050505051515050505050505050505050505050515150505050525072505050505050505100000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0b0b0b0b0b0b0b0b0b0b0b0b0c0
51505050505050505050505050505051515050505050505050505050505050519381818193535073938181818181819300000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0b0b0b0b0b0b0b0b0b0b0b0b0c0
51505050505050505050505050505051515050505050505050505050505050515150505050a35050a35050505050505100000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a1202020202020202020202020c1
51505050505050505050505050505051515050505050505050505050505050515150505050505050505050505050505100000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a2202020202020202020202020c2
__gff__
0000000000000000000000000000000000000000000101010208000000000000000000000000000000040000000000000000000000000000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0505050505050505050505050505050515050505050505050505050505050515150505050505250505270505050505151505050505050505280505260505051500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050515050505050505050505050505050515391818181839350505373918181818393918181818181839380505363918183900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05050505050505050505050505050505150505050505050505050505050505151505050505053a0505053a0505050515150505050505053b0505053b0505051500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050515050505050505052805050526050515150505050505050505050505050505151505050505050505050505050505051500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050539181818181818393805050536391839150505050505050505052805260505151505050505050505050505050505051500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05050505050505050505050505050505150505050505053b050505053b050515391818181818181818393805363918391505050505050505050505050505051500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05050505050505050505050505050505150505050505050505050505050505151505050505050505053b05053b0505151505050505050505050505050505051500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050515050505050505050505050505050515150505050505050505050505050505151519191919191919191919191919191500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050515050505050505050505050505050515150505050505050505050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050515050505050505050505050505050515150505050505050505050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050515050505050505050505050505050515150505050505050505050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050515050505050505050505050505050515150505050505050505050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050515250505052705050505050505050515150505050505050505050505050515150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050539350505053739181818181818181839152505052705050505050505151515150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05050505050505050505050505050505153a0505051516151515151515151515393505053739181818181839393939390505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1505050505050505050505050505051515050505050515151515151515151515153a0505053a050505051515151515150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1505050505052805050526050505051515150505050505151515151515151515150505050505050505051515151515150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3918181818393805050536391818183915151505050505151515151515151515150505050505050505050505151515150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
15050505053b050505053b050505051515151505050505151515151515151515150505050505050505050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1505050505050505050505050505051515151515280526151515151515151515150505050505050505050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1505050505050505050505050505051539393939380536393939393939393939150505050505280526050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
150505050505050505050505050505151515053b05053b050505050505050515391818181839380536391818181818390505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
150505050505050505050505050505151515050505050505050505050505051515050505053b05053b050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1505050505050505050505050505051515050505050505050505050505050515150505050505050505050515150505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1505050505050505050505050505051515050505050505050505050505050515150505050505050505050515151505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1505050505050505050505050505051515052505270505050505050505050515150505052505270505050515150505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1505050505050505050505050505051539393505373918181818181818181839391818393505373918181818181818390505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1525050527050505050505050505051515053a05053a05050505050505050515150505053a05053a05050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3935050537391818181818181818181515050505050505050505050505050515151505050505050505050505050515150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
153a0505053a0505050505050505051515050505050505050505050505050515151505050505050505050505050515150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1505050505050505050505050505051515050505050505050505050505050515151505050505050505050505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1505050505050505050505050505051515050505050505050505050505050515151505050505052805260505050505150505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
011000200f533000000000000000166331662300000000000a533000000000000000166331662300000000000a523000000000000000166331662300000000000a52300000000000000016633166230000000000
011000201d3301b33019330000001433000000193301d3300000020330000001d33020330000001d330000001f3301d3301b3300000016330000001b3301f3300000022330000002033022330203301f33000000
011000200a1200a11000000051300a1200a11000000051300a1200a11000000051300a1200a11005130051200f1200f110000000a1300f1200f110000000a1300f1200f110000000a1300f1200f1100d1300d120
011000201d3401d340000001934019340000001634000000000000000000000000001d3400000020340000001f3401f340000001d3401d340000001f3401f3401f3401f3401f3401f34000000000000000000000
01100000213301f3301d3300000018330000001d330213300000022330000002433024330243302433000000293302433021330000001d3300000024330293302933000000273300000025330000002433000000
011000001112011110000000c1301112011110000000c130051200511000000001300512005110000000013005130051200511000000031300312003110000000113001120011100000000130001200011000000
011000001955119551195511955119551195511955119551205512055120551205512555125551255512555122551225512255122551225512255122551225511f5511f5511f5511f5511f5511f5511f5511f551
0110000020551205512055120551205512055120551205511d5511d5511d5511d551195511955119551195511b5511b5511b5511b5511b5511b5511b5511b5511f5511f5511f5511f5511f5511f5511f5511f551
000400002205022050166001660016600176000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000002e0502e0502e0502e05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00070000236142562127621296312b6312d6412f64100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000112501420016250000001a250000001d2501d200000001a2001a250182001d2501d2501d2001d20000000000000000000000000000000000000000000000000000000000000000000000000000000000
000c0000236172661226610266102661027610286102a6102c6202d6202f62031630326303462035610376103760000000000001a000000000000000000000000000000000000000000000000000000000000000
001100001b7351b7351b7351b7351b7351b7351b7351b735000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000003f0423f0423f04200000000003f0423f0423f04200000000003f0423f0423f04200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a00001135010300103500f3000f3500e3000e3500e3500e3500e3500e350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000f0000183721c3721f37224372000001f3722437224372243720000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000002155121551215512155121551215512155121551215512155121551215512255122551225512255124551245512455124551245512455124551245512455124551245512455124551245512455124551
__music__
01 01020006
00 01020007
00 01020006
02 04050011
00 41424044
00 41424044
00 41424044
00 41454044
00 41424344
00 41424344
00 4c424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 01424344

