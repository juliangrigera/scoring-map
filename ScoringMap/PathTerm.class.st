Class {
	#name : #PathTerm,
	#superclass : #Object,
	#instVars : [
		'node',
		'index'
	],
	#category : #'ScoringMap-BagOfPaths'
}

{ #category : #'instance creation' }
PathTerm class >> on: aDomNode index: anIndex [
	^ self new
		node: aDomNode;
		index: anIndex;
		yourself
]

{ #category : #accessing }
PathTerm >> index [
	^ index
]

{ #category : #accessing }
PathTerm >> index: anObject [
	index := anObject
]

{ #category : #accessing }
PathTerm >> label [
	^ self node label
]

{ #category : #accessing }
PathTerm >> node [
	^ node
]

{ #category : #accessing }
PathTerm >> node: anObject [
	node := anObject
]

{ #category : #accessing }
PathTerm >> predicate [
	^ EqualityPredicate index: self index
]

{ #category : #printing }
PathTerm >> printOn: aStream [
	aStream << self node label.
	aStream << '['.
	self index printOn: aStream.
	aStream << ']'
]
