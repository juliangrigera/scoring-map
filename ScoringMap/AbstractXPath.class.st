Class {
	#name : #AbstractXPath,
	#superclass : #Object,
	#instVars : [
		'terms'
	],
	#category : #'ScoringMap-BagOfPaths'
}

{ #category : #'instance creation' }
AbstractXPath class >> withTerms: termsCollection [
	^ self new
		terms: termsCollection;
		yourself
]

{ #category : #comparing }
AbstractXPath >> = aPath [
	^ self printString = aPath printString
]

{ #category : #accessing }
AbstractXPath >> addTerm: aPathTerm [
	self terms add: aPathTerm
]

{ #category : #accessing }
AbstractXPath >> depth [
	^ self terms size
]

{ #category : #testing }
AbstractXPath >> hasMoreThanOneGeneralizedPredicates [
	^ (self terms count: [ :term | term predicate isEqualityPredicate not ]) > 1
]

{ #category : #testing }
AbstractXPath >> hasNoGeneralizedPredicates [
	^ self terms allSatisfy: [ :term | term predicate isEqualityPredicate ]
]

{ #category : #comparing }
AbstractXPath >> hash [
	^ self printString hash
]

{ #category : #initialization }
AbstractXPath >> initialize [
	super initialize.
	terms := OrderedCollection new
]

{ #category : #printing }
AbstractXPath >> printOn: aStream [
	self terms do: [ :term | term printOn: aStream ] separatedBy: [ aStream << '/' ]
]

{ #category : #operations }
AbstractXPath >> subsumes: x2 [
	"Awful var names applied to match the paper's algorithm"

	| x1 flag |
	x1 := self.
	x1 depth ~= x2 depth
		ifTrue: [ ^ false ].
	flag := true.
	1 to: x1 terms size do: [ :t | 
		| termt1 termt2 |
		termt1 := x1 termAt: t.
		termt2 := x2 termAt: t.
		termt1 label ~= termt2 label
			ifTrue: [ ^ false ].
		termt1 predicate = termt2 predicate
			ifFalse: [ | p |
				p := termt1 predicate.
				(p isEqualityPredicate or: [ termt2 predicate isEqualityPredicate not ])
					ifTrue: [ ^ false ]
					ifFalse: [ flag := flag and: [ p evaluate: termt2 ] ] ] ].
	^ flag
]

{ #category : #accessing }
AbstractXPath >> termAt: index [
	^ self terms at: index
]

{ #category : #accessing }
AbstractXPath >> terms [
	^ terms
]

{ #category : #accessing }
AbstractXPath >> terms: anObject [
	terms := anObject
]

{ #category : #accessing }
AbstractXPath >> treePath [
	^ String
		streamContents:
			[ :stream | self terms do: [ :term | stream << term label ] separatedBy: [ stream << '/' ] ]
]
