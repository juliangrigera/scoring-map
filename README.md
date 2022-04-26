# Scoring Map
Scoring Map algorithm for comparing DOM Elements and evaluation tools

### Installation
1. Load dependencies (manually for now)

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
2. Clone this repository using Iceberg and manually load the ScoringMap package

### Setup

1. Download [Database Dump](https://selfrefactoring.s3.amazonaws.com/scoring_map/dom_experiment.zip) and import as MongoDB database

2. Start database and import data to image
```Smalltalk
DomExperimentScriptRunner new setupDatabase.
ElementsStore loadInstanceFromDatabase.
```

3. Start server
```Smalltalk
ElementsStore new
```

4. Install capturer.gm.js as a GreaseMonkey script (optional, to use DOM elements capturer)
