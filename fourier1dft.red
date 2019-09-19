Red [
	Description: {Play-ground to study Discrete Fourier Transform}
	Needs: View
	Date: 12-Sep-2019
	Author: {Toomas Vooglaid}
]
context [
	max*: function [blk [block!]][m: 0 foreach b blk [m: max b m] m]
	min*: function [blk [block!]][m: blk/1 foreach b blk [m: min b m] m]
	avg*: function [blk [block!]][to-integer 1.0 * (sum blk) / length? blk]
	#include %dft.red
	points: [
		100 100 100 100 100 100 100 100 100 100 100 100 
		100 100 100 100 100 100 100 100 100 100 100 100 
		-100 -100 -100 -100 -100 -100 -100 -100 -100 -100 -100 -100
		-100 -100 -100 -100 -100 -100 -100 -100 -100 -100 -100 -100
		100 100 100 100 100 100 100 100 100 100 100 100 
		100 100 100 100 100 100 100 100 100 100 100 100 
		-100 -100 -100 -100 -100 -100 -100 -100 -100 -100 -100 -100
		-100 -100 -100 -100 -100 -100 -100 -100 -100 -100 -100 -100
	]
	avg: avg* points
	forall points [points/1: points/1 - avg]
	lines: dft head points
	
	comment {
	collect [repeat i 100 [keep i]]
	collect [loop 36 [keep random 200]]
	[100 0 50 50 75 -23]
	lines: copy [
		;phase 	freq 	amp
		  0 	 1 	100
		  0	 3 	 50
		  0	 5	 40
	]
	}
	
	sort/compare lines func [a b][a/3 < b/3]

	drw: clear []
	i: 0
	collect/into [
		forall lines [
			keep/only compose/deep [
				matrix [1 0 0 1 0 0] [
					pen silver circle 0x0 (lines/1/3) ;amplitude 
					pen blue rotate 0 0x0 [scale (lines/1/3) 1 line 0x0 1x0]
				]
				reset-matrix
			]
		]
	] drw
	dlt: 3
	dx: dlt + 1
	time: 0
	dt: 360.0 / length? points
	code: [
		draw: head face/draw
		x0: 300 y0: 300
		time: time + dt
		forall lines [
			set [phase freq amp] lines/1
			draw/1/2/5: x0 
			draw/1/2/6: y0
			ang: draw/1/3/9: (time * freq + phase - 90) 
			x0: x0 + (amp * cosine ang)
			y0: y0 + (amp * sine ang)
			draw: next draw
		]
		;poke can/image as-pair dx: dx + dlt y0 orange
		dr/draw/4/x: dr/draw/4/x + dlt
		insert at dr/draw 6 as-pair dx: dx - dlt y0
		if 500 < (dlt * length? dr/draw) [clear at dr/draw 500 / dlt]
		show face/parent
	]
	canvas: draw 600x600 [fill-pen white] 
	lay: layout/tight [
		;at 0x0 can: image 1000x600 canvas
		at 0x0 dr: box 1000x600 0.0.0.254 with [draw: copy [pen 0.0.0.128 translate 400x0 line]]
		bx: box 1000x600 0.0.0.254 with [
			draw: drw
			actors: object [
				on-time: func [face event] code
				on-down: func [face event][
					face/rate: either face/rate [none][30]
					show face
				]
			]
		]
		rate 30 
	]
	system/view/auto-sync?: off
	view lay
]
