Class {
	#name : #RepetitiveTerm,
	#superclass : #PathTerm,
	#instVars : [
		'init',
		'diff'
	],
	#category : #'ScoringMap-BagOfPaths'
}

{ #category : #'instance creation' }
RepetitiveTerm class >> on: aNode init: initValue diff: diffValue [
	^ self new
		node: aNode;
		init: initValue;
		diff: diffValue;
		yourself
]

{ #category : #accessing }
RepetitiveTerm >> diff [
	^ diff
]

{ #category : #accessing }
RepetitiveTerm >> diff: anObject [
	diff := anObject
]

{ #category : #accessing }
RepetitiveTerm >> init [
	^ init
]

{ #category : #accessing }
RepetitiveTerm >> init: anObject [
	init := anObject
]

{ #category : #accessing }
RepetitiveTerm >> predicate [
	^ GeneralizedPredicate block: [ :term | ((term index - self init) \\ self diff) isZero ]
]

{ #category : #printing }
RepetitiveTerm >> printOn: aStream [
	aStream << self node label.
	aStream << '[ (position() - '.
	self init printOn: aStream.
	aStream << ') mod '.
	self diff printOn: aStream.
	aStream << ') = 0]'
]
