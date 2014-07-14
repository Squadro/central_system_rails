var upload_callback = function(upload_url){
    //Just a dummy function.
    
}
$(".fileupload").fileupload({
    name:"uploaded_file"
})

$("#uploadForm").find("input[type=file]").attr("name","uploaded_file");

var uploadOptions = {
 beforeSubmit: function(){
	 console.log("Before submit");
	 $("body").mask("Uploading");
 	},
 success: function(response, statusText, xhr, $form){
	 $("body").unmask();
	 var uploaded_url = response;
	 $("#uploadForm")[0].reset();
	 $(".fileupload").addClass("fileupload-new");
	 $(".fileupload").removeClass("fileupload-exists");
	 $(".fileupload-preview").html('<img src="/images/choose.gif"/>');
	 upload_callback(uploaded_url);
 	},
 error: function(xhr, status, reason){
	 $("body").unmask();
	 alert("Could not upload file");
 	}
}
$("#uploadForm").ajaxForm(uploadOptions);

