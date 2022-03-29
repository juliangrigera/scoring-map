"
The final stage of the report.
A set of clustering reports, for purposes of calculating averaged values.
Create for example with 	
	
   [report := MultiClusteringReport forStrategy:  ScoringMapStrategy new] fork. 
(Fork to avoid waiting, it might take long. )

Then ask for #fullReport
"
Class {
	#name : #MultiClusteringReport,
	#superclass : #Object,
	#instVars : [
		'reports',
		'strategyName'
	],
	#category : #ScoringMap
}

{ #category : #scripts }
MultiClusteringReport class >> forStrategy: aGroupingStrategy [
	| store reports |
	store := ElementsStore instance.
	reports := OrderedCollection new.
	20
		timesRepeat: [ store
				strategy: aGroupingStrategy;
				reloadTreeMaps;
				shuffleElements;
				refreshStatistics.
			reports add: (ClusteringReport fromStore: store) ].
	^ self reports: reports strategyName: aGroupingStrategy class name
]

{ #category : #voyage }
MultiClusteringReport class >> isVoyageRoot [
	^ true
]

{ #category : #scripts }
MultiClusteringReport class >> playground [
	| store report |
	store := ElementsStore instance.

	"Quick check"
	Transcript clear.
	store
		strategy: ScoringMapStrategy new;
		informInTranscript.

	"Generate report with 20 samples"
	[ report := MultiClusteringReport forStrategy: ScoringMapStrategy new ] fork.

	"Misc"
	store save.
	store domElements size = store referenceGroups flattened size.
	store removeElement: (store domElementWithHash: 508970496)
]

{ #category : #'instance creation' }
MultiClusteringReport class >> reports: reports [
	^ self new
		reports: reports;
		yourself
]

{ #category : #'instance creation' }
MultiClusteringReport class >> reports: reports strategyName: aString [
	^ self new
		reports: reports;
		strategyName: aString;
		yourself
]

{ #category : #scripts }
MultiClusteringReport class >> strategyPlaygound [
	| store reports aGroupingStrategy |
	aGroupingStrategy := XPathStrategy new.
	store := ElementsStore instance.
	reports := OrderedCollection new.
	[ 20
		timesRepeat: [ store
				strategy: aGroupingStrategy;
				reloadTreeMaps;
				shuffleElements;
				refreshStatistics.
			reports add: (ClusteringReport fromStore: store) ] ] fork.
	MultiClusteringReport reports: reports strategyName: aGroupingStrategy class name
]

{ #category : #voyage }
MultiClusteringReport class >> voyageCollectionName [
	^ 'MultiClusteringReports'
]

{ #category : #private }
MultiClusteringReport >> averageCountMeasure: aMeasureName [
	^ (self reports collect: [ :report | (report perform: aMeasureName) size ]) average floor
]

{ #category : #accessing }
MultiClusteringReport >> averageFScore [
	^ self averageMeasure: #fScore
]

{ #category : #accessing }
MultiClusteringReport >> averageFalseNegatives [
	^ self averageCountMeasure: #falseNegatives
]

{ #category : #accessing }
MultiClusteringReport >> averageFalsePositives [
	^ self averageCountMeasure: #falsePositives
]

{ #category : #private }
MultiClusteringReport >> averageMeasure: aMeasureName [
	^ (self reports collect: [ :report | report perform: aMeasureName ]) average
]

{ #category : #accessing }
MultiClusteringReport >> averagePrecision [
	^ self averageMeasure: #precision
]

{ #category : #accessing }
MultiClusteringReport >> averageRecall [
	^ self averageMeasure: #recall
]

{ #category : #accessing }
MultiClusteringReport >> averageTrueNegatives [
	^ self averageCountMeasure: #trueNegatives
]

{ #category : #accessing }
MultiClusteringReport >> averageTruePositives [
	^ self averageCountMeasure: #truePositives
]

{ #category : #printing }
MultiClusteringReport >> fullReport [
	^ String
		streamContents: [ :stream | 
			stream << self strategyName.
			stream tab.
			self averagePrecision printOn: stream.
			stream tab.
			self averageRecall printOn: stream.
			stream tab.
			self averageFScore printOn: stream.
			stream tab.
			self averageFalsePositives printOn: stream.
			stream tab.
			self averageFalseNegatives printOn: stream. ]
]

{ #category : #accessing }
MultiClusteringReport >> reports [
	^ reports
]

{ #category : #accessing }
MultiClusteringReport >> reports: anObject [
	reports := anObject
]

{ #category : #accessing }
MultiClusteringReport >> strategyName [
	^ strategyName
]

{ #category : #accessing }
MultiClusteringReport >> strategyName: aString [
	strategyName := aString
]
