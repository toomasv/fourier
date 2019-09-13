Red [
	Description: "Discrete Fourier Transform"
	Date: 12-Sep-2019
	Author: "Toomas Vooglaid"
]
addc: func [c1 c2][ c2
	c1/1: c1/1 + c2/1
	c1/2: c1/2 + c2/2
]
multc: function [c1 c2][
	re: c1/1 * c2/1 - (c1/2 * c2/2)
	im: c1/1 * c2/2 + (c1/2 * c2/1)
	reduce [re im]
]
dftc: function [x][
	x: copy/deep x
	X*: make block! N*: length? x
	TWO_PI: 2 * pi
	repeat k N* [
		sum: copy [0 0]
		print ["k:" k]
		repeat n N* [
			phi: TWO_PI * (k - 1) * (n - 1) / N*
			c: reduce [cos phi negate sin phi]
			addc sum multc x/:n c
		]
		probe sum
		sum/1: sum/1 / N*
		sum/2: sum/2 / N*
		freq: k - 1
		amp: sqrt (sum/1 ** 2) + (sum/2 ** 2)
		phase: arctangent2 sum/2 sum/1
		append/only X* reduce [sum/1 sum/2 phase freq amp]
	]
	;foreach z X* [print z]
	X*
]