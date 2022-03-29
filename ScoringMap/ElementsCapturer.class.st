Class {
	#name : #ElementsCapturer,
	#superclass : #Object,
	#instVars : [
		'server'
	],
	#category : #'ScoringMap-Capturer'
}

{ #category : #initialization }
ElementsCapturer >> addElementBlock [

	^ [ :request | 
	  | domElement |
	  [  ]
		  on: Error
		  do: [ request abort ].
	  domElement := self domElementFrom:
		                (STON fromString: request contents).
	  self elementsStore addElement: domElement.
	  self notifyNewElement: domElement.
	  TeaResponse ok body: 'Ok' ]
]

{ #category : #private }
ElementsCapturer >> domElementFrom: getParameters [

	^ DomElement
		  xpath: (getParameters at: 'xpath')
		  content: (getParameters at: 'elementContent')
		  html: (getParameters at: 'elementHTML')
		  parentsList: (getParameters at: 'parentsList')
		  url: (ZnUrl fromString: (getParameters at: 'url'))
		  boundingBox: (Rectangle
				   origin: (getParameters at: 'elementLeft') asNumber
					   @ (getParameters at: 'elementTop') asNumber
				   extent: (getParameters at: 'elementWidth') asNumber
					   @ (getParameters at: 'elementHeight') asNumber)
]

{ #category : #private }
ElementsCapturer >> elementsStore [
	^ ElementsStore instance
]

{ #category : #initialization }
ElementsCapturer >> initialize [

	self setupServer
]

{ #category : #private }
ElementsCapturer >> notifyNewElement: domElement [
	| notification adapted |
	adapted := DomNodeAdapter on: domElement tree withoutStringNodes.
	notification := String
		streamContents: [ :stream | 
			stream << domElement url host.
			stream cr.
			stream << '<'.
			stream << adapted label.
			stream << '> with height: '.
			stream << adapted depth printString].
	GrowlMorph
		openWithLabel: 'Element #' , self elementsStore elementsCount printString , ' Received'
		contents: notification
]

{ #category : #initialization }
ElementsCapturer >> settings [

	^ { 
		  (#defaultOutput -> #json).
		  (#debugMode -> true) }
]

{ #category : #initialization }
ElementsCapturer >> setupServer [

	server := Teapot configure: self settings.
	server POST: '/element' -> self addElementBlock.
	server start
]
