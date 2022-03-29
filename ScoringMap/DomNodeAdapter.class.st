Class {
	#name : #DomNodeAdapter,
	#superclass : #NodeAdapter,
	#instVars : [
		'tree'
	],
	#category : #'ScoringMap-RTDM'
}

{ #category : #'instance creation' }
DomNodeAdapter class >> on: adaptee [
	^ self new
		tree: adaptee;
		yourself
]

{ #category : #comparing }
DomNodeAdapter >> = otherNode [
	^ super = otherNode
		and: [ self tree cssClasses = otherNode tree cssClasses
				or: [ self tree idOrEmptyString = otherNode tree idOrEmptyString
						and: [ self tree idOrEmptyString isNotEmpty ] ] ]
]

{ #category : #api }
DomNodeAdapter >> attributesString [
	^ String
		streamContents: [ :stream | 
			self tree attributes
				keysAndValuesDo: [ :k :v | 
					stream << k.
					stream << ':'''.
					stream << v.
					stream << '''.' ] ]
]

{ #category : #api }
DomNodeAdapter >> children [
	^ self tree nodes collect: [ :node | DomNodeAdapter on: node ]
]

{ #category : #api }
DomNodeAdapter >> label [
	^ self tree name
]

{ #category : #accessing }
DomNodeAdapter >> tree [
	^ tree
]

{ #category : #accessing }
DomNodeAdapter >> tree: xmlNode [
	tree := xmlNode
]
