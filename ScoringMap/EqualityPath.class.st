Class {
	#name : #EqualityPath,
	#superclass : #AbstractXPath,
	#category : #'ScoringMap-BagOfPaths'
}

{ #category : #operations }
EqualityPath >> generalizeWith: anotherPath [
	| x1 x2 gxPath |
	gxPath := GeneralizedPath new.
	x1 := self.
	x2 := anotherPath.
	x1 depth = x2 depth
		ifFalse: [ ^ nil ].
	1 to: x1 terms size do: [ :t | 
		| termt1 termt2 |
		termt1 := x1 termAt: t.
		termt2 := x2 termAt: t.
		termt1 label = termt2 label
			ifFalse: [ ^ nil ].
		termt1 index = termt2 index
			ifTrue: [ gxPath addTerm: termt1 ]
			ifFalse: [ | diff init |
				diff := (termt1 index - termt2 index) abs.
				init := termt1 index \\ diff.
				gxPath addTerm: (RepetitiveTerm on: termt1 node init: init diff: diff) ] ].
	^ gxPath
]
