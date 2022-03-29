Extension { #name : #XMLString }

{ #category : #'*ScoringMap' }
XMLString >> buildTreeMap: map depth: depth relevance: relevance [
	"Do nothing"

	
]

{ #category : #'*ScoringMap' }
XMLString >> height [
	^ 0
]

{ #category : #'*ScoringMap' }
XMLString >> nodes [
	^ OrderedCollection new
]

{ #category : #'*ScoringMap' }
XMLString >> nodesCount [
	^ 0
]

{ #category : #'*ScoringMap' }
XMLString >> treeMapWithDepth: initialDepth andRelevance: initialRelevance [
	^ Dictionary new
]
