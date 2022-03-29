Class {
	#name : #ScoringMapDimensionStrategy,
	#superclass : #ScoringMapStrategy,
	#category : #ScoringMap
}

{ #category : #grouping }
ScoringMapDimensionStrategy >> similitudeRateBetween: domElement and: groupElement [
	^ (groupElement treeMapSimilitudeRateWith: domElement) * 0.9
		+ ((groupElement geometricSimilitudeRateWith: domElement) * 0.1)
]

{ #category : #configuration }
ScoringMapDimensionStrategy >> threshold [
	^ 0.86
]
