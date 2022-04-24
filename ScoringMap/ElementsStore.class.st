"
Elements Store to perform the tests.
Singleton, but allows new instances with #newInstance
"
Class {
	#name : #ElementsStore,
	#superclass : #Object,
	#instVars : [
		'domElements',
		'bufferedElements',
		'referenceGroups',
		'referenceGroupsHashPairs',
		'automaticGroupsHashPairs',
		'matchingPairs',
		'falseNegatives',
		'falsePositives',
		'strategy',
		'groupedElements'
	],
	#classVars : [
		'Default'
	],
	#category : #ScoringMap
}

{ #category : #singleton }
ElementsStore class >> instance [
	^ Default ifNil: [ Default := super new] 
]

{ #category : #voyage }
ElementsStore class >> isVoyageRoot [
	^ true
]

{ #category : #singleton }
ElementsStore class >> loadInstanceFromDatabase [
	Default := self selectAll first
]

{ #category : #singleton }
ElementsStore class >> new [
	^ self error: 'ElementsStore is a Singleton, please use #instance instead of #new'
]

{ #category : #singleton }
ElementsStore class >> newInstance [
	"Singleton hack"

	^ super new
]

{ #category : #gui }
ElementsStore class >> openGUI [
	"self openGUI"

	<script>
	| m |
	m := DynamicComposableModel new.
	m
		instantiateModels:
			#(#split #ButtonModel #seeGroups #ButtonModel #seeAutoGroups #ButtonModel #seeBuffer #ButtonModel #lastElement #ButtonModel #removeLast #ButtonModel #clearBuffer #ButtonModel #reset #ButtonModel).
	m seeBuffer
		label: 'Inspect Buffer';
		action: [ ElementsStore instance bufferedElements inspect ].
	m clearBuffer
		label: 'Clear Buffer';
		action: [ ElementsStore instance clearBufferedElements ];
		whenActionPerformedDo: [ GrowlMorph openWithLabel: 'Buffer cleared' contents: 'Emptied Buffer' ].
	m split
		label: 'Split Group';
		action: [ ElementsStore instance splitGroup ];
		whenActionPerformedDo: [ GrowlMorph openWithLabel: 'Group Created' contents: 'New Reference Group Created' ].
	m seeGroups
		label: 'Inspect Reference Groups';
		action: [ ElementsStore instance referenceGroups inspect ].
	m seeAutoGroups
		label: 'Inspect Grouped Automatically';
		action: [ ElementsStore instance groupedElements inspect ].
	m lastElement
		label: 'Inspect Last Element';
		action: [ ElementsStore instance domElements last inspect ].
	m removeLast
		label: 'Remove Last Buffered Element';
		action: [ ElementsStore instance clearLastBuffered: 1 ].
	m reset
		label: 'Reset Store';
		action: [ ElementsStore resetInstance ];
		whenActionPerformedDo: [ GrowlMorph openWithLabel: 'Store reset' contents: 'All Clear' ].
	m
		openWithSpecLayout:
			(SpecLayout composed
				newColumn: [ :c | 
					c
						add: #seeBuffer height: 26;
						add: #clearBuffer height: 26;
						add: #split height: 26;
						add: #seeGroups height: 26;
						add: #seeAutoGroups height: 26;
						add: #lastElement height: 26;
						add: #removeLast height: 26;
						add: #reset height: 26 ];
				yourself)
]

{ #category : #reports }
ElementsStore class >> printHeading [
	Transcript
		open;
		cr;
		show: '________________________________________';
		cr
]

{ #category : #reports }
ElementsStore class >> reportFScores [
	<script>
	self printHeading.
	Transcript show: 'Strategy	Precision	Recall	F-Score	False Positives	False Negatives'.
	self strategyClassesToAnalyze
		do: [ :strategyClass | 
			| store |
			Transcript
				cr;
				show: strategyClass name;
				tab.
			store := self newInstance.
			store referenceGroups: self instance referenceGroups.
			store domElements: store referenceGroups flattened shuffled.
			store
				strategy: strategyClass new;
				refreshStatistics.
			Transcript
				show: store precision;
				tab;
				show: store recall;
				tab;
				show: store fScore;
				tab;
				show: store falsePositivesCount;
				tab;
				show: store falseNegativesCount ]
]

{ #category : #reports }
ElementsStore class >> reportFScoresByHeight [
	"self reportFScoresByHeight"

	<script>
	self printHeading.
	self strategyClassesToAnalyze
		do: [ :strategyClass | 
			Transcript
				show: strategyClass name;
				tab.
			1 to: 7 do: [ :height | 
				| score store |
				store := self instance copyWithElementsOfHeight: height.
				score := store
					strategy: strategyClass new;
					refreshStatistics;
					fScore.
				Transcript show: score ] ]
]

{ #category : #reports }
ElementsStore class >> reportGroupsCountByHeight [
	"self reportGroupsCountByHeight"

	<script>
	| referenceGroups |
	referenceGroups := self instance referenceGroups.
	Transcript
		open;
		cr;
		show: '________________________________________';
		cr.
	1 to: 7 do: [ :height | 
		| groups |
		groups := referenceGroups select: [ :group | group anyOne height = height ].
		Transcript
			show: height;
			tab;
			show: groups size;
			tab;
			show: groups flattened size;
			cr ].
	Transcript
		show: '-';
		tab;
		show: referenceGroups size;
		tab;
		show: referenceGroups flattened size;
		cr
]

{ #category : #singleton }
ElementsStore class >> resetInstance [
	Default := nil
]

{ #category : #reports }
ElementsStore class >> strategyClassesToAnalyze [
	^ {RTDMStrategy.
	BagOfXPathsStrategy.
	XPathStrategy.
	ScoringMapStrategy}
]

{ #category : #voyage }
ElementsStore class >> voyageCollectionName [
	^ 'ElementsStores'
]

{ #category : #accessing }
ElementsStore >> addElement: aDomElement [
	self domElements add: aDomElement.
	self bufferedElements add: aDomElement
]

{ #category : #grouping }
ElementsStore >> addReferenceGroupWith: someElements [
	self referenceGroups add: someElements
]

{ #category : #accessing }
ElementsStore >> allDomains [
	^ (self domElements
		collect: [ :element | element url host copyReplaceAll: 'www.' with: '' ]) asSet sorted
]

{ #category : #'private - statistics' }
ElementsStore >> automaticGroupsAsHashes [

	^ self groupedElements collect: [ :group | 
		  group collect: [ :element | element hash ] ]
]

{ #category : #'private - statistics' }
ElementsStore >> automaticGroupsHashPairs [
	automaticGroupsHashPairs ifNil: [ self reloadAutomaticGroupsHashPairs ].
	^ automaticGroupsHashPairs
]

{ #category : #accessing }
ElementsStore >> bufferedElements [
	^ bufferedElements
]

{ #category : #accessing }
ElementsStore >> clearBufferedElements [
	bufferedElements := OrderedCollection new.
	ElementsStore instance
		domElements: ElementsStore instance referenceGroups flattened shuffled asOrderedCollection
]

{ #category : #accessing }
ElementsStore >> clearLastBuffered: nElements [
	(bufferedElements last: nElements)
		do: [ :aDomElement | self domElements remove: aDomElement ].
	bufferedElements removeLast: nElements
]

{ #category : #private }
ElementsStore >> confusionMatrixFor: c and: cp [

	^ (c intersection: cp) size
]

{ #category : #copying }
ElementsStore >> copyWithElementsOfHeight: height [
	| newStore groups |
	newStore := self species newInstance.
	groups := self referenceGroupsOfHeight: height.
	newStore referenceGroups: groups.
	newStore domElements: newStore referenceGroups flattened shuffled.
	^ newStore
]

{ #category : #grouping }
ElementsStore >> defaultStrategy [
	^ XPathStrategy new
]

{ #category : #private }
ElementsStore >> domElementWithHash: aHash [
	^ self domElements detect: [ :element | element hash = aHash ]
]

{ #category : #accessing }
ElementsStore >> domElements [
	^ domElements
]

{ #category : #accessing }
ElementsStore >> domElements: anObject [
	domElements := anObject
]

{ #category : #accessing }
ElementsStore >> elementsCount [
	^ self domElements size
]

{ #category : #accessing }
ElementsStore >> elementsOfHeight: height [
	^ self domElements select: [ :element | element height = height ]
]

{ #category : #exporting }
ElementsStore >> exportElementsToCSV [
	| working stream text |
	text := self domElements
		inject: ''
		into: [ :fullText :element | fullText , element url host asString , ', ' , element xpath printString , ', ', element html , '<n>' expandMacros ].
	working := FileSystem disk workingDirectory.
	stream := (working / 'elements_reports/foo.csv') writeStream.
	stream nextPutAll: text.
	stream close
]

{ #category : #exporting }
ElementsStore >> exportGroupedElementsToCSV [
	| working stream grouped |
	grouped := self groupedElements.
	working := FileSystem disk workingDirectory.
	stream := (working / 'elements_reports/grouped.csv') writeStream.
	grouped
		keysDo: [ :key | 
			(grouped at: key)
				do: [ :element | 
					stream
						nextPutAll:
							key , ', ' , element url host asString , ', ' , element xpath printString , ', ' , element html , '<n>' expandMacros ] ].
	stream close
]

{ #category : #statistics }
ElementsStore >> fScore [
	^ (2 * self recall * self precision / (self recall + self precision)) asFloat round: 4
]

{ #category : #'statistics - accessing' }
ElementsStore >> falseNegativePairs [
	^ self falseNegatives
		collect: [ :hashPair | (hashPair collect: [ :hash | self domElementWithHash: hash ]) asOrderedCollection ]
]

{ #category : #'private - statistics' }
ElementsStore >> falseNegatives [
	falseNegatives ifNil: [ self reloadFalseNegatives ].
	^ falseNegatives
]

{ #category : #statistics }
ElementsStore >> falseNegativesCount [
	^ self falseNegatives size
]

{ #category : #'statistics - accessing' }
ElementsStore >> falsePositivePairs [
	^ self falsePositives
		collect: [ :hashPair | (hashPair collect: [ :hash | self domElementWithHash: hash ]) asOrderedCollection ]
]

{ #category : #'private - statistics' }
ElementsStore >> falsePositives [
	falsePositives ifNil: [ self reloadFalsePositives ].
	^ falsePositives
]

{ #category : #statistics }
ElementsStore >> falsePositivesCount [
	^ self falsePositives size
]

{ #category : #grouping }
ElementsStore >> groupedElements [

	^ groupedElements ifNil: [ 
		  groupedElements := self groupedElementsBy: self strategy ]
]

{ #category : #grouping }
ElementsStore >> groupedElementsBy: aGroupingStrategy [
	^ aGroupingStrategy groupingFor: self domElements
]

{ #category : #printing }
ElementsStore >> informElementsByLevelInTranscript [
	Transcript
		open;
		cr;
		cr.
	Transcript
		show: 'Elements'' Height 	Groups Count 	Elements Count';
		cr.
	1 to: 7 do: [ :height | 
		Transcript
			show: height printString;
			tab;
			show: (self referenceGroupsOfHeight: height) size printString;
			tab;
			show: (self elementsOfHeight: height) size printString;
			cr ].
	Transcript
		show: 'Totals';
		tab;
		show: self referenceGroups size;
		tab;
		show: self elementsCount
]

{ #category : #printing }
ElementsStore >> informInTranscript [
	self
		reloadTreeMaps;
		shuffleElements;
		refreshStatistics.
	Transcript open.
	Transcript
		cr;
		cr;
		show: 'Precision: ' , self precision printString;
		cr;
		show: 'Recall: ' , self recall printString;
		cr;
		show: 'False Positives: ' , self falsePositivesCount printString;
		cr;
		show: 'False Negatives: ' , self falseNegativesCount printString;
		cr;
		show: 'F-Score: ' , self fScore printString
]

{ #category : #initialization }
ElementsStore >> initialize [
	super initialize.
	bufferedElements := OrderedCollection new.
	domElements := OrderedCollection new.
	referenceGroups := OrderedCollection new
]

{ #category : #accessing }
ElementsStore >> lastElement [
	^ self domElements last
]

{ #category : #'private - statistics' }
ElementsStore >> matchingPairs [
	matchingPairs ifNil: [ self reloadMatchingPairs ].
	^ matchingPairs
]

{ #category : #statistics }
ElementsStore >> precision [
	^ (self truePositivesCount / (self falsePositivesCount + self truePositivesCount)) asFloat
]

{ #category : #statistics }
ElementsStore >> randIndex [

	| a b c d |
	a := self truePositivesCount.
	b := self trueNegativesCount.
	c := self falseNegativesCount.
	d := self falsePositivesCount.

	^ (a + b / (a + b + c + d)) asFloat
]

{ #category : #statistics }
ElementsStore >> recall [
	^ (self truePositivesCount / (self falseNegativesCount + self truePositivesCount)) asFloat
]

{ #category : #accessing }
ElementsStore >> referenceGroups [
	^ referenceGroups
]

{ #category : #accessing }
ElementsStore >> referenceGroups: aCollection [
	referenceGroups := aCollection
]

{ #category : #'private - statistics' }
ElementsStore >> referenceGroupsAsHashes [
	^ self referenceGroups collect: [ :group | group collect: [ :element | element hash ] ]
]

{ #category : #'private - statistics' }
ElementsStore >> referenceGroupsHashPairs [
	referenceGroupsHashPairs ifNil: [ self reloadReferenceGroupsHashPairs ].
	^ referenceGroupsHashPairs
]

{ #category : #accessing }
ElementsStore >> referenceGroupsOfHeight: height [
	^ self referenceGroups select: [ :group | group anyOne height = height ]
]

{ #category : #'private - statistics' }
ElementsStore >> refreshStatistics [
	self
		reloadAutomaticGroups;
		reloadAutomaticGroupsHashPairs;
		reloadReferenceGroupsHashPairs;
		reloadMatchingPairs;
		reloadFalseNegatives;
		reloadFalsePositives
]

{ #category : #grouping }
ElementsStore >> reloadAutomaticGroups [

	groupedElements := nil
]

{ #category : #'private - statistics' }
ElementsStore >> reloadAutomaticGroupsHashPairs [
	automaticGroupsHashPairs := Set new.
	self automaticGroupsAsHashes
		do: [ :group | 
			group
				allPairsDo: [ :first :second | 
					first > second
						ifTrue: [ automaticGroupsHashPairs
								add:
									{first.
									second} ]
						ifFalse: [ automaticGroupsHashPairs
								add:
									{second.
									first} ] ] ]
]

{ #category : #'private - statistics' }
ElementsStore >> reloadFalseNegatives [
	^ falseNegatives := self referenceGroupsHashPairs difference: self automaticGroupsHashPairs
]

{ #category : #'private - statistics' }
ElementsStore >> reloadFalsePositives [
	^ falsePositives := self automaticGroupsHashPairs difference: self referenceGroupsHashPairs
]

{ #category : #'private - statistics' }
ElementsStore >> reloadMatchingPairs [
	matchingPairs := self automaticGroupsHashPairs intersection: self referenceGroupsHashPairs
]

{ #category : #'private - statistics' }
ElementsStore >> reloadReferenceGroupsHashPairs [
	referenceGroupsHashPairs := Set new.
	self referenceGroupsAsHashes
		do: [ :group | 
			group
				allPairsDo: [ :first :second | 
					first > second
						ifTrue: [ referenceGroupsHashPairs
								add:
									{first.
									second} ]
						ifFalse: [ referenceGroupsHashPairs
								add:
									{second.
									first} ] ] ]
]

{ #category : #private }
ElementsStore >> reloadTreeMaps [
	self domElements do: [ :domElement | domElement reloadTreeMap ]
]

{ #category : #private }
ElementsStore >> reloadTreeMapsInner: innerRelevance outer: outerRelevance [

	self domElements do: [ :domElement | 
		domElement reloadTreeMapInner: innerRelevance outer: outerRelevance ]
]

{ #category : #accessing }
ElementsStore >> removeElement: aDomElement [
	self domElements remove: aDomElement.
	self bufferedElements remove: aDomElement ifAbsent: [  ]
]

{ #category : #accessing }
ElementsStore >> shuffleElements [
	self domElements: self domElements shuffled
]

{ #category : #grouping }
ElementsStore >> splitGroup [
	self bufferedElements
		ifNotEmpty: [ self addReferenceGroupWith: self bufferedElements.
			self clearBufferedElements ]
]

{ #category : #accessing }
ElementsStore >> strategy [
	^ strategy ifNil: [ strategy := self defaultStrategy ]
]

{ #category : #accessing }
ElementsStore >> strategy: anObject [
	^ strategy := anObject
]

{ #category : #statistics }
ElementsStore >> trueNegativesCount [

	| allPairsCount |
	allPairsCount := self domElements size * (self domElements size - 1)
	                 / 2.
	^ allPairsCount
	  - (self falsePositivesCount + self truePositivesCount
		   + self falseNegativesCount)
]

{ #category : #statistics }
ElementsStore >> truePositives [
	^ self matchingPairs
]

{ #category : #statistics }
ElementsStore >> truePositivesCount [
	^ self matchingPairs size
]
