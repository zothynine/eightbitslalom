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
-- spriteflags:
--  x-------/1 = rough ground
--  -x------/2 = missed pole
--  --x-----/4 = crash
--  ---x----/8 = finish line
function update_start()
	if btn(5) then countin=0 end
end

function draw_start()
	cls()
	--map
 map(0,0,0,0,16,64)
 --himmel
 rectfill(0,0,127,90-scene_offset,12)
 if countin!=-1 then
  countin=mid(1,countin+1,180)
  scene_offset=mid(0,scene_offset+1,35)
  if countin==180 then
   print("los!",58,50,7)
   timer.paused=false
   skier.spr_nr=34
   skier.speed=2
   skier.y=54
   _update60=update_game
   _draw=draw_game
  elseif countin>119 then
   print("1",62,60-scene_offset,7)
  elseif countin>59 then
   print("2",62,60-scene_offset,7)
  else
   print("3",62,60-scene_offset,7)
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
		speed=1,
		disqualified=false
	}
 map_part=0
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
	camera_y=mid(0,camera_y+skier.speed,camera_y_max)
	if camera_y==camera_y_max then
		timer.paused=true
	end
	if skier.disqualified then
		timer.paused=true
		skier.speed=mid(0,skier.speed-0.1,2)
	else
 	if btnp(0) then
 		skier.speed=mid(0.5,skier.speed-1,2)
 		skier.spr_nr=mid(32,skier.spr_nr-1,36)
 	elseif btnp(1) then
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
	end
	if skier.collision==1 then
		skier.speed=0.5
	end
	if skier.collision==2 then
		skier.disqualified=true
	end
	if skier.collision==8 then
		timer.paused=true
	end
	if skier.spr_nr > 34 then
		skier.x=mid(0,skier.x+skier.speed,120)
	elseif skier.spr_nr < 34 then
		skier.x=mid(0,skier.x-skier.speed,120)
	end
	map_part=flr((camera_y+skier.y)/512)
	skier.cel_x=flr((skier.x)/8)+(map_part*16)
	skier.cel_y=flr((camera_y+skier.y)/8)-(map_part*64)
	skier.coll_cel=mget(skier.cel_x,skier.cel_y+1)
	skier.collision=fget(skier.coll_cel)
end

function draw_game()
	cls()
	camera(camera_x,camera_y)
	print("los!",58,50,7)
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
	spr(skier.spr_nr,camera_x+skier.x,camera_y+skier.y,1,2)
	map(114,60,8,1560,16,32) --zielbanner
	--bannerbeschriftung
 print("▒ziel▒",51,1567,1)
 print("▒ziel▒",50,1567,7)
 print(timer.output,80,camera_y+118,0)
 
 --print(skier.collision,3,camera_y+3)
 if skier.disqualified then
 	rectfill(0,camera_y+80,127,camera_y+90,8)
 	print("disqualifiziert!",36,camera_y+83,7)
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
0e82eeeee28e888000000000000000000000000077777777777777655677777777777777bbbbbbbb568888000000000000888865000000000000000000000000
e82eeeeeee28e82000000000000000000000000076777777767777655677777777777777bbbbbbbb568880000000000000088865000000000000000000000000
82eeeeeeeee2822000000000000000000000000077777777777777655677777777777777bbbbbbbb568800000000000000008865000000000000000000000000
0eeee828eeee222000000000000000000000000077777777777777655677777777777777bbbbbbbb568000000000000000000865000000000000000000000000
0eeee282eeee222000000000000000000000000077777777777777655677777777777777bbbbbbbb568000000000000000000865000000000000000000000000
0eeee828eeee222000000000000000000000000077777677777776655677767777777777bbbbbbbb568000000000000000000865000000000000000000000000
0eeee282eeee220000000000000000000000000077777777777777655677777777777777bbbbbbbb568000000000000000000865000000000000000000000000
0eeee828eeee200000000000000000000000000077777777777777655677777777777777bbbbbbbb568000000000000000000865000000000000000000000000
00000000000000000000000000000000000000007777777777777777777777777777777711111111568000000000000000000865000000000000000000000000
00000000000000000000000000000000000000007777777777777777777777777777777711111111568000000000000000000865000000000000000000000000
00888000008880000088800000888000008880007777777777777777777777777777777711111111568000000000000000000865000000000000000000000000
0888880008888800088888000888880008888800877777777777777c77777778c777777711111111568000000000000000000865000000000000000000000000
0ff88800084f4800084f4800084f48000888ff00877777777777777c77777778c777777711111111568000000000000000000865000000000000000000000000
0ff8880008fff80008fff80008fff8000888ff00877777777777777c77777778c777777711111111568000000000000000000865000000000000000000000000
00fff00000fff00000fff00000fff00000fff000877777777777777c77777778c777777711111111568000000000000000000865000000000000000000000000
0088800088888880888888808888888000888000877777777777777c77777778c777777711111111568000000000000000000865000000000000000000000000
0088800080888080808880808088808000888000877777777777777c77777778c777777700000000000000000000000000000000000000000000000000000000
0085800080888080808880808088808000858000877777777777777c77777778c777777700000000000000000000000000000000000000000000000000000000
0088500050888050508880505088805000588000877777777777777c77777778c777777700000000000000000000000000000000000000000000000000000000
0008050005808055058080050580805005080000877777777777777c77777778c777777700000000000000000000000000000000000000000000000000000000
0008000000858500008580000085850500080000877777777777777c77777778c777777700000000000000000000000000000000000000000000000000000000
5555555000505000005050000050500055555550877777777777777c77777778c777777700000000000000000000000000000000000000000000000000000000
0000000005050000005050000005050000000000877777777777777c77777778c777777700000000000000000000000000000000000000000000000000000000
0000000050500000005050000000505000000000877777777777777c77777778c777777700000000000000000000000000000000000000000000000000000000
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
61818181818181505050505050505071615050505050505050505050505050716150505050505050505050505050507100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61505050505050505050505050505071615050505050505050505050505050716150505050505050505050505050507100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61505050505050505050505050505071615050505050505050505050505050716150505050505050505050505050507100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61505050505050505050505050505071615050505050505050505050505050716150505050505050505050505050507100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61505050505050505050505050505071615050505050505050505050505050716150505050505050505050505050507100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61505050505050505050505050505071615050505050505050505050505050716150505050505050505050505050507100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61505050505050505050505050505071615050505050505050505050505050716182505050506250505050505050507100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61505050505050505050505050505071615050505050505050505050505050716183505050506350505050505050507100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61505050505050505050505050505071615050505050505050505050505050716150505050505081818181818181817100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61825050505062505050505050505071615050505050505250505050505072716150505050505050505050505050507100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61835050505063505050505050505071615050505050505350505050505073716150505050505050505050505050507100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61505050505050818181818181818171618181818181815050505050505050716150505050505050505050505050507100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61505050505050505050505050505071615050505050505050505050505050716150505050505050505050505050507100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61505050505050505050505050505071615050505050505050505050505050716150505050505050505050505050507100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61505050505050505050505050505071615050505050505050505050505050716150505050505050505050505050507100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61505050505050505050505050505071615050505050505050505050505050716150505050505050505050505050507100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61505050505050505050505050505071615050505050505050505050505050716150505050505052505050505050727100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61505050505050505050505050505071615050505050505050505050505050716150505050505053505050505050737100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61505050505050505050505050505071615050505050505050505050505050716181818181818150505050505050507100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61505050505050525050505050507271615050505050505050505050505050716150505050505050505050505050507100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61505050505050535050505050507371615050505050505050505050505050716150505050505050505050505050507100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61818181818181505050505050505071615050505050505050505050505050716150505050505050505050505050507100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61505050505050505050505050505071615050505050505050505050505050716150505050505050505050505050507100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61505050505050505050505050505071615050505050505050505050505050716150505050505050505050505050507100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61505050505050505050505050505071615050505050505050505050505050716150505050505050505050505050507100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61505050505050505050505050505071615050505050505050505050505050716150505050505050505050505050507100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61505050505050505050505050505071615050505050505250505050505072716150505050505050505050505050507100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61505050505050505050505050505071615050505050505350505050505073716182505050506250505050505050507100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61505050505050505050505050505071618181818181815050505050505050716183505050506350505050505050507100000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0b0b0b0b0b0b0b0b0b0b0b0b0c0
61505050505050505050505050505071615050505050505050505050505050716150505050505081818181818181817100000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0b0b0b0b0b0b0b0b0b0b0b0b0c0
61505050505050505050505050505071615050505050505050505050505050716150505050505050505050505050507100000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a1202020202020202020202020c1
61505050505050505050505050505071615050505050505050505050505050716150505050505050505050505050507100000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a2202020202020202020202020c2
__gff__
0000000000000000000000000000000000000000000101010208000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0505050505050505050505050505050516050505050505050505050505050517160505050505050505050505050505171628050505052605050505050505051700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050516050505050505050505050505050517160505050505050505050505050505171638050505053605050505050505051700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050516050505050505050505050505050517160505050505050505050505050505171605050505050518181818181818181700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050516050505050505050505050505050517160505050505050505050505050505171605050505050505050505050505051700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050516050505050505050505050505050517160505050505050505050505050505171605050505050505050505050505051700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050516050505050505050505050505050517160505050505052505050505050527171605050505050505050505050505051700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050516050505050505050505050505050517160505050505053505050505050537171605050505050505050505050505051700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050516050505050505050505050505050517161818181818180505050505050505170819191919191919191919191919190900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050516050505050505050505050505050517160505050505050505050505050505170505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050516050505050505050505050505050517160505050505050505050505050505170505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050516050505050505250505050505052717160505050505050505050505050505170505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050516050505050505350505050505053717160505050505050505050505050505170505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050516181818181818050505050505050517160505050505050505050505050505170505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050516050505050505050505050505050517160505050505050505050505050505170505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050516050505050505050505050505050517160505050505050505050505050505170505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0705050505050505050505050505050616050505050505050505050505050517160505050505050505050505050505170505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1605050505050505050505050505051716050505050505050505050505050517160505050505050505050505050505170505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1605050505050505050505050505051716280505050526050505050505050517160505050505050505050505050505170505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1605050505050505050505050505051716380505050536050505050505050517162805050505260505050505050505170505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1605050505050505050505050505051716050505050505181818181818181817163805050505360505050505050505170505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1628050505052605050505050505051716050505050505050505050505050517160505050505051818181818181818170505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1638050505053605050505050505051716050505050505050505050505050517160505050505050505050505050505170505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1605050505050518181818181818181716050505050505050505050505050517160505050505050505050505050505170505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1605050505050505050505050505051716050505050505050505050505050517160505050505050505050505050505170505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1605050505050505050505050505051716050505050505050505050505050517160505050505050505050505050505170505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1605050505050505050505050505051716050505050505050505050505050517160505050505050505050505050505170505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1605050505050505050505050505051716050505050505050505050505050517160505050505050505050505050505170505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1605050505050505050505050505051716050505050505250505050505052717160505050505050505050505050505170505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1605050505050505050505050505051716050505050505350505050505053717160505050505052505050505050527170505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1605050505050505050505050505051716181818181818050505050505050517160505050505053505050505050537170505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1605050505050525050505050505271716050505050505050505050505050517161818181818180505050505050505170505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1605050505050535050505050505371716050505050505050505050505050517160505050505050505050505050505170505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000400001605017600166001660016600176000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
