Class {
	#name : #EqualityPredicate,
	#superclass : #Predicate,
	#instVars : [
		'index'
	],
	#category : #'ScoringMap-BagOfPaths'
}

{ #category : #'instance creation' }
EqualityPredicate class >> index: anIndex [
	^ self new
		index: anIndex;
		yourself
]

{ #category : #comparing }
EqualityPredicate >> = aPredicate [
	^ super = aPredicate and: [ self index = aPredicate index ]
]

{ #category : #comparing }
EqualityPredicate >> hash [
	^ (self index hash + super hash) hash
]

{ #category : #accessing }
EqualityPredicate >> index [
	^ index
]

{ #category : #accessing }
EqualityPredicate >> index: anObject [
	index := anObject
]

{ #category : #testing }
EqualityPredicate >> isEqualityPredicate [
	^ true
]
