# Scoring Map
Scoring Map algorithm for comparing DOM Elements and evaluation tools

Dependencies:

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
