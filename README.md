# Scoring Map
Scoring Map algorithm for comparing DOM Elements and evaluation tools

### Installation
1. Load dependencies(manual loading for now)

```Smalltalk
Metacello new
	baseline: 'XMLParserHTML';
	repository: 'github://pharo-contributions/XML-XMLParserHTML/src';
	load.
  
Metacello new 
	repository: 'github://pharo-nosql/voyage/mc';
	baseline: 'Voyage';
	load: 'mongo tests'.

Metacello new
	baseline: 'Teapot';
	repository: 'github://zeroflag/teapot:master/source';
	load.
```
2. Manually load ScoringMap package from this repository using Iceberg

### Setup

1. Download [Database Dump](https://selfrefactoring.s3.amazonaws.com/scoring_map/ScoringMapExperimentDatabase.zip) and import

2. Start database and import data to image
```Smalltalk
DomExperimentScriptRunner new setupDatabase.
ElementsStore loadInstanceFromDatabase.
```

3. Start server
```Smalltalk
ElementsStore new
```

4. Install capturer.gm.js as a GreaseMonkey script
