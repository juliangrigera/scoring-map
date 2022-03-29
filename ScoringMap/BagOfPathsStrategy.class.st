Class {
	#name : #BagOfPathsStrategy,
	#superclass : #RTDMStrategy,
	#category : #'ScoringMap-BagOfPaths'
}

{ #category : #grouping }
BagOfPathsStrategy >> _groupingFor: domElements [
	| adapters |
	adapters := domElements
		collect: [ :rawElement | DomNodeAdapter on: rawElement tree withoutStringNodes ].
	adapters do: [ :adapter | self addToGrouping: adapter ].
	^ self grouping collect: [ :group | group collect: [ :adapted | adapted tree ] ]
]

{ #category : #grouping }
BagOfPathsStrategy >> _similitudeRateBetween: tree1 and: tree2 [
	^ tree1 bagOfPathsSimilarityWith: tree2
]

{ #category : #grouping }
BagOfPathsStrategy >> addToGrouping: adaptedElement [
	| candidateGroup |
	candidateGroup := (self grouping
		select: [ :group | group anyOne url host = adaptedElement url host ])
		detect: [ :group | self element: adaptedElement belongsIn: group ]
		ifNone: [ OrderedCollection new ].
	candidateGroup ifEmpty: [ self grouping add: candidateGroup ].
	candidateGroup add: adaptedElement
]

{ #category : #grouping }
BagOfPathsStrategy >> element: adaptedElement belongsIn: group [
	^ group anySatisfy: [ :groupElement | (self similitudeRateBetween: adaptedElement and: groupElement) > self threshold ]
]

{ #category : #grouping }
BagOfPathsStrategy >> groupingFor: domElements [
	domElements do: [ :domElement | self addToGrouping: domElement ].
	^ self grouping
]

{ #category : #initialization }
BagOfPathsStrategy >> initialize [
	super initialize.
	adapters := OrderedCollection new
]

{ #category : #grouping }
BagOfPathsStrategy >> similitudeRateBetween: domElement and: groupElement [
	| tree1 tree2 |
	tree1 := DomNodeAdapter on: groupElement tree withoutStringNodes.
	tree2 := DomNodeAdapter on: domElement tree withoutStringNodes.
	^ tree1 bagOfPathsSimilarityWith: tree2
]

{ #category : #configuration }
BagOfPathsStrategy >> threshold [
	^ 0.6
]
