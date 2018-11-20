<%--

    Copyright (C) 2016-2018 Code Defenders contributors

    This file is part of Code Defenders.

    Code Defenders is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or (at
    your option) any later version.

    Code Defenders is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
    General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Code Defenders. If not, see <http://www.gnu.org/licenses/>.

--%>
<%-- This jsp assumes that the availability of a MultiplayerGame variable named game --%>
<script>
var sMutants = new Set();
var sLine = null; // Primary Target

var codeOriginalDisplay= document.querySelector('#code').parentNode.style.display;

// Include a DIV for the alternative text
var theForm = document.getElementById('def');
var parent = document.getElementById('utest-div');
var container = document.createElement('div');
container.setAttribute("style", "text-align: center;");
container.innerHTML='<h4 style="margin-top: 50px">Select a target line from the Class Under Test to enable test editor</h4>'
// Hide the div
container.style.display = "none";
// Put the container before the form
parent.insertBefore(container, theForm);

function toggleDefend(){
	if( sLine == null ){
		// When no lines are selected hide code mirror and display the alternative text instead
		document.getElementById('submitTest').disabled = true;
		document.querySelector('#code').parentNode.style.display = "none";
		container.style.display = "block";
	} else {
		// Use the whatever display value was there
		document.getElementById('submitTest').disabled = false;
		document.querySelector('#code').parentNode.style.display = codeOriginalDisplay;
		container.style.display = "none";
	}
}

toggleDefend();

function selectLine(lineNumber){
	if( sLine == lineNumber ){
		sLine = null;
	} else {
		sLine = lineNumber;
	}
	// Update UI
	toggleDefend();
}

var input = document.createElement("input");
input.setAttribute("type", "hidden");
input.setAttribute("id", "selected_lines");
input.setAttribute("name", "selected_lines");
input.setAttribute("value", "");
//append to form element that you want .
theForm.appendChild(input);

<!-- Update Left Code Mirror to enable line selection on gutter -->
var editor = document.querySelector('#sut').nextSibling.CodeMirror;
/* function isEmpty(obj) {
    for (var n in obj) if (obj.hasOwnProperty(n) && obj[n]) return false;
    return true;
  } */

editor.on("gutterClick", function(cm, n) {
  if( sLine != null ){
		if( sLine != n + 1) {
			// DeSelect the previously selected line if any
			cm.setGutterMarker(sLine - 1, "CodeMirror-linenumbers", null);
  		}
  }
  // Toogle the new one
  var info = cm.lineInfo(n);
  var markers = info.gutterMarkers || (info.gutterMarkers = {});
  var value = markers["CodeMirror-linenumbers"]; 
  if (value != null) {
	  cm.setGutterMarker(n, "CodeMirror-linenumbers", null);	  
  } else {
	  cm.setGutterMarker(n, "CodeMirror-linenumbers", makeMarker());
  }
  // 
  selectLine(n+1);
});

function makeMarker() {
  var marker = document.createElement("div");
  marker.style.color = "#822";
  marker.innerHTML = "x";
  return marker;
}

</script>