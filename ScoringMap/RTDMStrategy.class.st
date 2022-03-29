Class {
	#name : #RTDMStrategy,
	#superclass : #GroupingStrategy,
	#instVars : [
		'grouping'
	],
	#category : #'ScoringMap-RTDM'
}

{ #category : #grouping }
RTDMStrategy >> addToGrouping: domElement [
	| candidateGroup |
	candidateGroup := (self grouping
		"select: [ :group | group anyOne url host = domElement url host ]")
		detect: [ :group | self element: domElement belongsIn: group ]
		ifNone: [ OrderedCollection new ].
	candidateGroup ifEmpty: [ self grouping add: candidateGroup ].
	candidateGroup add: domElement
]

{ #category : #grouping }
RTDMStrategy >> element: domElement belongsIn: group [
	^ group anySatisfy: [ :groupElement | (self similitudeRateBetween: domElement and: groupElement) > self threshold ]
]

{ #category : #accessing }
RTDMStrategy >> grouping [
	^ grouping
]

{ #category : #grouping }
RTDMStrategy >> groupingFor: domElements [
	domElements do: [ :domElement | self addToGrouping: domElement ].
	^ self grouping
]

{ #category : #initialization }
RTDMStrategy >> initialize [
	super initialize.
	grouping := OrderedCollection new
]

{ #category : #grouping }
RTDMStrategy >> similitudeRateBetween: domElement and: groupElement [
	| tree1 tree2 |
	tree1 := DomNodeAdapter on: groupElement tree withoutStringNodes.
	tree2 := DomNodeAdapter on: domElement tree withoutStringNodes.
	^ RTDMDistanceCalculator new similitudeRateBetween: tree1 and: tree2
]

{ #category : #configuration }
RTDMStrategy >> threshold [
	^ 0.8
]
