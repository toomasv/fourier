Red [
	Description: "Discrete Fourier Transform with complex numbers"
	Date: 12-Sep-2019
	File: %dftc.red
	Author: "Toomas Vooglaid"
]

;add complex numbers
addc: func [c1 c2][ 
	c1/1: c1/1 + c2/1
	c1/2: c1/2 + c2/2
]

;multiply complex numbers
multc: function [c1 c2][ 
	re: c1/1 * c2/1 - (c1/2 * c2/2)
	im: c1/1 * c2/2 + (c1/2 * c2/1)
	reduce [re im]
]

;DFT for complex numbers
dftc: function [points][
	X*: make block! N*: length? points
	;convert to complex if pairs
	if pair? points/1 [
		forall points [
			points/1: reduce [points/1/x points/1/y]
		]
	]
	TWO_PI: 2 * pi
	repeat k N* [; fore each frequency
		sum: copy [0 0]
		repeat n N* [; for each point
			;unit-angle: period's fraction at this point times frequency
			phi: TWO_PI * (freq: k - 1) * (n - 1) / N*
			;		  real and   imaginary parts
			c: reduce [cos phi   negate sin phi]
			;multiply point's value with unit angle at this point and..
			;sum results for this frequency 
			addc sum multc points/:n c
		]
		;average sum for this frequency
		sum/1: sum/1 / N*
		sum/2: sum/2 / N*
		amp: sqrt (sum/1 ** 2) + (sum/2 ** 2)
		;					im    re
		phase: arctangent2 sum/2 sum/1
		;if amp >= 0.1 [ ;experimental filtering out short amplitudes
			append/only X* reduce [phase freq amp]
		;]
	]
	;foreach z X* [print z]
	X*
]