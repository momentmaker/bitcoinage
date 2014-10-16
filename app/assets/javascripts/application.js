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
//= require jquery_ujs
//= require jquery-ui
//= require foundation
//= require dataTables
//= require dataTables.foundation
//= require dataTables.keyTable
//= require dataTables.responsive
//= require jquery.dataTables.editable
//= require pickadate/picker
//= require pickadate/picker.date
//= require highstock
//= require chart

var document = window.document,

	  $_window = $( window ),

  timeout,

  isAnimating = false,
  slideNum = 0,

  	$welcomeBarL = $( ".bt-sl-solid-l" ),
	  $welcomeBarR = $( ".bt-sl-solid-r" ),
	  $btSlideActive = $( ".welcome-button" ).find( ".bt-slide-l" ),

	  $welcomeBtn = $( ".welcome-button a" );

$welcomeBtn.on( 'mouseenter', function () {
	  var timeout,
		    $slidebar = $( '.bt-slider-' + slideNum ),

    animate = function () {

			      timeout = setTimeout(function () {
				        clearTimeout( timeout );

				        if ( slideNum === 5 ) {

					          isAnimating = false;
          					slideNum = 0;

				        } else {

          					isAnimating = true;
          					$slidebar = $( '.bt-slider-' + slideNum );

          					$slidebar.removeClass( 'bt-slide-l' );

          					slideNum++;

          					animate();

				        }

      			}, 100 );
		   };

	  animate();

});

$welcomeBtn.on( 'mouseout', function () {
	  var timeout,
		      $slidebar = $( '.bt-slider-' + slideNum ),

		      animate = function () {

        timeout = setTimeout(function () {
          				clearTimeout( timeout );

          				if ( slideNum === 5 ) {

            					isAnimating = false;
            					slideNum = 0;

          				} else {

            					isAnimating = true;
            					$slidebar = $( '.bt-slider-' + slideNum );

            					$slidebar.addClass( 'bt-slide-l' );

            					slideNum++;

            					animate();

				          }

        			}, 100 );
    		};

  	animate();

});

$_window.on( "load", function () {

  timeout = setTimeout(function () {
					    clearTimeout();

					    $welcomeBarL.removeClass( "down" );
    					$welcomeBarR.removeClass( "down" );

  				}, 100 );

  				timeout = setTimeout(function () {
    					clearTimeout();

    					$welcomeBarL.removeClass( "out" );
    					$welcomeBarR.removeClass( "out" );

  				}, 400 );

  timeout = setTimeout(function () {
    					clearTimeout();

    					$welcomeBtn.removeClass( "out" );

  				}, 800 );

  timeout = setTimeout(function () {
    					clearTimeout();

    					$btSlideActive.removeClass( "out" );

  				}, 1000 );

});

$(function(){ $(document).foundation(); });

$('.datepicker').pickadate({

});

$(document).ready( function() {
  function satoshiValue(string) {
    if (string[0] == "(") {
      return -parseFloat(string.substring(3, string.length - 1));
    } else {
      return parseFloat(string.substring(2, string.length - 1));
    }
  }

  function priceValue(string) {
    if (string[0] == "(") {
      return -parseFloat(string.substring(2, string.length));
    } else {
      return parseFloat(string.substring(1, string.length));
    }
  }

  $.fn.dataTableExt.oSort['satoshi-asc'] = function(xString, yString) {
    var x = satoshiValue($(xString).text().trim());
    var y = satoshiValue($(yString).text().trim());

    return ((x < y) ? -1 : ((x > y) ?  1 : 0));
  };

  $.fn.dataTableExt.oSort['satoshi-desc'] = function(xString, yString) {
    var x = satoshiValue($(xString).text().trim());
    var y = satoshiValue($(yString).text().trim());

    return ((x < y) ?  1 : ((x > y) ? -1 : 0));
  };

  $.fn.dataTableExt.oSort['price-asc'] = function(xString, yString) {
    var x = priceValue(xString.replace(/,/g, ''));
    var y = priceValue(yString.replace(/,/g, ''));

    return ((x < y) ? -1 : ((x > y) ?  1 : 0));
  };

  $.fn.dataTableExt.oSort['price-desc'] = function(xString, yString) {
    var x = priceValue(xString.replace(/,/g, ''));
    var y = priceValue(yString.replace(/,/g, ''));

    return ((x < y) ?  1 : ((x > y) ? -1 : 0));
  };


  $('#trans_table').dataTable( {
    "aoColumnDefs": [
      { "type": "satoshi", "targets": [1] },
      { "type": "price", "targets": [4] },
      { "bSortable": false, "aTargets": [5, 6, 7, 8] }
    ] } );
  var oTable = $('#trans_table').dataTable();

  // Sort immediately with columns 0 and 1
  oTable.fnSort( [ [0,'desc'] ] );
  new $.fn.dataTable.KeyTable( oTable );
} );



$(".show-more a").on("click", function() {
    var $link = $(this);
    var $content = $link.parent().prev("div.text-content");
    var linkText = $link.text();

    switchClasses($content);

    $link.text(getShowLinkText(linkText));

    return false;
});

function switchClasses($content){
    if($content.hasClass("short-text")){
        $content.switchClass("short-text", "full-text", 400);
    } else {
        $content.switchClass("full-text", "short-text", 400);
    }
}

function getShowLinkText(currentText){
    var newText = '';

    if (currentText.toUpperCase() === "SHOW MORE") {
        newText = "Show less";
    } else {
        newText = "Show more";
    }

    return newText;
}
