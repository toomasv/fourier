Red [
	Description: {Play-ground to study 2-dimensional Discrete Fourier Transform}
	Needs: View
	Date: 13-Sep-2019
	Author: {Toomas Vooglaid}
]
context [
	#include %dft.red

	max*: function [blk [block!]][m: 0 foreach b blk [m: max b m] m]
	min*: function [blk [block!]][m: blk/1 foreach b blk [m: min b m] m]

	points: load %f-points ;%logo-points ;

	mx: max* points
	mn: min* points

	px: collect [forall points [keep points/1/x - (mx/x - mn/x / 2)]]
	py: collect [forall points [keep points/1/y - (mx/y - mn/y / 2)]]

	linesx: dft px
	linesy: dft py

	comp: func [a b][a/3 < b/3]
	sort/compare linesx :comp
	sort/compare linesy :comp

	drw: clear []
	make-draw: func [lines [block!]][
		forall lines [
			append/only drw compose/deep [
				matrix [1 0 0 1 0 0] [
					pen silver circle 0x0 (lines/1/3) ;amplitude
					pen blue rotate 0 0x0 [line 0x0 (as-pair round lines/1/3 0)]
				]
				reset-matrix
			]
		]
	]
	make-draw linesx
	make-draw linesy
	append drw [
		pen pink 
		x-line: line 0x0 0x0 
		y-line: line 0x0 0x0
	]
	
	time: 0
	dt: 360.0 / length? points

	increment: func [lines [block!] x [integer! float!] y [integer! float!] /rotate][
		forall lines [
			set [phase freq amp] lines/1
			draw/1/2/5: x
			draw/1/2/6: y
			rot: pick [90 0] rotate
			ang: draw/1/3/9: time * freq + phase + rot
			x: x + (amp * cosine ang)
			y: y + (amp * sine ang)
			draw: next draw
		]
		reduce [x y]
	]
	code: [
		draw: head face/draw
		xx0: 600 xy0: 100
		yx0: 200 yy0: 500
		time: time + dt
		set [xx0 xy0] increment linesx xx0 xy0
		set [yx0 yy0] increment/rotate linesy yx0 yy0
		rxx0: round xx0
		ryy0: round yy0
		x-line/2: as-pair rxx0 round xy0 
		y-line/2: as-pair round yx0 ryy0 
		x-line/3: y-line/3: as-pair rxx0 ryy0
		;poke can/image as-pair round xx0 round yy0 black
		append dr/draw as-pair rxx0 ryy0
		show face/parent
	]

	;canvas: draw 1000x900 [fill-pen white] 
	system/view/auto-sync?: off
	lay: layout/tight [
		title "Red-logo"
		;at 0x0 can: image 1000x900 canvas
		; Change `spline` to `line` for strighter lines
		at 0x0 dr: box 1000x900 with [draw: copy [spline]]
		bx: box 1000x900 0.0.0.254 with [
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
	view lay
]