Red []
dft: function [x][
	X*: make block! N*: length? x
	TWO_PI: 2 * pi
	repeat k N* [
		re: im: 0
		repeat n N* [
			phi: TWO_PI * (k - 1) * (n - 1) / N*
			re: re + (x/:n * cos phi)
			im: im - (x/:n * sin phi)
		]
		re: re / N*
		im: im / N*
		freq: k - 1
		amp: sqrt (re ** 2) + (im ** 2)
		phase: arctangent2 im re
		append/only X* reduce [re im phase freq amp]
	]
	;foreach z X* [print z]
	X*
]