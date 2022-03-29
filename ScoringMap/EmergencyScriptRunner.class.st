"
This is a summary of the scripts used on a broken set of elements recovered from the MongoDB corrupt dump.
"
Class {
	#name : #EmergencyScriptRunner,
	#superclass : #Object,
	#category : #ScoringMap
}

{ #category : #'broken elements' }
EmergencyScriptRunner >> brokenElementsIndexes [
	self recoveredJson collect: [ :json | json at: 'order' ]
]

{ #category : #'broken elements' }
EmergencyScriptRunner >> domElements [
	^ ElementsStore instance domElements
]

{ #category : #api }
EmergencyScriptRunner >> fixDomElements [
	| storedElements |
	storedElements := DomElement selectAll.
	self recoveredElements
		keysAndValuesDo: [ :order :element | storedElements at: order put: (self recoveredElements at: order) ].
	ElementsStore instance domElements: storedElements
]

{ #category : #'broken elements' }
EmergencyScriptRunner >> recoveredElements [
	| recoveredElements |
	recoveredElements := Dictionary new.
	self recoveredJson
		do: [ :json | 
			| order jsonUrl jsonBox box url element |
			order := json at: 'order'.
			jsonUrl := json at: 'url'.
			jsonBox := json at: 'boundingBox'.
			box := Rectangle
				origin: ((jsonBox at: 'origin') at: 'x') @ ((jsonBox at: 'origin') at: 'y')
				corner: ((jsonBox at: 'corner') at: 'x') @ ((jsonBox at: 'corner') at: 'y').
			url := ZnUrl new
				scheme: (jsonUrl at: 'scheme');
				host: (jsonUrl at: 'host');
				fragment: (jsonUrl at: 'fragment');
				yourself.
			(jsonUrl at: 'query')
				ifNotNil: [ :queryDictionary | url queryAddAll: queryDictionary ].
			(jsonUrl at: 'segments') ifNotNil: [ :segments | url addPathSegments: segments ].
			element := DomElement
				xpath: (json at: 'xpath')
				content: (json at: 'content')
				html: (json at: 'html')
				parentsList: (json at: 'parentsList')
				url: url
				boundingBox: box.
			recoveredElements at: order put: element ].
	^ recoveredElements
]

{ #category : #'broken elements' }
EmergencyScriptRunner >> recoveredJson [
	WAJsonParser
		parseStream: '/Users/juliangrigera/Desktop/LostDocsNoComments.json' asFileReference readStream
]

{ #category : #'broken elements' }
EmergencyScriptRunner >> referenceGroups [
	^ ElementsStore instance referenceGroups
]

{ #category : #api }
EmergencyScriptRunner >> replaceBrokenElementsInGroups [
	(self referenceGroups at: 1) at: 1 put: (self domElements at: 1).
	(self referenceGroups at: 2) at: 7 put: (self domElements at: 17).
	(self referenceGroups at: 3) at: 6 put: (self domElements at: 24).
	(self referenceGroups at: 5) at: 6 put: (self domElements at: 36).
	(self referenceGroups at: 5) at: 9 put: (self domElements at: 39).
	(self referenceGroups at: 5) at: 10 put: (self domElements at: 40).
	(self referenceGroups at: 10) at: 1 put: (self domElements at: 83).
	(self referenceGroups at: 10) at: 9 put: (self domElements at: 91).
	(self referenceGroups at: 13) at: 1 put: (self domElements at: 109).
	(self referenceGroups at: 15) at: 6 put: (self domElements at: 127).
	(self referenceGroups at: 17) at: 8 put: (self domElements at: 150).
	(self referenceGroups at: 17) at: 9 put: (self domElements at: 151).
	(self referenceGroups at: 22) at: 1 put: (self domElements at: 182).
	(self referenceGroups at: 22) at: 5 put: (self domElements at: 186).
	(self referenceGroups at: 23) at: 8 put: (self domElements at: 198).
	(self referenceGroups at: 24) at: 6 put: (self domElements at: 207).
	(self referenceGroups at: 25) at: 1 put: (self domElements at: 208).
	(self referenceGroups at: 25) at: 7 put: (self domElements at: 214).
	(self referenceGroups at: 25) at: 11 put: (self domElements at: 218).
	(self referenceGroups at: 26) at: 4 put: (self domElements at: 223).
	(self referenceGroups at: 27) at: 1 put: (self domElements at: 229).
	(self referenceGroups at: 36) at: 6 put: (self domElements at: 290).
	(self referenceGroups at: 37) at: 1 put: (self domElements at: 298).
	(self referenceGroups at: 41) at: 4 put: (self domElements at: 322).
	(self referenceGroups at: 41) at: 5 put: (self domElements at: 323).
	(self referenceGroups at: 44) at: 6 put: (self domElements at: 359).
	(self referenceGroups at: 50) at: 5 put: (self domElements at: 404).
	(self referenceGroups at: 50) at: 6 put: (self domElements at: 405).
	(self referenceGroups at: 55) at: 4 put: (self domElements at: 447).
	(self referenceGroups at: 56) at: 7 put: (self domElements at: 456).
	(self referenceGroups at: 56) at: 10 put: (self domElements at: 459).
	(self referenceGroups at: 57) at: 12 put: (self domElements at: 471).
	(self referenceGroups at: 60) at: 2 put: (self domElements at: 486).
	(self referenceGroups at: 60) at: 4 put: (self domElements at: 488).
	(self referenceGroups at: 62) at: 6 put: (self domElements at: 502).
	(self referenceGroups at: 65) at: 4 put: (self domElements at: 522).
	(self referenceGroups at: 70) at: 8 put: (self domElements at: 556).
	(self referenceGroups at: 72) at: 1 put: (self domElements at: 571).
	(self referenceGroups at: 78) at: 5 put: (self domElements at: 602).
	(self referenceGroups at: 78) at: 7 put: (self domElements at: 618).
	(self referenceGroups at: 81) at: 2 put: (self domElements at: 629).
	(self referenceGroups at: 82) at: 4 put: (self domElements at: 642).
	(self referenceGroups at: 82) at: 7 put: (self domElements at: 656).
	(self referenceGroups at: 84) at: 1 put: (self domElements at: 670).
	(self referenceGroups at: 85) at: 5 put: (self domElements at: 707).
	(self referenceGroups at: 96) at: 2 put: (self domElements at: 713).
	(self referenceGroups at: 98) at: 1 put: (self domElements at: 721).
	(self referenceGroups at: 100) at: 1 put: (self domElements at: 727).
	(self referenceGroups at: 101) at: 1 put: (self domElements at: 737).
	(self referenceGroups at: 101) at: 6 put: (self domElements at: 745).
	(self referenceGroups at: 103) at: 1 put: (self domElements at: 756).
	(self referenceGroups at: 114) at: 2 put: (self domElements at: 796).
	(self referenceGroups at: 118) at: 1 put: (self domElements at: 797).
	(self referenceGroups at: 120) at: 3 put: (self domElements at: 815).
	(self referenceGroups at: 124) at: 3 put: (self domElements at: 828)
]
