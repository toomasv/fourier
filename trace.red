Red [
	Description: {For collecting points from picture}
	File: %trace.red
	Needs: 'View
	Date: 17-Sep-2019
	Author: "Toomas Vooglaid"
]
context [
	file: none;%gregg.png
	;pic: load file;%gregg.png ;%coffee.png;%world.png 
	pic: draw 200x200 [fill-pen white]
	ofs: none
	circ: ['circle new 2]
	op: op2: none
	
	zooming: function [face event][
		mx: face/draw/matrix 
		ev: event/offset
		self/op:  get pick [/ *] 0 > event/picked 
		self/op2: get pick [* /] 0 > event/picked 
		face/draw/matrix: reduce [
			sc: mx/1 op 1.1 0 0 sc 
			mx/5 - ev/x op 1.1 + ev/x
			mx/6 - ev/y op 1.1 + ev/y
		]
		lw: find/tail lines/draw 'line-width
		;lw/1: lw/1 op2 1.02
		self/circ/3: circ/3 op2 1.005
		;points/draw: points/draw
	]
	
	moving: function [event][
		df: event/offset - ofs 
		lines/draw/matrix/5: points/draw/matrix/5: img/draw/matrix/5: img/draw/matrix/5 + df/x
		lines/draw/matrix/6: points/draw/matrix/6: img/draw/matrix/6: img/draw/matrix/6 + df/y
		self/ofs: event/offset
		img/draw: img/draw
		points/draw: points/draw
		lines/draw: lines/draw
	]
	
	fc-point: function [face event][
		mx: face/draw/matrix
		as-pair round event/offset/x - mx/5 / mx/1
				round event/offset/y - mx/6 / mx/1
	]
	
	view/tight/flags [
		on-resizing [img/size: points/size: lines/size: face/size]
		img: box all-over draw [
			matrix [1 0 0 1 0 0] image pic 0x0
		] with [
			menu: [
				;"Run" run 
				"Load" load 
				"Save" save 
				"Show" ["Points" show-points "Lines" show-lines] 
				"Hide" ["Points" hide-points "Lines" hide-lines] 
				"Probe" probe
			]
			size: pic/size 
			actors: object [
				on-mid-down: func [face event][
					ofs: event/offset
				]
				on-down: func [face event][
					new: fc-point face event
					append points/draw reduce bind circ :on-down 
					append lines/draw new 
				]
				on-over: func [face event][
					if event/mid-down? [
						moving event
					]
				]
				on-wheel: func [face event][
					zooming face event
					zooming points event
					zooming lines event
				]
				on-menu: func [face event][
					switch event/picked [
						;run [probe find/tail lines/draw 'spline]
						load [
							if file: request-file [
								pic: load file
								event/window/size: pic/size
								foreach-face event/window [
									face/size: pic/size
									face/draw/matrix: copy [1 0 0 1 0 0]
								]
								clear at lines/draw 10
								clear at points/draw 7
								if attempt [pnts: load points-file: first split file dot][
									append lines/draw pnts
									foreach pnt pnts [
										append points/draw reduce ['circle pnt 2]
									]
								]
								show face/parent
							]
						]
						save [write points-file find/tail lines/draw 'spline]
						show-points [points/visible?: yes]
						show-lines [lines/visible?: yes]
						hide-points [points/visible?: no]
						hide-lines [lines/visible?: no]
						probe [probe points/draw]
					]
				]
			]
		]
		at 0x0 lines: box draw [
			matrix [1 0 0 1 0 0]
			line-width 1 pen pink fill-pen off spline		
		] with [
			menu: ["Insert" ins "Hide" hide "Probe" probe]
			size: img/size
			actors: object [
				on-menu: func [face event][
					switch event/picked [
						ins [
							point: fc-point face event
							parse face/draw [
								any [s:
									pair! if (all [
										1 < length? s 
										mn: min s/1 s/2
										mx: max s/1 s/2
										within? point mn - (5 op2 sc: face/draw/matrix/1) mx - mn + (10 op2 sc)
									]) (
										insert back find points/draw s/2 reduce ['circle point 2]
										insert next s point
									) thru end
								|	skip
								]
							]
						]
						hide [face/visible?: no show face]
						probe [probe face/draw]
					]
				]
			]
		]
		at 0x0 points: box all-over draw [
			matrix [1 0 0 1 0 0]
			pen off fill-pen cyan
		] with [
			menu: ["Delete" del "Hide" hide "Probe" probe]
			size: img/size
			actors: object [
				pt: none
				pts: clear []
				on-down: func [face event][
					ofs: event/offset
					pts: clear []
					point: fc-point face event
					parse face/draw [
						any [s: 
							pair! if (within? point s/1 - 2 4x4)(
								pt: yes 
								append/only pts s 
								append/only pts find lines/draw s/1
							) thru end
						| 	skip
						]
					]
				]
				on-up: func [face event][pt: none]
				on-over: func [face event][
					if all [event/down? pt] [
						point: fc-point face event
						forall pts [pts/1/1: point]
						;face/draw: face/draw
					]
				]
				on-menu: func [face event][
					switch event/picked [
						del [
							point: fc-point face event
							parse face/draw [
								any [s: 
									pair! if (within? point s/1 - 1 2x2) (
										remove find lines/draw s/1
										remove/part back s 3
									) thru end
								| 	skip
								]
							]
						]
						hide [face/visible?: no show face]
						probe [probe points/draw]
					]
				]
			]
		]
	] 'resize
]
