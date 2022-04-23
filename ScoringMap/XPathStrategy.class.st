Class {
	#name : #XPathStrategy,
	#superclass : #GroupingStrategy,
	#instVars : [
		'grouping'
	],
	#category : #ScoringMap
}

{ #category : #grouping }
XPathStrategy >> element: domElement belongsIn: group [

	^ group anySatisfy: [ :element | 
		  self element: domElement sharesXPathWith: element ]
]

{ #category : #grouping }
XPathStrategy >> element: domElement sharesXPathWith: groupElement [
	| xpath1 xpath2 |
	xpath1 := XPath new: domElement xpath.
	xpath2 := XPath new: groupElement xpath.
	^ xpath1 regularNoIndexes = xpath2 regularNoIndexes
]

{ #category : #initialization }
XPathStrategy >> grouping [
	^ grouping
]

{ #category : #initialization }
XPathStrategy >> initialize [
	super initialize.
	grouping := OrderedCollection new
]
