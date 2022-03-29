"
Mock Tree for testing RTDM algorithm
"
Class {
	#name : #Node,
	#superclass : #Object,
	#instVars : [
		'label',
		'children'
	],
	#category : #'ScoringMap-RTDM'
}

{ #category : #'instance creation' }
Node class >> labeled: aString [
	^ self new
		label: aString;
		yourself
]

{ #category : #comparing }
Node >> = otherNode [
	^ self label = otherNode label and: [ self children = otherNode children ]
]

{ #category : #accessing }
Node >> children [
	^ children
]

{ #category : #accessing }
Node >> children: anObject [
	children := anObject
]

{ #category : #accessing }
Node >> childrenCount [
	^ self children size
]

{ #category : #accessing }
Node >> descendents [
	^ self children , (self children flatCollect: [ :child | child descendents ])
]

{ #category : #testing }
Node >> hasChildren [
	^ self children isNotEmpty
]

{ #category : #initialization }
Node >> initialize [
	super initialize.
	self children: OrderedCollection new.
	self label: ''
]

{ #category : #testing }
Node >> isLeaf [
	^ self children isEmpty
]

{ #category : #accessing }
Node >> label [
	^ label
]

{ #category : #accessing }
Node >> label: anObject [
	label := anObject
]

{ #category : #printing }
Node >> printOn: aStream [
	aStream nextPutAll: 't[' , self label , ']'
]

{ #category : #accesing }
Node >> subtreeAt: anInteger [
	^ self children at: anInteger
]
