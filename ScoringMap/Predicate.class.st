Class {
	#name : #Predicate,
	#superclass : #Object,
	#category : #'ScoringMap-BagOfPaths'
}

{ #category : #comparing }
Predicate >> = aPredicate [
	^ self class = aPredicate class
]

{ #category : #comparing }
Predicate >> hash [
	^ self class hash
]

{ #category : #testing }
Predicate >> isEqualityPredicate [
	^ false
]
