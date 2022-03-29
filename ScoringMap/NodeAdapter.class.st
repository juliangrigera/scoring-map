Class {
	#name : #NodeAdapter,
	#superclass : #Object,
	#instVars : [
		'paths',
		'equalityPaths',
		'generalizedPaths'
	],
	#category : #'ScoringMap-RTDM'
}

{ #category : #'instance creation' }
NodeAdapter class >> on: adaptee [
	^ self subclassResponsibility
]

{ #category : #comparing }
NodeAdapter >> = otherNode [
	^ self label = otherNode label and: [ self children = otherNode children ]
]

{ #category : #'bag of paths' }
NodeAdapter >> allPaths [
	^ paths ifNil: [ paths := self equalityPaths , self generalizedPaths ]
]

{ #category : #'bag of paths' }
NodeAdapter >> bagOfPathsSimilarityWith: aNode [
	| di dj e n m intersection |
	di := self.
	dj := aNode.
	intersection := di equalityPaths intersection: dj equalityPaths.
	e := intersection size.
	n := di equalityPaths size.
	m := dj equalityPaths size.
	^ e / (n max: m)
]

{ #category : #'bag of paths' }
NodeAdapter >> bagOfXPathsSimilarityWith: aNode [
	| di dj diPaths djPaths diGxPaths djGxPaths e s n m intersection |
	di := self.
	dj := aNode.
	diPaths := di allPaths.
	djPaths := dj allPaths.
	diGxPaths := di generalizedPaths.
	djGxPaths := dj generalizedPaths.
	intersection := di equalityPaths intersection: dj equalityPaths.
	e := intersection size.
	s := (di equalityPaths copyWithoutAll: intersection)
		count: [ :diPath | djGxPaths anySatisfy: [ :gxPath | gxPath subsumes: diPath ] ].
	s := s
		+
			((dj equalityPaths copyWithoutAll: intersection)
				count: [ :djPath | diGxPaths anySatisfy: [ :gxPath | gxPath subsumes: djPath ] ]).
	n := di equalityPaths size.
	m := dj equalityPaths size.
	^ (e + s) / (n + m - e)
]

{ #category : #api }
NodeAdapter >> children [
	^ self subclassResponsibility
]

{ #category : #accessing }
NodeAdapter >> childrenCount [
	^ self children size
]

{ #category : #accessing }
NodeAdapter >> depth [
	^ 1
		+
			(self children
				ifEmpty: [ 0 ]
				ifNotEmpty: [ :children | (children collect: [ :child | child depth ]) max ])
]

{ #category : #accessing }
NodeAdapter >> descendents [
	^ self children , (self children flatCollect: [ :child | child descendents ])
]

{ #category : #'bag of paths' }
NodeAdapter >> equalityPaths [
	^ equalityPaths
		ifNil: [ equalityPaths := ((self equalityPathsWithIndex: 1)
				collect: [ :termsCollection | EqualityPath withTerms: termsCollection ])
				asOrderedCollection ]
]

{ #category : #'bag of paths' }
NodeAdapter >> equalityPathsWithIndex: index [
	| term |
	term := PathTerm on: self index: index.
	^ self children
		ifEmpty: [ term inOrderedCollection inOrderedCollection ]
		ifNotEmpty: [ :children | 
			children
				flatCollect: [ :child | 
					| childSiblings childIndex |
					childSiblings := children
						select: [ :sibling | sibling label = child label ].
					childIndex := childSiblings identityIndexOf: child.
					(child equalityPathsWithIndex: childIndex)
						collect: [ :childPath | term inOrderedCollection , childPath ] ] ]
]

{ #category : #'bag of paths' }
NodeAdapter >> generalizedPaths [
	^ generalizedPaths
		ifNil: [ | equalitySets |
			equalitySets := self equalityPaths groupedBy: [ :equalityPath | equalityPath treePath ].
			generalizedPaths := equalitySets values asOrderedCollection
				collect: [ :equalitySet | self generalizedPathsOf: equalitySet ].
			generalizedPaths := (generalizedPaths
				reject: [ :pathOrNil | pathOrNil isNil or: [ pathOrNil hasNoGeneralizedPredicates | pathOrNil hasMoreThanOneGeneralizedPredicates ] ])
				asSet asOrderedCollection ]
]

{ #category : #'bag of paths' }
NodeAdapter >> generalizedPathsOf: eqPaths [
	^ eqPaths size > 1
		ifTrue: [ | sorted |
			sorted := eqPaths sorted: [ :path1 :path2 | path1 printString < path2 printString ].
			sorted first generalizeWith: sorted second ]
		ifFalse: [ nil ]
]

{ #category : #testing }
NodeAdapter >> hasChildren [
	^ self children isNotEmpty
]

{ #category : #comparing }
NodeAdapter >> hash [
	^ (self label , self children hash) hash
]

{ #category : #testing }
NodeAdapter >> isLeaf [
	^ self children isEmpty
]

{ #category : #api }
NodeAdapter >> label [
	^ self subclassResponsibility
]

{ #category : #'bag of paths' }
NodeAdapter >> resetPaths [
	paths := nil.
	equalityPaths := nil.
	generalizedPaths := nil
]

{ #category : #accessing }
NodeAdapter >> subtreeAt: anInteger [
	^ self children at: anInteger
]

{ #category : #accessing }
NodeAdapter >> withAllDescendents [
	^ self inOrderedCollection , self descendents
]
