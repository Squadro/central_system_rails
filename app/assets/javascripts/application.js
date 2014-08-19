// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require colorbox-rails
//= require jquery_ujs
//= require scriptbreaker-multiple-accordion-1
//= require twitter/bootstrap
//= require turbolinks
//= require_tree .
//= require chosen-jquery
//= require scaffold


function doAjaxRequest(url,method,data,dataType,successCallback,errorCallback){
    if(!errorCallback){
        errorCallback = handleGenericError
    }
	
    $.ajax({
        type: method,
        url: url,
        processData : true,
        cache: true,
        data: data,
        dataType: dataType,
        success: successCallback,
        error: errorCallback
    });

}

function handleGenericError(xhr, status, reason){
    try{
        var data = $.parseJSON(xhr.responseText);

        if(data.error && data.error.type){
            //Error handle later.
            console.log(xhr.responseText);
        }
    }catch(e){
        console.log(e);
    }
}