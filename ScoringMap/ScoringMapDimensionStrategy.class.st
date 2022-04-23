Class {
	#name : #ScoringMapDimensionStrategy,
	#superclass : #ScoringMapStrategy,
	#category : #ScoringMap
}

{ #category : #grouping }
ScoringMapDimensionStrategy >> similitudeRateBetween: domElement and: groupElement [
	^ (groupElement treeMapSimilitudeRateWith: domElement) * 0.8
		+ ((groupElement geometricSimilitudeRateWith: domElement) * 0.2)
]

{ #category : #configuration }
ScoringMapDimensionStrategy >> threshold [
	^ 0.75
]
