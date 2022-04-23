Class {
	#name : #GroupingStrategy,
	#superclass : #Object,
	#category : #ScoringMap
}

{ #category : #grouping }
GroupingStrategy >> addToGrouping: domElement [
	| candidateGroup |
	candidateGroup :=(self grouping
		"select: [ :group | group anyOne url host = domElement url host ]")
		detect: [ :group | self element: domElement belongsIn: group ]
		ifNone: [ OrderedCollection new ].
	candidateGroup ifEmpty: [ self grouping add: candidateGroup ].
	candidateGroup add: domElement
]

{ #category : #grouping }
GroupingStrategy >> element: domElement belongsIn: group [
	^ self subclassResponsibility
]

{ #category : #grouping }
GroupingStrategy >> grouping [
	^ self subclassResponsibility
]

{ #category : #grouping }
GroupingStrategy >> groupingFor: domElements [
	domElements do: [ :domElement | self addToGrouping: domElement ].
	^ self grouping
]
