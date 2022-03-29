"
""A nilsimsa code is something like a hash, but unlike hashes, a small change in the message results in a small change in the nilsimsa code. Such a function is called a locality-sensitive hash. ""
http://ixazon.dynip.com/~cmeclax/nilsimsa.html

Ported from Python version
https://code.google.com/p/py-nilsimsa/

Create digests with:
	(Nilsimsa new: 'any string') hexDigest 

Compare digests with the class method #compareDigest:with:

See api for more uses
	
"
Class {
	#name : #Nilsimsa,
	#superclass : #Object,
	#instVars : [
		'complete',
		'numChar',
		'accumulator',
		'window',
		'tran',
		'digest',
		'popc'
	],
	#category : #ScoringMap
}

{ #category : #tools }
Nilsimsa class >> compareDigest: anHexDigest with: otherHexDigest [
	| bits popc |
	popc := self new popc.
	bits := 0.
	1 to: 64 by: 2 do: [ :index | 
		| intValue otherIntValue |
		intValue := (ByteArray readHexFrom: (anHexDigest copyFrom: index to: index + 1)) first.
		otherIntValue := (ByteArray readHexFrom: (otherHexDigest copyFrom: index to: index + 1)) first.
		bits := bits + (popc at: 1 + (255 bitAnd: (intValue bitXor: otherIntValue))) ].
	^ 128 - bits
]

{ #category : #'instance creation' }
Nilsimsa class >> new: aString [
	"Answer a newly created and initialized instance."

	^(self new)
		data: aString;
		yourself
]

{ #category : #accessing }
Nilsimsa >> accumulator [

	^accumulator
]

{ #category : #private }
Nilsimsa >> accumulator: anObject [

	accumulator := anObject
]

{ #category : #api }
Nilsimsa >> compareHexDigestWith: otherHexDigest [

	| hexDigest bits |
	hexDigest := self hexDigest.
	bits := 0.
	1 to: 64 by: 2
		do: 
			[:index |
			| intValue otherIntValue |
			intValue := (ByteArray fromHexString: (hexDigest copyFrom: index to: index + 1)) first.
			otherIntValue := (ByteArray fromHexString: (otherHexDigest copyFrom: index to: index + 1)) first.
			bits := bits + (popc at: 1 + (255 bitAnd: (intValue bitXor: otherIntValue)))
			].
	^128 - bits
]

{ #category : #api }
Nilsimsa >> compareWith: otherNilsimsa [
	^ self compareHexDigestWith: otherNilsimsa hexDigest
]

{ #category : #accessing }
Nilsimsa >> complete [

	^complete
]

{ #category : #private }
Nilsimsa >> complete: anObject [

	complete := anObject
]

{ #category : #hashing }
Nilsimsa >> computeDigest [
	|trigramsCount threshold |
	trigramsCount := 0.
	(self numChar = 3)
		ifTrue: [ trigramsCount := 1 ].
	(self numChar = 4)
		ifTrue: [ trigramsCount := 4 ].
	(self numChar > 4)
		ifTrue: [ trigramsCount := 8 * self numChar - 28 ].
		
	threshold := trigramsCount / 256.
	
	0 to: 255 do: [ :index | 
		(self accumulator at: 1+ index) > threshold 
			ifTrue: [ digest at: 1+ (index bitShift: -3 ) put: ((digest at: 1+ (index bitShift: -3 )) + ( 1 bitShift: (index bitAnd: 7)  ) )  ]  ].
		
	self complete: true.
	digest := digest reversed.
]

{ #category : #accessing }
Nilsimsa >> data: aString [

	self process: aString
]

{ #category : #api }
Nilsimsa >> digest [
	self complete
		ifFalse: [ self computeDigest ].
	^ digest
]

{ #category : #api }
Nilsimsa >> hexDigest [
	^ self digest asByteArray hex
]

{ #category : #hashing }
Nilsimsa >> incrementAccumulatorAt: zeroBasedIndex [

	| index |
	index := zeroBasedIndex + 1.
	self accumulator at: index put: (self accumulator at: index) + 1
]

{ #category : #hashing }
Nilsimsa >> incrementNumChar [

	self numChar: self numChar + 1
]

{ #category : #'initialize-release' }
Nilsimsa >> initialize [

	super initialize.
	complete := false.
	numChar := 0.
	accumulator := Array new: 256 withAll: 0.
	window :=OrderedCollection new.
	digest := Array new: 32 withAll: 0.
	tran := #(2 214 158 111 249 29 4 171 208 34 22 31 216 115 161 172 59 112 98 150 30 110 143 57 157 5 20 74 166 190 174 14 207 185 156 154 199 104 19 225 45 164 235 81 141 100 107 80 35 128 3 65 236 187 113 204 122 134 127 152 242 54 94 238 142 206 79 184 50 182 95 89 220 27 49 76 123 240 99 1 108 186 7 232 18 119 73 60 218 70 254 47 121 28 155 48 227 0 6 126 46 15 56 51 33 173 165 84 202 167 41 252 90 71 105 125 197 149 181 244 11 144 163 129 109 37 85 53 245 117 116 10 38 191 25 92 26 198 255 153 93 132 170 102 62 175 120 179 32 67 193 237 36 234 230 63 24 243 160 66 87 8 83 96 195 192 131 64 130 215 9 189 68 42 103 168 147 224 194 86 159 217 221 133 21 180 138 39 40 146 118 222 239 248 178 183 201 61 69 148 75 17 13 101 213 52 139 145 12 250 135 233 124 91 177 77 229 212 203 16 162 23 137 188 219 176 226 151 136 82 247 72 211 97 44 58 43 209 140 251 241 205 228 106 231 169 253 196 55 200 210 246 223 88 114 78).
	popc := #(0 1 1 2 1 2 2 3 1 2 2 3 2 3 3 4 1 2 2 3 2 3 3 4 2 3 3 4 3 4 4 5 1 2 2 3 2 3 3 4 2 3 3 4 3 4 4 5 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 1 2 2 3 2 3 3 4 2 3 3 4 3 4 4 5 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 3 4 4 5 4 5 5 6 4 5 5 6 5 6 6 7 1 2 2 3 2 3 3 4 2 3 3 4 3 4 4 5 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 3 4 4 5 4 5 5 6 4 5 5 6 5 6 6 7 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 3 4 4 5 4 5 5 6 4 5 5 6 5 6 6 7 3 4 4 5 4 5 5 6 4 5 5 6 5 6 6 7 4 5 5 6 5 6 6 7 5 6 6 7 6 7 7 8).
]

{ #category : #accessing }
Nilsimsa >> numChar [

	^numChar
]

{ #category : #private }
Nilsimsa >> numChar: anObject [

	numChar := anObject
]

{ #category : #accessing }
Nilsimsa >> popc [

	^popc
]

{ #category : #hashing }
Nilsimsa >> process: chunk [

	| c |
	chunk do: 
			[:char |
			self incrementNumChar.
			c := char asUnicode.
			self window size > 1
				ifTrue: [self incrementAccumulatorAt: (self tran53HashA: c b: self window first c: self window second n: 0)].
			self window size > 2
				ifTrue: [
					self incrementAccumulatorAt: (self tran53HashA: c b: self window first c: (self window third) n: 1).
					self incrementAccumulatorAt: (self tran53HashA: c b: self window second c: (self window third) n: 2)
					].
			self window size > 3
				ifTrue: [
					self incrementAccumulatorAt: (self tran53HashA: c b: self window first c: self window fourth n: 3).
					self incrementAccumulatorAt: (self tran53HashA: c b: self window second c: self window fourth n: 4).
					self incrementAccumulatorAt: (self tran53HashA: c b: self window third c: self window fourth n: 5).
					self incrementAccumulatorAt: (self tran53HashA:  self window fourth b: self window first c: c n: 6).
					self incrementAccumulatorAt: (self tran53HashA:  self window fourth b: self window third c: c n: 7).
					].
			self window addFirst: c.
			self window size >= 4
				ifTrue: [ self window: (self window first: 4) ]
			]
]

{ #category : #constants }
Nilsimsa >> tran [

	^tran
]

{ #category : #hashing }
Nilsimsa >> tran53HashA: a b: b c: c n: n [
	"Python original: (((TRAN[(a+n)&255]^TRAN[b]*(n+n+1))+TRAN[(c)^TRAN[n]])&255)"
	"Adjusted for zero-based array compatibility with original source."

	^((tran at: 1 + (a + n bitAnd: 255))
		bitXor: (tran at: ((1 + b) min:256)) * (n + n + 1))
			+ (tran at: ((1 + (c bitXor: (tran at: 1 + n))) min: 256)) bitAnd: 255
]

{ #category : #accessing }
Nilsimsa >> window [

	^window
]

{ #category : #private }
Nilsimsa >> window: anObject [

	window := anObject
]
