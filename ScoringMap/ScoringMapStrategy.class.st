Class {
	#name : #ScoringMapStrategy,
	#superclass : #GroupingStrategy,
	#instVars : [
		'grouping'
	],
	#category : #ScoringMap
}

{ #category : #grouping }
ScoringMapStrategy >> addToGrouping: domElement [
	| candidateGroup |
	candidateGroup := (self grouping
		"select: [ :group | group anyOne url host = domElement url host ]")
		detect: [ :group | self element: domElement belongsIn: group ]
		ifNone: [ OrderedCollection new ].
	candidateGroup ifEmpty: [ self grouping add: candidateGroup ].
	candidateGroup add: domElement
]

{ #category : #grouping }
ScoringMapStrategy >> element: domElement belongsIn: group [
	^ group
		anySatisfy:
			[ :groupElement | (self similitudeRateBetween: domElement and: groupElement) > self threshold ]
]

{ #category : #accessing }
ScoringMapStrategy >> grouping [
	^ grouping
]

{ #category : #grouping }
ScoringMapStrategy >> groupingFor: domElements [
	domElements do: [ :domElement | self addToGrouping: domElement ].
	^ self grouping
]

{ #category : #initialization }
ScoringMapStrategy >> initialize [
	super initialize.
	grouping := OrderedCollection new
]

{ #category : #grouping }
ScoringMapStrategy >> similitudeRateBetween: domElement and: groupElement [
	^ groupElement treeMapSimilitudeRateWith: domElement
]

{ #category : #configuration }
ScoringMapStrategy >> threshold [
	^ 0.89
]
