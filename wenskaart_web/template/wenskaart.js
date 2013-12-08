/***
	
    wenskaart.js

	A creation of Multec, the professional bachelor in multimedia &
	communication technology at the Erasmus University College in
	Brussels.
	
    Authors:
	- Wouter Van den Broeck
	- Inti De Ceukelaire
	
    wenskaart.js is licensed under the MIT License, see LICENSE.

***/

// *****************************************************************************
// Variabels:
// -----------------------------------------------------------------------------

var layoutOptions = ["links", "rechts", "centraal", "banner 1", "banner 2"];
var defaultLayout = "banner 1";

var fontOptions = ["sans-serif", "serif", "monospace", "fantasy", "cursive"];
var defaultFont = "serif";

var fontSizeOptions = [24, 28, 32, 36, 40, 44, 48];
var defaultFontSize = 28;

var defaultFgColor = { r: 255, g: 255, b: 255 };
var defaultBgColor = { r: 190, g: 0, b: 0 };
var defaultTxtColor = { r: 255, g: 255, b: 255 };


// *****************************************************************************
// JQuery:
// -----------------------------------------------------------------------------

$(function() {
	
	// init layout-options:
	for (var i = 0; i < layoutOptions.length; i++) {
		var v = layoutOptions[i];
		$("#layout-options")
			.append($('<option>', { value : v, selected: v == defaultLayout })
			.text(v));
	}
	$("#layout-options").change(function () {
		setLayout($(this).find("option:selected").attr("value"));
	});
	
	// init font-options:
	for (var i = 0; i < fontOptions.length; i++) {
		var v = fontOptions[i];
		$("#font-options")
			.append($('<option>', { value: v, selected: v == defaultFont })
			.text(v));
	}
	$("#font-options").change(function () {
		setFont($(this).find("option:selected").attr("value"));
	});
	
	// init fontsize-options:
	for (var i = 0; i < fontSizeOptions.length; i++) {
		var v = fontSizeOptions[i];
		$("#fontsize-options")
			.append($('<option>', { value : v, selected: v == defaultFontSize })
			.text(v));
	}
	$("#fontsize-options").change(function () {
		setFontSize(parseInt($(this).find("option:selected").attr("value")));
	});
	
	// init textfield:
	$("#textInput_1").keyup(function (e) {
        setText();
	});
	
	// init sliders:
	$("#nFlakes_slider").slider({
		min: 5, max: 100, value: 50,
		orientation: "horizontal", range: "min",
		change: updateNFlakes
	});
	$("#nTrunks_slider").slider({
		min: 3, max: 12, values: [5, 8],
		orientation: "horizontal", range: true,
		change: updateNTrunks
	});
	$("#nBranch_slider").slider({
		min: 1, max: 12, values: [3, 8],
		orientation: "horizontal", range: true,
		change: updateNBranches
	});
	
	// skin buttons:
	$("button.skinned").button({});
	
	// init color pickers:
	$("#foreground-box").colpick({
		color: defaultFgColor,
		onSubmit:function(hsb, hex, rgb, el) {
			$(el).colpickHide();
			setFgColor(rgb);
		}
	});
	$("#background-box").colpick({
		color: defaultBgColor,
		onSubmit:function(hsb, hex, rgb, el) {
			$(el).colpickHide();
			setBgColor(rgb);
		}
	});
	$("#text-color-box").colpick({
		color: defaultTxtColor,
		onSubmit:function(hsb, hex, rgb, el) {
			$(el).colpickHide();
			setTxtColor(rgb);
		}
	});
	
	$("#logo-checkbox").change(function () {
		showLogo($(this).prop("checked"));
	});
	
});

// *****************************************************************************
// PApplet update methods:
// -----------------------------------------------------------------------------

function setLayout(v) {
	sketch().setLayout(v);
}

function setFont(v) {
	sketch().setFont(v);
}

function setFontSize(v) {
	sketch().setFontSize(v);
}

function setText() {
	sketch().setText(getText());
}
function getText() {
	return document.getElementById('textInput_1').value;
}

function setBgColor(rgb) {
	$("#background-box").css('background-color', rgbToHex(rgb));
	sketch().setBgColor(rgb.r, rgb.g, rgb.b, true);
}

function setFgColor(rgb) {
	$("#foreground-box").css('background-color', rgbToHex(rgb));
	sketch().setFgColor(rgb.r, rgb.g, rgb.b, true);
}

function setTxtColor(rgb) {
	$("#text-color-box").css('background-color', rgbToHex(rgb));
	sketch().setTxtColor(rgb.r, rgb.g, rgb.b);
}

function showLogo(show) {
	//console.log(">> showLogo(" + show + ")");
	if (show) {
		sketch().showMultecLogo();
	}
	else {
		sketch().hideMultecLogo();
	}
}

function updateNFlakes() {
	sketch().setNFlakes($("#nFlakes_slider").slider("value"));
}

function updateNTrunks() {
	values = $("#nTrunks_slider").slider("values");
	sketch().setNTrunks(values[0], values[1]);
}

function updateNTrunks() {
	values = $("#nTrunks_slider").slider("values");
	sketch().setNTrunks(values[0], values[1]);
}

function updateNBranches() {
	values = $("#nBranch_slider").slider("values");
	sketch().setNBranches(values[0], values[1]);
}

function resetSeed() {
	sketch().resetSeed();
}

// *****************************************************************************
// Export methods:
// -----------------------------------------------------------------------------

function exportImage() {
	var r = window.confirm("Het beeldbestand wordt geladen in je browser. Je kunt het dan opslaan of in een e-mail slepen.");
	if (r == true) {
		sketch().exportImage();
	}
}

function submitToFacebook() {
	var msg = getText(); // + " (http://www.ehb.be/2014)";
	FB.login(function(response) {
		if 	(response.authResponse) {
			postImageToFacebook('wenskaart', msg, response.authResponse.accessToken);
		} else {
			window.alert("Kan de e-card niet posten. Je bent niet ingelogd.");
		}
	} , {
		scope: 'publish_actions,publish_stream'
	});
}


// *****************************************************************************
// Utility methods:
// -----------------------------------------------------------------------------

function sketch() { return Processing.getInstanceById('wenskaart'); }

/**
 * Converts an rgb object like { r: 0, g: 0, b: 0 } to a hex-string like #000000.
 */
function rgbToHex(rgb) {
	return "#" +
	("0" + rgb.r.toString(16)).slice(-2) +
	("0" + rgb.g.toString(16)).slice(-2) +
	("0" + rgb.b.toString(16)).slice(-2);
}

/**
 * Converts a hex-string like #000000 or 000000 to an rgb object like
 * { r: 0, g: 0, b: 0 }.
 */
function hexToRgb(hex) {
	hex = trimHex(hex);
	return {
		r: parseInt(hex.substring(0, 2), 16),
		g: parseInt(hex.substring(2, 4), 16),
		b: parseInt(hex.substring(4, 6), 16)
	}
}

function trimHex(hex) {
	return hex.charAt(0) == "#" ? hex.substring(1, 7) : hex;
}

