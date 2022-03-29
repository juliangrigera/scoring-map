"
Some scripts
"
Class {
	#name : #DomExperimentScriptRunner,
	#superclass : #Object,
	#category : #ScoringMap
}

{ #category : #api }
DomExperimentScriptRunner >> setupDatabase [
	| repository |
	repository := VOMongoRepository host: 'localhost' database: 'dom_experiment'.
	repository enableSingleton
]
