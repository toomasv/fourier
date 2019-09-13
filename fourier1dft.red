Red [
	Description: {Play-ground to study Discrete Fourier Transform}
	Needs: View
	Date: 12-Sep-2019
	Author: {Toomas Vooglaid}
]
context [
	#include %dft.red
	ft: dft collect [repeat i 100 [keep i]]

	comment {
	collect [loop 36 [keep random 200]]
	[100 0 50 50 75 -23]
	[
	100 100 100 -100 -100 -100 
	100 100 100 -100 -100 -100 
	]
	lines: copy [
		;phase 	freq 	amp
		  0 	 1 	100
		  0	 3 	 50
		  0	 5	 40
	]
	}
	lines: collect [forall ft [keep reduce [ft/1/3 ft/1/4 ft/1/5]]]

	sort/skip/compare/all lines 3 func [a b][a/3 > b/3]

	drw: clear []
	i: 0
	collect/into [
		foreach [phase freq amp] lines [
			keep/only compose/deep [
				matrix [1 0 0 1 0 0] [
					pen silver circle 0x0 (amp) 
					pen blue rotate 0 0x0 [line 0x0 (as-pair round amp 0)]
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
			ang: draw/1/3/9: (time * freq + phase - 90) 
			x0: x0 + (amp * cosine ang)
			y0: y0 + (amp * sine ang)
			draw: next draw
		]
		;poke can/image as-pair dx: dx + dlt y0 black
		dr/draw/2/x: dr/draw/2/x + dlt
		insert at dr/draw 4 as-pair dx: dx - dlt y0
		if 400 < (dlt * length? dr/draw) [clear at dr/draw 400 / dlt]
		show face/parent
	]
	;canvas: draw 600x600 [fill-pen white] 
	lay: layout/tight [
		;at 0x0 can: image 1000x600 canvas
		at 0x0 dr: box 1000x600 white with [draw: copy [translate 400x0 line]]
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
