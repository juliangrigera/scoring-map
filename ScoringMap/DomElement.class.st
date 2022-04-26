"
Dom Element with auxiliar structure for comparing
"
Class {
	#name : #DomElement,
	#superclass : #Object,
	#instVars : [
		'xpath',
		'url',
		'boundingBox',
		'content',
		'html',
		'parentsList',
		'treeMap',
		'tree'
	],
	#category : #ScoringMap
}

{ #category : #voyage }
DomElement class >> isVoyageRoot [
	^ true
]

{ #category : #voyage }
DomElement class >> voyageCollectionName [
   ^ 'DomElements'
]

{ #category : #'instance creation' }
DomElement class >> xpath: aString content: aContent html: aHTML parentsList: parents url: aURL boundingBox: aRectangle [
	^ self new
		xpath: aString;
		url: aURL;
		boundingBox: aRectangle;
		content: aContent;
		html: aHTML;
		parentsList: parents;
		yourself
]

{ #category : #'instance creation' }
DomElement class >> xpath: aString content: aContent html: aHTML url: aURL boundingBox: aRectangle [
	^ self new
		xpath: aString;
		url: aURL;
		boundingBox: aRectangle;
		content: aContent;
		html: aHTML;
		yourself
]

{ #category : #'instance creation' }
DomElement class >> xpath: aString content: aContent url: aURL boundingBox: aRectangle [
	^ self new
		xpath: aString;
		url: aURL;
		boundingBox: aRectangle;
		content: aContent;
		html: aContent;
		yourself
]

{ #category : #'instance creation' }
DomElement class >> xpath: aString url: aURL [

	^(self new)
		xpath: aString;
		url: aURL;
		yourself
]

{ #category : #'instance creation' }
DomElement class >> xpath: aString url: aURL boundingBox: aRectangle [

	^(self new)
		xpath: aString;
		url: aURL;
		boundingBox: aRectangle;
		yourself
]

{ #category : #testing }
DomElement >> = otherElement [
	^ self class = otherElement class and: [ self xpath = otherElement xpath & (self sameContentAs: otherElement) ]
]

{ #category : #'as yet unclassified' }
DomElement >> _treeMapSimilitudeRateWith: aDomElement [
	"TODO: fix hack"

	| myTreeMap otherTreeMap commonKeys commonRate |
	myTreeMap := self treeMap.
	aDomElement voyageId.
	otherTreeMap := aDomElement treeMap.
	commonKeys := myTreeMap keys intersection: otherTreeMap keys.
	commonRate := commonKeys sumNumbers: [ :commonKey | (myTreeMap at: commonKey) max: (otherTreeMap at: commonKey) ].
	^ (commonRate * 2 / (myTreeMap values sum + otherTreeMap values sum)) asFloat
]

{ #category : #accessing }
DomElement >> boundingBox [

	^boundingBox
]

{ #category : #accessing }
DomElement >> boundingBox: anObject [

	boundingBox := anObject
]

{ #category : #accessing }
DomElement >> content [
	^ content
]

{ #category : #accessing }
DomElement >> content: anObject [
	content := anObject
]

{ #category : #'as yet unclassified' }
DomElement >> creationCode [
	|code|
	code := ReadWriteStream on: ''.
	code nextPutAll: 'DomElement', String cr.
	code nextPutAll: '   xpath:', '''',self xpath,'''', String cr.
	code nextPutAll: '   content:', '''',self content,'''', String cr.
	code nextPutAll: '   html:', '''',self html,'''', String cr.
	code nextPutAll: '   parentsList:', '''',self parentsList,'''', String cr.
	code nextPutAll: '   url:', '''',self url printString,'''', String cr.
	code nextPutAll: '   boundingBox:', '''',self boundingBox printString,'''', String cr.
	^code contents
]

{ #category : #'as yet unclassified' }
DomElement >> geometricSimilitudeRateWith: aDomElement [
	| sameRowLikeness sameColumnLikeness heightDifferenceRate topRemotenessRate widthDifferenceRate leftRemotenessRate |
	heightDifferenceRate := (1 - (self boundingBox height / (aDomElement boundingBox height max: 1))) abs.
	topRemotenessRate := (1 - (self boundingBox top / (aDomElement boundingBox top max: 1))) abs.
	widthDifferenceRate := (1 - (self boundingBox width / (aDomElement boundingBox width max: 1))) abs.
	leftRemotenessRate := (1 - (self boundingBox left / (aDomElement boundingBox left max: 1))) abs.
	sameRowLikeness := 1 - heightDifferenceRate - topRemotenessRate.
	sameColumnLikeness := 1 - widthDifferenceRate - leftRemotenessRate.
	^ sameRowLikeness max: sameColumnLikeness
]

{ #category : #testing }
DomElement >> hasBoundingBox [
	^ self boundingBox isNotNil
]

{ #category : #testing }
DomElement >> hash [
	^ super hash"
	^(self xpath, self html) hash"
]

{ #category : #'as yet unclassified' }
DomElement >> height [
	^ self tree height
]

{ #category : #accessing }
DomElement >> html [
	^ html ifNil: [ html := '' ]
]

{ #category : #accessing }
DomElement >> html: anObject [
	html := anObject
]

{ #category : #testing }
DomElement >> isContainedIn: aRectangle [
	^ aRectangle containsRect: self boundingBox
]

{ #category : #accessing }
DomElement >> parentNodes [
	| nodes |
	nodes := XMLHTMLParser parse: self parentsList.
	^ nodes nodes isEmpty
		ifTrue: [ OrderedCollection new ]
		ifFalse: [ nodes nodes first nodes first nodes ]
	"TODO... find a better way of stripping html and body"
]

{ #category : #'as yet unclassified' }
DomElement >> parentNodesTreeMap [
	| relevance allButFirst |
	relevance := 200.
	allButFirst := self parentNodes allButFirst.
	^ allButFirst
		inject: (self parentNodes first treeMapWithDepth: -1 andRelevance: relevance)
		into: [ :map :parent | 
			| reverseIndex |
			reverseIndex := ((allButFirst indexOf: parent) + 1) * -1.
			relevance := relevance // 2.
			map
				addAll: (parent treeMapWithDepth: reverseIndex andRelevance: relevance);
				yourself ]
]

{ #category : #'as yet unclassified' }
DomElement >> parentNodesTreeMapWithRelevance: initialRelevance [
	| relevance allButFirst |
	relevance := initialRelevance.
	allButFirst := self parentNodes reject: [ :node | node isStringNode ].
	^ allButFirst
		inject: (self parentNodes first treeMapWithDepth: -1 andRelevance: relevance)
		into: [ :map :parent | 
			| reverseIndex |
			reverseIndex := ((allButFirst indexOf: parent) + 1) * -1.
			relevance := relevance // 2.
			map
				addAll: (parent treeMapWithDepth: reverseIndex andRelevance: relevance);
				yourself ]
]

{ #category : #accessing }
DomElement >> parentsList [
	^ parentsList
]

{ #category : #accessing }
DomElement >> parentsList: anObject [
	parentsList := anObject
]

{ #category : #private }
DomElement >> parseContent: aContent [

	content := ''.
	aContent isNil ifFalse: [content := self parseHtml: aContent]
]

{ #category : #printing }
DomElement >> printOn: aStream [
	aStream nextPutAll: (self xpath)
]

{ #category : #accessing }
DomElement >> reloadTree [

	tree := (XMLHTMLParser parse: self html) nodes first nodes first
		        nodes first "TODO: find a better way of removing <html><body>"
]

{ #category : #'as yet unclassified' }
DomElement >> reloadTreeMap [

	self reloadTreeMapInner: 56 outer: 77
]

{ #category : #'as yet unclassified' }
DomElement >> reloadTreeMapInner: innerRelevance outer: outerRelevance [

	treeMap := self tree treeMapWithDepth: 0 andRelevance: innerRelevance.
	self parentNodes ifNotEmpty: [ :parents | 
		treeMap addAll:
			(self parentNodesTreeMapWithRelevance: outerRelevance) ]
]

{ #category : #'as yet unclassified' }
DomElement >> reloadTreeMap_ [
	| barSize innerInitialRelevance outerInitialRelevance |
	barSize := 20.
	innerInitialRelevance := self height * 20.
	outerInitialRelevance := (barSize - self height max: 0) * 40.
	treeMap:= self tree treeMapWithDepth: 0 andRelevance: innerInitialRelevance.
	self parentNodes
		ifNotEmpty: [ :parents | treeMap addAll: (self parentNodesTreeMapWithRelevance: outerInitialRelevance) ]
]

{ #category : #comparing }
DomElement >> sameContentAs: aDomElement [
	^ self html = aDomElement html
]

{ #category : #accessing }
DomElement >> tree [

	^ tree ifNil: [ self reloadTree ]
]

{ #category : #'as yet unclassified' }
DomElement >> treeMap [
	treeMap ifNil: [ self reloadTreeMap ].
	^ treeMap
]

{ #category : #'as yet unclassified' }
DomElement >> treeMapSimilitudeRateWith: e2 [

	| map1 map2 commonSum m1Sum |
	map1 := self treeMap.
	map2 := e2 treeMap.
	commonSum := 0.
	m1Sum := 0.
	map1 keysAndValuesDo: [ :key :value | 
		map2
			at: key
			ifPresent: [ :m2Value | 
			commonSum := commonSum + (value max: m2Value) ].
		m1Sum := m1Sum + value ].
	^ (commonSum * 2 / (m1Sum + map2 values sum)) asFloat
]

{ #category : #accessing }
DomElement >> url [
	^ url
]

{ #category : #accessing }
DomElement >> url: anObject [
	url := anObject
]

{ #category : #accessing }
DomElement >> xpath [
	^ xpath
]

{ #category : #accessing }
DomElement >> xpath: anObject [
	xpath := anObject
]
