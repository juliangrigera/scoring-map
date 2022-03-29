"
Xpath represents the path of a DomElement.
Basic methods: 
	

Instance Variables
	fullXpath	<>	description of fullXpath


"
Class {
	#name : #XPath,
	#superclass : #Object,
	#instVars : [
		'id',
		'fullXpath'
	],
	#category : #ScoringMap
}

{ #category : #'instance creation' }
XPath class >> new: anXpath [

	^(self new)
		value: anXpath;
		yourself
]

{ #category : #accessing }
XPath >> basicElements [

	| elems |
	elems := OrderedCollection new.
	self regularNoIndexes regex: '/[^/]+(\[[^]]*\])*'
		matchesDo: [:elem | elems add: elem].
	^elems
]

{ #category : #accessing }
XPath >> elements [

	| elems |
	elems := OrderedCollection new.
	self replaceIndexes regex: '/[^/]+(\[[^]]*\])*'
		matchesDo: [:elem | elems add: elem].
	^elems
]

{ #category : #accessing }
XPath >> full [

	^fullXpath
]

{ #category : #comparing }
XPath >> matchingRate: another [

	| elems1 elems2 el1 el2 size break |
	elems1 := self basicElements.
	elems2 := another  basicElements.
	size := 0.
	break := false.
	[break not] whileTrue: 
			[el1 := elems1 remove: elems1 last.
			el2 := elems2 remove: elems2 last.
			el1 = el2 ifTrue: [size := size + 1] ifFalse: [break := true].
			(elems1 isEmpty or: [elems2 isEmpty]) ifTrue: [break := true]].
	^size
]

{ #category : #printing }
XPath >> printOn: aStream [
	aStream nextPutAll: self short
]

{ #category : #copying }
XPath >> reduceXpathToId: id [

	^XPath new: (self full splitOn: id) last
]

{ #category : #accessing }
XPath >> regular [
	^ fullXpath copyWithRegex: '(\[@id[^]]*\]|\[@class[^]]*\])' matchesReplacedWith: ''
]

{ #category : #accessing }
XPath >> regularNoIndexes [
	^ self regular copyWithRegex: '\[\d+\]' matchesReplacedWith: ''
]

{ #category : #accessing }
XPath >> regularReplaceIndexes [
	^ self regular copyWithRegex: '\[\d+\]' matchesReplacedWith: '[*]'
]

{ #category : #accessing }
XPath >> replaceIndexes [
	^ fullXpath copyWithRegex: '\[\d+\]' matchesReplacedWith: '[*]'
]

{ #category : #accessing }
XPath >> short [

	| x res |
	res := nil.
	x := fullXpath replaceRegex: '\[@class[^]]*\]' withString: ''.
	x regex: '\/[^/]+\[@id=[^"]*"[^"]*"[^"]*\]'
		matchesDo: [:match | res := match , (fullXpath splitOn: match) last].
	res notNil ifTrue: [^res].
	^self regular
]

{ #category : #accessing }
XPath >> value: anXpath [

	^fullXpath:= anXpath
]
