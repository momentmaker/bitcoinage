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
//= require best_in_place
//= require jquery.validate
//= require foundation
//= require jquery.jeditable
//= require dataTables
//= require dataTables.foundation
//= require dataTables.responsive
//= require jquery.dataTables.editable
//= require pickadate/picker
//= require pickadate/picker.date
//= require highstock
//= require chart


//Sign In button
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

//Foundation
$(function(){ $(document).foundation(); });

//Datepicker
$('.datepicker').pickadate({

});

//Best In Place
$(document).ready(function() {
  $(".best_in_place").best_in_place();
	$('.best_in_place').bind("ajax:success", function (data) {
		$(this).closest('tr').effect('highlight');
	});

	$(".best_in_place").change(function(e) {
		var transaction = $(e.target).closest(".transaction");

		if (e.target.name === "price_dollar") {
			var price = parseFloat(e.target.value);
		} else {
			var price = parseFloat(transaction.children(".price").text().trim().substring(1));
		}

		if (e.target.name === "bitcoin") {
			var bitcoin = parseFloat(e.target.value);
		} else {
			if (transaction.children(".bitcoin").text().trim().charAt(0) === "(") {
				var bitcoin = parseFloat(transaction.children(".bitcoin").text().trim().substring(3));
			} else {
				var bitcoin = parseFloat(transaction.children(".bitcoin").text().trim().substring(2));
			}
		}

		if (e.target.name === "fees") {
			var fees = parseFloat(e.target.value) / 100.0;
		} else {
			var fees = parseFloat(transaction.children(".fees").text()) / 100.0;
		}

		if (transaction.children(".total").text().charAt(0) === "(") {
			transaction.children(".total").text("($" + parseFloat(Math.round((price * bitcoin * fees + price * bitcoin))).toFixed(2) + ")");
		} else {
			transaction.children(".total").text("$" + (price * bitcoin * fees + price * bitcoin).toFixed(2));
		}
	});
});

//Makes tables sortable for bitcoin and total
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

//Datatable
  $('#trans_table').dataTable( {
    "aoColumnDefs": [
      { "type": "satoshi", "targets": [1] },
      { "type": "price", "targets": [4] },
      { "bSortable": false, "aTargets": [5, 6, 7, 8] }]
		} );
  var oTable = $('#trans_table').dataTable();

  // Sort immediately with columns 0 and 1
  oTable.fnSort( [ [0,'desc'] ] );
} );
