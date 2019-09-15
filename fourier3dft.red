Red [
	Description: {Discrete Fourier Transform with complex nums}
	Needs: View
	Date: 13-Sep-2019
	Author: {Toomas Vooglaid}
]
context [
	#include %dftc.red
	
	points: load %f-points
	len: length? points
	
	max*: function [blk [block!]][m: 0 foreach b blk [m: max b m] m]
	half: (max* points) / 2
	forall points [points/1: points/1 - half]
	
	lines: dftc points
	sort/compare lines func [a b][a/3 < b/3]
	;clear at lines len / 2 ;experimental removal of high frequencies
		
	drw: clear []
	collect/into [
		forall lines [
			keep/only compose/deep [
				matrix [1 0 0 1 0 0] [
					pen 192.192.192.192 circle 0x0 (lines/1/3) ;amplitude
					pen 0.0.255.192 rotate 0 0x0 [line 0x0 (as-pair round lines/1/3 0)]
				]
				reset-matrix
			]
		]
	] drw
	
	time: 0
	dt: 360.0 / len
	
	code: [
		x0: 300 y0: 300
		time: time + dt
		draw: head face/draw
		;lines: head lines
		forall lines [
			set [phase freq amp] lines/1
			draw/1/2/5: x0 
			draw/1/2/6: y0
			ang: draw/1/3/9: (time * freq + phase)
			x0: x0 + (amp * cosine ang)
			y0: y0 + (amp * sine ang)
			draw: next draw
		]
		;poke can/image as-pair x0 y0 black
		insert at dr/draw 6 as-pair x0 y0
		show face/parent
	]
	;canvas: draw 600x600 [fill-pen white]
	lay: layout/tight compose [
		;at 0x0 can: image 600x600 canvas
		at 0x0 dr: box 600x600 white with [draw: copy [line-width 2 pen orange spline]]
		below
		bx: box 600x600 0.0.0.254 with [
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
