// ==UserScript==
// @name        Experiment
// @namespace   selfref
// @version     1
// @grant       none
// ==/UserScript==
if (window.top != window.self) //don't run on frames or iframes
{
  //Optional: GM_log ('In frame');
  return;
}
window.addEventListener('load', LocalMain, false);
function LocalMain() {
  
  // Your code goes here.
  /************************************************************************************************************
											XpathProcessor
************************************************************************************************************/
  function XpathProcessor() {
	 this.getElementByXpath = function (path) {
		return document.evaluate(path, document, null, 9, null).singleNodeValue;
	 };
	 this.getElementTreeXPath = function (element) {
		var paths = [
		];
		for (; element && element.nodeType == 1; element = element.parentNode) {
		  var index = 0;
		  for (var sibling = element.previousSibling; sibling; sibling = sibling.previousSibling) {
			 if (sibling.nodeType == Node.DOCUMENT_TYPE_NODE)
			 continue;
			 if (sibling.nodeName == element.nodeName)
			 ++index;
		  }
		  var tagName = element.nodeName.toLowerCase();
		  var pathIndex = (index ? '[' + (index + 1) + ']' : '');
		  paths.splice(0, 0, tagName + pathIndex);
		}
		return paths.length ? '/' + paths.join('/')  : null;
	 };
	 this.getElementXPath = function (element) {
		if (element && element.id)
		return '//*[@id="' + element.id + '"]';
		 else
		return xpathInstance.getElementTreeXPath(element);
	 };
	 this.getXPath = function (element) {
		var paths = [
		];
		for (; element && element.nodeType == 1; element = element.parentNode) {
		  var index = 0;
		  for (var sibling = element.previousSibling; sibling; sibling = sibling.previousSibling) {
			 if (sibling.nodeType == Node.DOCUMENT_TYPE_NODE)
			 continue;
			 if (sibling.nodeName == element.nodeName)
			 ++index;
		  }
		  var tagName = element.nodeName.toLowerCase();
		  var unique = true;
		  for (sibling = element.nextSibling; sibling; sibling = sibling.nextSibling) {
			 if (sibling.nodeType == Node.DOCUMENT_TYPE_NODE) continue;
			 if (sibling.nodeName == element.nodeName) {
				unique = false;
				break;
			 }
		  }
		  var pathIndex = (!unique ? '[' + (index + 1) + ']' : '');
		  paths.splice(0, 0, tagName + pathIndex);
		}
		return paths.length ? '/' + paths.join('/')  : null;
	 };
	 this.clearXpath = function (xpath) {
		return xpath.replace(/\d+/g, '*');
	 };
  }  
  
/************************************************************************************************************
											Logger
************************************************************************************************************/

  function ExperimentLogger(serverHost, verbose) {
	 this.host = serverHost + 'element';
	 this.verbose = (typeof verbose === 'undefined') ? false : verbose;
	 this.loggingEnabled = true;
	 var logger = this;
	 console.log('Experiment Logger v1.0 Loaded.');
	 
	 this.logElement = function (rawElement) {
		parameters = {};
		parameters.xpath = xpathInstance.getXPath(rawElement);
		parameters.elementLeft = rawElement.getBoundingClientRect().left;
		parameters.elementTop = rawElement.getBoundingClientRect().top;
		parameters.elementWidth = rawElement.getBoundingClientRect().width;
		parameters.elementHeight = rawElement.getBoundingClientRect().height;
		parameters.url = document.URL;
		parameters.parentsList = this.buildParentsList(rawElement);
		parameters.elementContent = this.htmlStructureOnly(rawElement);
		parameters.elementHTML = rawElement.outerHTML;
		post = JSON.stringify(parameters);

		var xhr = new XMLHttpRequest();
			 xhr.open('POST', this.host, true);
			 xhr.setRequestHeader('Content-type', 'application/json; charset=UTF-8');
			 xhr.send(post);
	 }
	 
	 this.buildParentsList = function (element) {
		list = '';
		 var parent = element.parentNode;
		while (parent !== document.body) {
		  var empty = parent.cloneNode(true);
		  empty.innerHTML = '';
		  list += empty.outerHTML + '\n';
		  parent = parent.parentNode;
		 }
		return list;
	 }
	 
	 this.startLogging = function () {
		  
  document.addEventListener('click', function(e) {
	  if (e.shiftKey) {
			 var x = e.clientX, y = e.clientY;
			 elementMouseIsOver = document.elementFromPoint(x, y);
			 var xpath = xpathInstance.getXPath(elementMouseIsOver);
			 
			  e.stopPropagation();
			  e.preventDefault();
			  console.log('Logging ' + xpath);
			  logger.logElement(elementMouseIsOver);
	  }

}, false);

	 }

	 
	 this.htmlStructureOnly = function (element) {
		var elementCopy = element.cloneNode(true);
		elementCopy.querySelectorAll('script').forEach(child => child.remove())
		elementCopy.querySelectorAll('*').forEach(child => {
		  if(child.tagName !== 'IFRAME') {
			 if (child.nodeType == 3) {child.remove()}
		  }});
		elementCopy.querySelectorAll('a').forEach( anchor => anchor.removeAttribute('href'));
		elementCopy.querySelectorAll('img').forEach( image => image.removeAttribute('src'));
		return elementCopy.outerHTML;
//       return $.htmlClean(
//         elementCopy.outerHTML, 
//         {allowedAttributes: [['id'],['placeholder']]}
//       ) + '';
	 }
  }
  var notify = document.createElement('script');
  notify.type = 'text/javascript';
  notify.src = 'https://selfrefactoring.s3.amazonaws.com/experiment/logger/notiFire.js';
  var notifyCss = document.createElement('link');
  notifyCss.href = 'https://selfrefactoring.s3.amazonaws.com/experiment/logger/notiFire.css';
  notifyCss.type = 'css';
  notifyCss.type = 'text/css';
  notifyCss.rel = 'stylesheet';
  notifyCss.media = 'screen,print';
  document.getElementsByTagName('head') [0].appendChild(notify);
  document.getElementsByTagName('head') [0].appendChild(notifyCss);
  var clean = document.createElement('script');
  clean.type = 'text/javascript';
  clean.src = 'https://selfrefactoring.s3.amazonaws.com/experiment/logger/jquery.htmlClean.min.js';
  if (typeof (jQuery) == 'undefined') {
	 var jquery = document.createElement('script');
	 jquery.type = 'text/javascript';
	 jquery.src = 'https://selfrefactoring.s3.amazonaws.com/experiment/logger/jquery.js';
	 document.getElementsByTagName('head') [0].appendChild(jquery);
  }
  document.getElementsByTagName('body') [0].appendChild(clean);
  clean.onload = function () {
	 xpathInstance = new XpathProcessor();
	 logger = new ExperimentLogger('http://localhost:1701/', true);
	 logger.startLogging();
  };
  (function () {
	 var prev;
	 if (document.body.addEventListener) {
		document.body.addEventListener('mouseover', handler, false);
	 } 
	 else if (document.body.attachEvent) {
		document.body.attachEvent('mouseover', function (e) {
		  return handler(e || window.event);
		});
	 } 
	 else {
		document.body.onmouseover = handler;
	 }
	 function handler(event) {
		if (event.target === document.body || (prev && prev === event.target)) {
		  return;
		}
		if (prev) {
		  prev.className = prev.className.replace(/\bhighlight\b/, '');
		  prev = undefined;
		}
		if (event.target) {
		  prev = event.target;
		  prev.className += ' highlight';
		}
	 }
  }) ();
  var style = document.createElement('style');
  style.type = 'text/css';
  style.innerHTML = '.highlight{-webkit-box-shadow: 0 0 3px 3px lightblue;-moz-box-shadow: 0 0 3px 3px lightblue;box-shadow: 0 0 3px 3px lightblue;}';
  document.getElementsByTagName('head') [0].appendChild(style);


  // End
}