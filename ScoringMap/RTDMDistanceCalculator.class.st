"
RTDM Distance calculation.
Ported from Shriphani Palakodety's Clojure code at:
http://blog.shriphani.com/2013/12/03/tree-edit-distance-in-clojure/

Git Repository:
https://github.com/shriphani/tree-edit-distance
"
Class {
	#name : #RTDMDistanceCalculator,
	#superclass : #Object,
	#instVars : [
		'mapping'
	],
	#category : #'ScoringMap-RTDM'
}

{ #category : #'accessing - cost functions' }
RTDMDistanceCalculator >> deletionCost [
	^ 1
]

{ #category : #api }
RTDMDistanceCalculator >> distanceFrom: t1 to: t2 withThreshold: threshold [
	| m n ci cj deletionCost insertionCost substitutionCost |
	m := t1 childrenCount.
	n := t2 childrenCount.
	0 to: m do: [ :i | mapping at: i @ 0 put: 0 ].
	0 to: n do: [ :j | mapping at: 0 @ j put: 0 ].
	1 to: m do: [ :i | 
		1 to: n do: [ :j | 
			ci := (t1 subtreeAt: i) descendents.
			cj := (t2 subtreeAt: j) descendents.
			deletionCost := mapping at: (i - 1) @ j + (ci size * self deletionCost).
			insertionCost := mapping at: i @ (j - 1) + (cj size * self insertionCost).
			(mapping at: (i - 1) @ (j - 1)) > threshold
				ifTrue: [ substitutionCost := Float infinity ]
				ifFalse: [ 
					(t1 subtreeAt: i) = (t2 subtreeAt: j)
						ifTrue: [ substitutionCost := 0 ]
						ifFalse: [ 
							(t1 subtreeAt: i) isLeaf
								ifTrue: [ substitutionCost := self substitutionCost + (cj size * self insertionCost) ]
								ifFalse: [ 
									(t2 subtreeAt: j) isLeaf
										ifTrue: [ substitutionCost := self substitutionCost + (ci size * self deletionCost) ]
										ifFalse: [ substitutionCost := self distanceFrom: (t1 subtreeAt: i) to: (t2 subtreeAt: j) withThreshold: threshold ] ] ] ].
			mapping
				at: i @ j
				put: {substitutionCost . deletionCost .	insertionCost} min ] ].
	^ mapping at: m @ n
]

{ #category : #'clojure port' }
RTDMDistanceCalculator >> editDistanceFrom: t1 to: t2 [
	(t1 isLeaf & t2 isLeaf and: [ t1 label ~= t2 label ])
		ifTrue: [ ^ 0 ].
	^ (1 - ((self from: t1 to: t2) / (t1 descendents size + t2 descendents size + 2))) asFloat
]

{ #category : #'clojure port' }
RTDMDistanceCalculator >> from: t1 to: t2 [
	| m n t1Children t2Children t1Desc t2Desc map |
	
	m := t1 childrenCount.
	n := t2 childrenCount.
	t1Children := t1 children.
	t2Children := t2 children.
	t1Desc := t1 descendents.
	t2Desc := t2 descendents.
	map := Dictionary new.
	self init: map m: m n: n c1: t1Desc size c2: t2Desc size.
	
	1 to: m do: [ :i | 1 to: n do: [ :j | 
			|ci cj ciDesc cjDesc del ins subi sub|
			ci := t1Children at: i .
			cj := t2Children at: j .
			ciDesc := ci descendents.
			cjDesc := cj descendents.
			
			del := map at: (i@(j+1)).
			ins := map at: ((i+1)@j).
			
			subi := ( (map at: ( i@j )) - self deletionCost - self insertionCost  ).
			(ci = cj) 
				ifTrue:[
					sub:=(subi - 
								(self insertionCost * (cjDesc size)) -  
								(self deletionCost * (ciDesc size)))
      				]
				ifFalse:[
					( ci hasChildren not or: [ cj hasChildren not ] ) ifTrue: [ 
						sub := subi + self substitutionCost ] ifFalse: [
					
					( ci label = cj label ) ifTrue: [ 
						sub := subi - (self invertCost: ci and: cj) ] ifFalse: [ 
					
					sub := subi + self substitutionCost.
					]]
					].
			map at: ((i+1)@(j+1)) put: {del . ins . sub} min.
			 ]].
	^map at: (m+1)@(n+1)
]

{ #category : #'clojure port' }
RTDMDistanceCalculator >> init: map m: m n: n c1: c1 c2: c2 [
	1 to: m + 1 do: [ :i | 
		1 to: n + 1 do: [ :j |
			 map 
				at: i @ j 
				put: (c1 * self deletionCost) + (c2 * self insertionCost) ] ].
	^ map
]

{ #category : #initialization }
RTDMDistanceCalculator >> initialize [
	super initialize.
	mapping := Dictionary new
]

{ #category : #'accessing - cost functions' }
RTDMDistanceCalculator >> insertionCost [
	^ 1
]

{ #category : #'clojure port' }
RTDMDistanceCalculator >> invertCost: t1 and: t2 [
	| t1Desc t2Desc |
	t1Desc := t1 descendents.
	t2Desc := t2 descendents.
	^ self deletionCost * t1Desc size + (self insertionCost * t2Desc size) - (self from: t1 to: t2)
]

{ #category : #'clojure port' }
RTDMDistanceCalculator >> similitudeRateBetween: t1 and: t2 [
	(t1 isLeaf & t2 isLeaf and: [ t1 label ~= t2 label ])
		ifTrue: [ ^ 0 ].
	^ (1 - ((self from: t1 to: t2) / (t1 descendents size + t2 descendents size + 2))) asFloat
]

{ #category : #'accessing - cost functions' }
RTDMDistanceCalculator >> substitutionCost [
	^ 1
]
