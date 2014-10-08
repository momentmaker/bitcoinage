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
//= require foundation
//= require dataTables
//= require dataTables.foundation
//= require dataTables.keyTable
//= require dataTables.responsive
//= require pickadate/picker
//= require pickadate/picker.date
//= require highstock
//= require chart


$(function(){ $(document).foundation(); });

$('.datepicker').pickadate({

});

$(document).ready( function() {
  $('#trans_table').dataTable( {
    "aoColumnDefs": [
      { "bSortable": false, "aTargets": [6, 7] }
    ] } );
  var oTable = $('#trans_table').dataTable();

  // Sort immediately with columns 0 and 1
  oTable.fnSort( [ [0,'desc'] ] );
  new $.fn.dataTable.KeyTable( oTable );
} );
