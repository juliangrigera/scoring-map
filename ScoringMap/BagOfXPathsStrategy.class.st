Class {
	#name : #BagOfXPathsStrategy,
	#superclass : #RTDMStrategy,
	#category : #'ScoringMap-BagOfPaths'
}

{ #category : #grouping }
BagOfXPathsStrategy >> similitudeRateBetween: domElement and: groupElement [
	| tree1 tree2 |
	tree1 := DomNodeAdapter on: groupElement tree withoutStringNodes.
	tree2 := DomNodeAdapter on: domElement tree withoutStringNodes.
	^ tree1 bagOfXPathsSimilarityWith: tree2
]

{ #category : #configuration }
BagOfXPathsStrategy >> threshold [
	^ 0.54
]
