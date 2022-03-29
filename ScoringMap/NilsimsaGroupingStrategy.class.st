Class {
	#name : #NilsimsaGroupingStrategy,
	#superclass : #GroupingStrategy,
	#instVars : [
		'grouping'
	],
	#category : #ScoringMap
}

{ #category : #grouping }
NilsimsaGroupingStrategy >> addToGrouping: domElement [
	| key keyToInsert |
	key := self keyFor: domElement.
	keyToInsert := self similarKeyOrAnswer: key.
	(self grouping at: keyToInsert) add: domElement
]

{ #category : #grouping }
NilsimsaGroupingStrategy >> grouping [
	^ grouping
]

{ #category : #initialization }
NilsimsaGroupingStrategy >> initialize [
	super initialize.
	grouping := Dictionary new
]

{ #category : #grouping }
NilsimsaGroupingStrategy >> keyFor: domElement [
	^ domElement content nilsimsaDigest
]

{ #category : #accessing }
NilsimsaGroupingStrategy >> keys [
	^ self grouping keys
]

{ #category : #grouping }
NilsimsaGroupingStrategy >> keysSimilarTo: candidateKey [
	^ self keys select: [ :key | (Nilsimsa compareDigest: candidateKey with: key) > self tolerance ]
]

{ #category : #grouping }
NilsimsaGroupingStrategy >> similarKeyOrAnswer: candidateKey [
	| similarKeys |
	similarKeys := self keysSimilarTo: candidateKey.
	similarKeys isEmpty
		ifTrue: [ 
			self grouping at: candidateKey put: OrderedCollection new.
			^ candidateKey ]
		ifFalse: [ ^ similarKeys detectMax: [ :key | Nilsimsa compareDigest: candidateKey with: key ] ]
]

{ #category : #grouping }
NilsimsaGroupingStrategy >> tolerance [
	^ 85
]
