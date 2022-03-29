Class {
	#name : #GeneralizedPredicate,
	#superclass : #Predicate,
	#instVars : [
		'block'
	],
	#category : #'ScoringMap-BagOfPaths'
}

{ #category : #'instance creation' }
GeneralizedPredicate class >> block: aBlock [
	^ self new
		block: aBlock;
		yourself
]

{ #category : #comparing }
GeneralizedPredicate >> = aPredicate [
	^ super = aPredicate and: [ self block = aPredicate block ]
]

{ #category : #accessing }
GeneralizedPredicate >> block [
	^ block
]

{ #category : #accessing }
GeneralizedPredicate >> block: anObject [
	block := anObject
]

{ #category : #testing }
GeneralizedPredicate >> evaluate: aTerm [
	^ self block value: aTerm
]

{ #category : #comparing }
GeneralizedPredicate >> hash [
	^ (self block hash + super hash) hash
]
