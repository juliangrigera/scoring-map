"
Tiny Teapot server for externally testing the parameters of Scoring Maps creation.
"
Class {
	#name : #OptimizationAPI,
	#superclass : #Object,
	#instVars : [
		'server'
	],
	#category : #'ScoringMap-Capturer'
}

{ #category : #initialization }
OptimizationAPI >> initialize [

	self setupServer
]

{ #category : #initialization }
OptimizationAPI >> runBlock [

	^ [ :request | 
	  | parameters inner outer |
	  parameters := STON fromString: request contents.
	  inner := (parameters at: #innerRelevance) asNumber.
	  outer := (parameters at: #outerRelevance) asNumber.
	  ElementsStore instance
		  strategy: ScoringMapStrategy new;
		  reloadTreeMapsInner: inner outer: outer;
		  shuffleElements;
		  refreshStatistics;
		  fScore ]
]

{ #category : #initialization }
OptimizationAPI >> settings [

	^ { 
		  (#port -> 1702).
		  (#defaultOutput -> #json).
		  (#debugMode -> true) }
]

{ #category : #initialization }
OptimizationAPI >> setupServer [

	server := Teapot configure: self settings.
	server POST: '/run' -> self runBlock.
	server start
]