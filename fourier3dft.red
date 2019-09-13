Red [
	Description: {Discrete Fourier Transform with complex nums}
	Needs: View
	Date: 13-Sep-2019
	Author: {Toomas Vooglaid}
]
context [
	#include %dftc.red
	
	points: load %f-points

	max*: function [blk [block!]][m: 0 foreach b blk [m: max b m] m]
	half: (max* points) / 2
	forall points [points/1: points/1 - half]
	
	dft-points: copy []
	collect/into [
		forall points [
			keep/only reduce [points/1/x points/1/y]
		]
	] clear dft-points

	ft: dftc dft-points

	lines: collect [forall ft [keep reduce [ft/1/3 ft/1/4 ft/1/5]]]

	sort/skip/compare/all lines 3 func [a b][a/3 > b/3]
	
	drw: clear []
	i: 0
	collect/into [
		foreach [_ _ amp] lines [
			keep/only compose/deep [
				matrix [1 0 0 1 0 0] [
					pen 192.192.192.192 circle 0x0 (amp) 
					pen 0.0.255.192 rotate 0 0x0 [line 0x0 (as-pair round amp 0)]
				]
				reset-matrix
			]
		]
	] drw
	dlt: 2
	dx: dlt + 1
	time: 0
	dt: 360.0 / length? ft
	code: [
		draw: head face/draw
		x0: 300 y0: 300
		time: time + dt
		foreach [phase freq amp] lines [
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
