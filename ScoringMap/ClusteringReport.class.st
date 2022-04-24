"
A report for a clustering strategy.
Create directly passing an ElementStore that's alredy loaded its statistics.

	ClusteringReport fromStore: aStore

Implementation note: the ElementsStore is NOT stored as an instance variable, so it's safe to run multiple statistics and generate multiple ClusteringReports with a same ElementsStore instance.

Use the MultiClusteringReport  to gather many reports and get the average statistics.
"
Class {
	#name : #ClusteringReport,
	#superclass : #Object,
	#instVars : [
		'falsePositives',
		'falseNegatives',
		'truePositives',
		'automatedGroups',
		'referenceGroups'
	],
	#category : #ScoringMap
}

{ #category : #'instance creation' }
ClusteringReport class >> falsePositives: falsePositives falseNegatives: falseNegatives truePositives: truePositives [
	^ self new
		falsePositives: falsePositives;
		falseNegatives: falseNegatives;
		truePositives: truePositives;
		yourself
]

{ #category : #'instance creation' }
ClusteringReport class >> fromStore: store [
	^ self new
		automatedGroups: store automaticGroupsAsHashes;
		referenceGroups: store referenceGroupsAsHashes;
		falsePositives: store falsePositives;
		falseNegatives: store falseNegatives;
		truePositives: store truePositives;
		yourself
]

{ #category : #accessing }
ClusteringReport >> automatedGroups [

	^ automatedGroups
]

{ #category : #accessing }
ClusteringReport >> automatedGroups: anObject [

	automatedGroups := anObject
]

{ #category : #statistics }
ClusteringReport >> fScore [
	^ (2 * self recall * self precision / (self recall + self precision)) asFloat round: 4
]

{ #category : #accessing }
ClusteringReport >> falseNegatives [
	^ falseNegatives
]

{ #category : #accessing }
ClusteringReport >> falseNegatives: anObject [
	falseNegatives := anObject
]

{ #category : #statistics }
ClusteringReport >> falseNegativesCount [
	^ self falseNegatives size
]

{ #category : #accessing }
ClusteringReport >> falsePositives [
	^ falsePositives
]

{ #category : #accessing }
ClusteringReport >> falsePositives: anObject [
	falsePositives := anObject
]

{ #category : #statistics }
ClusteringReport >> falsePositivesCount [
	^ self falsePositives size
]

{ #category : #statistics }
ClusteringReport >> precision [
	^ (self truePositivesCount / (self falsePositivesCount + self truePositivesCount)) asFloat
]

{ #category : #statistics }
ClusteringReport >> recall [
	^ (self truePositivesCount / (self falseNegativesCount + self truePositivesCount)) asFloat
]

{ #category : #accessing }
ClusteringReport >> referenceGroups [

	^ referenceGroups
]

{ #category : #accessing }
ClusteringReport >> referenceGroups: anObject [

	referenceGroups := anObject
]

{ #category : #accessing }
ClusteringReport >> truePositives [
	^ truePositives
]

{ #category : #accessing }
ClusteringReport >> truePositives: anObject [
	truePositives := anObject
]

{ #category : #statistics }
ClusteringReport >> truePositivesCount [
	^ self truePositives size
]
