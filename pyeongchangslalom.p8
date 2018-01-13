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

function _init() end

function _update60() end

function _draw()
	cls()
	rectfill(0,0,127,150,12)
	circfill(64,288,200,7)
	print("derstandard.at slalom",24,21,0)
	print("derstandard.at slalom",23,20,7)
	print("olypia 2018",41,31,0)
	print("olypia 2018",40,30,7)
	circ(47,50,6,1)
	circ(54,57,6,10)
	circ(61,50,6,0)
	circ(68,57,6,3)
	circ(75,50,6,8)
	map(0,0,0,120,16,16)
	spr(0,53,80,2,2)
	spr(3,56,89,1,2)
--	spr(2,80,50,1,2)
--	spr(3,90,50,1,2)
--	spr(4,100,50,1,2)
end
__gfx__
00000000000000000000000000000000000000007777777777777775577777777777777557777777000000000000000000000000000000000000000000000000
000ee000000000000000000000000000000000007777777777777757757777777777775775777777000000000000000000000000000000000000000000000000
00ee8008800000000088800000888000008880007777777777777577775777777777757777576777000000000000000000000000000000000000000000000000
008280e8880000000888880008888800088888007777777777775777777577777767577777757777000000000000000000000000000000000000000000000000
00828e8e888000000ff88800084f4800084f48007777777777757777776757777775777777775777000000000000000000000000000000000000000000000000
0082e828e88800000ff8880008fff80008fff8007777777777576777777775777757777777777577000000000000000000000000000000000000000000000000
008e82e28e88800000fff00000fff00000fff0007777777775777777777777577577777777777757000000000000000000000000000000000000000000000000
00e82eee28e888000088800088888880888888807777777757777777777777755777777777777775000000000000000000000000000000000000000000000000
0e82eeeee28e88800088800080888080808880807777777757777777777777750000000000000000000000000000000000000000000000000000000000000000
e82eeeeeee28e8200085800080888080808880807677777757777777777777750000000000000000000000000000000000000000000000000000000000000000
82eeeeeeeee282200088500050888050508880507777777757777777777777750000000000000000000000000000000000000000000000000000000000000000
0eeee828eeee22200008050005808055058080057777777757777777777777750000000000000000000000000000000000000000000000000000000000000000
0eeee282eeee22200008000000858500008580007777777757777777777777750000000000000000000000000000000000000000000000000000000000000000
0eeee828eeee22205555555000505000005050007777767757777777777777750000000000000000000000000000000000000000000000000000000000000000
0eeee282eeee22000000000005050000005050007777777757777777777777750000000000000000000000000000000000000000000000000000000000000000
0eeee828eeee20000000000050500000005050007777777757777777777777750000000000000000000000000000000000000000000000000000000000000000
__map__
1515151515151515151515151515151500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1515151515151515151515151515151500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1515151515151515151515151515151500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1515151515151515151515151515151500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1515151515151515151515151515151500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1515151515151515151515151515151500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1515151515151515151515151515151500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1515151515151515151515151515151500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1515151515151515151515151515151500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1515151515151515151515151515151500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1515151515151515151515151515151500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1515151515151515151515151515151500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1515151515151515151515151515151500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1515151515151515151515151515151500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
15151515151515151515151515151515003a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
15151515151515151515151515151515003a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818181818181818181818181818181800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818181818181818181818181818181800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818181818181818181818181818181800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818181818181818181818181818181800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000400001605017600166001660016600176000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
