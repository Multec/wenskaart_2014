// Post a BASE64 Encoded PNG Image to facebook
function postImageToFacebook(canvasID, msg, authToken) {
	//console.log(">> PostImageToFacebook(" + canvasID + ", " + msg + ", ...)")
	var canvas = document.getElementById(canvasID);
	var imageData = canvas.toDataURL("image/png");
	try {
		blob = dataURItoBlob(imageData);
	} catch (e) {
		console.log(e);
	}
	var fd = new FormData();
	fd.append("access_token", authToken);
	fd.append("source", blob);
	fd.append("message", msg);
	try {
		$.ajax({
			url: "https://graph.facebook.com/me/photos?access_token=" + authToken,
			type: "POST",
			data: fd,
			processData: false,
			contentType: false,
			cache: false,
			success: function (data) {
				console.log("success " + data);
				//$("#poster").html("Posted Canvas Successfully");
			},
			error: function (shr, status, data) {
				console.log("error " + data + " Status " + shr.status);
				window.alert("Kan de e-card niet posten. Error: " + data + " Status: " + shr.status);
			},
			complete: function () {
				console.log("Posted to facebook");
				window.alert("De e-card staat nu op je Facebook-tijdlijn!");
			}
		});
	} catch (e) {
		console.log(e);
	}
}

// Convert a data URI to blob
function dataURItoBlob(dataURI) {
	var byteString = atob(dataURI.split(',')[1]);
	var ab = new ArrayBuffer(byteString.length);
	var ia = new Uint8Array(ab);
	for (var i = 0; i < byteString.length; i++) {
		ia[i] = byteString.charCodeAt(i);
	}
	return new Blob([ab], {
		type: 'image/png'
	});
}
