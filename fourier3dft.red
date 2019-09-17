Red [
	Description: {Discrete Fourier Transform with complex nums}
	Needs: View
	Date: 13-Sep-2019
	Author: {Toomas Vooglaid}
]
context [
	#include %dftc.red
	
	;points: either file? file: system/script/args [
	;	load file
	;][
	;	load %wrl;%f-points
	;]
	points: load %wrl ;%f-points ;
	len: length? points
	
	max*: function [blk [block!]][m: 0 foreach b blk [m: max b m] m]
	half: (max* points) / 2
	forall points [points/1: points/1 - half]
	
	lines: dftc points
	sort/compare lines func [a b][a/3 < b/3]
	;clear at lines len / 2 ;experimental removal of short amplitudes

	ofs: none
	zooming: function [face event][
		mx: face/draw/matrix 
		ev: event/offset
		op: get pick [/ *] 0 > event/picked 
		op2: get pick [* /] 0 > event/picked 
		face/draw/matrix: reduce [
			sc: mx/1 op 1.1 0 0 sc 
			mx/5 - ev/x op 1.1 + ev/x
			mx/6 - ev/y op 1.1 + ev/y
		]
		face/draw/4: face/draw/4 op2 1.1
		dr/draw/4: dr/draw/4 op2 1.1
	]
	moving: function [face event][
		df: event/offset - ofs 
		dr/draw/matrix/5: face/draw/matrix/5: face/draw/matrix/5 + df/x
		dr/draw/matrix/6: face/draw/matrix/6: face/draw/matrix/6 + df/y
		self/ofs: event/offset
		face/draw: face/draw
		dr/draw: dr/draw
	]
		
	drw: copy [matrix [1 0 0 1 0 0] line-width 1]
	append/only drw collect [
		forall lines [
			keep/only compose/deep [
				matrix [1 0 0 1 0 0] [
					pen 192.192.192.192 circle 0x0 (lines/1/3) ;amplitude
					pen 0.0.255.192 rotate 0 0x0 [line 0x0 (as-pair round lines/1/3 0)]
				]
			]
		]
	] 
	
	time: 0
	dt: 360.0 / len
	rt: 30 
	code: [
		x1: x0: 300 y1: y0: 300 
		time: time + dt
		draw: head face/draw/5
		forall lines [
			set [phase freq amp] lines/1
			draw/1/2/5: x0 
			draw/1/2/6: y0
			ang: draw/1/3/9: (time * freq + phase)
			x1: x1 + x0: amp * cosine ang 
			y1: y1 + y0: amp * sine ang 
			draw: next draw
		]
		;poke can/image as-pair x0 y0 black  ;for dotty figure
		insert at dr/draw 8 as-pair x1 y1
		show face/parent
	]
	;canvas: draw 600x600 [fill-pen white]  ;for dotty figure
	lay: layout/tight compose [
		;at 0x0 can: image 600x600 canvas  ;for dotty figure
		at 0x0 dr: box 600x600 white with [
			draw: copy [matrix [1 0 0 1 0 0] line-width 2 pen orange spline]
		]
		bx: box 600x600 0.0.0.254 all-over with [
			draw: drw
			actors: object [
				on-time: func [face event] code
				on-down: func [face event][
					face/rate: either face/rate [rt: face/rate none][rt]
					show face
				]
				on-wheel: func [face event][either event/ctrl? [
					face/rate: max 1 face/rate + to-integer event/picked
				][zooming face event zooming dr event show parent]]
				on-alt-down: func [face event][ofs: event/offset]
				on-over: func [face event][if event/alt-down? [moving face event show face/parent]]
			]
		]
		rate 20 
	]
	system/view/auto-sync?: off
	view lay
]
