Extension { #name : #XMLNodeWithChildren }

{ #category : #'*ScoringMap' }
XMLNodeWithChildren >> addAlternativeEntriesTo: map atDepth: depth relevance: relevance [
	"Was previously weighted - classes had .8 relevance and other attributes .2"

	self addClassAlternativeEntriesTo: map atDepth: depth relevance: relevance.
	self addAttributeAlternativeEntriesTo: map atDepth: depth relevance: relevance
]

{ #category : #'*ScoringMap' }
XMLNodeWithChildren >> addAttributeAlternativeEntriesTo: map atDepth: depth relevance: relevance [
	self attributes keys 
		do: [ :attributeName | 
			| key |
			key := depth printString , '@' , self name , '-' , attributeName.
			map at: key put: relevance ]
		without: 'class'
]

{ #category : #'*ScoringMap' }
XMLNodeWithChildren >> addClassAlternativeEntriesTo: map atDepth: depth relevance: relevance [
	self cssClasses
		do: [ :className | 
			| key |
			key := depth printString , '@' , self name , '.' , className.
			map at: key put: relevance ]
		without: 'highlight'
]

{ #category : #'*ScoringMap' }
XMLNodeWithChildren >> buildTreeMap: map depth: depth relevance: relevance [
	"Children's relevance used to be: relevance // (self uniqueTagNodes size max: 1)"

	| key childrenRelevance |
	key := depth printString , '@' , self name.
	relevance > 0
		ifTrue: [ map at: key put: relevance.
			self addAlternativeEntriesTo: map atDepth: depth relevance: relevance.
			childrenRelevance := relevance // (self uniqueTagNodes size max: 1).
			self nodes
				do: [ :node | node buildTreeMap: map depth: depth + 1 relevance: childrenRelevance ] ]
]

{ #category : #'*ScoringMap' }
XMLNodeWithChildren >> cssClasses [
	^ (self attributes at: 'class' ifAbsent: [ ^ OrderedCollection new ]) substrings: {(Character space)}
]

{ #category : #'*ScoringMap' }
XMLNodeWithChildren >> height [
	^ self nodes ifEmpty: [ 1 ] ifNotEmpty: [ (self nodes detectMax: [ :node | node height ]) height + 1 ]
]

{ #category : #'*ScoringMap' }
XMLNodeWithChildren >> idOrEmptyString [
	^ self attributes at: 'id' ifAbsent: ''
]

{ #category : #'*ScoringMap' }
XMLNodeWithChildren >> nodesCount [
	^ 1 + (self nodes sumNumbers: [ :node | node nodesCount ])
]

{ #category : #'*ScoringMap' }
XMLNodeWithChildren >> treeMap [
	^ self treeMapWithDepth: 0 andRelevance: 100 * self height
]

{ #category : #'*ScoringMap' }
XMLNodeWithChildren >> treeMapWithDepth: initialDepth andRelevance: initialRelevance [
	| map |
	map := Dictionary new.
	self buildTreeMap: map depth: initialDepth relevance: initialRelevance.
	^ map
]

{ #category : #'*ScoringMap' }
XMLNodeWithChildren >> uniqueTagNodes [
	^ (self nodes collect: [ :node | node printString ]) asSet
]

{ #category : #'*ScoringMap' }
XMLNodeWithChildren >> withoutStringNodes [
	| copy oldNodes |
	copy := self copy.
	oldNodes := (copy nodes copyWithoutAll: copy nodes stringNodes) collect: [ :node | node withoutStringNodes ].
	copy removeNodes.
	copy addNodes: oldNodes.
	^ copy
]
