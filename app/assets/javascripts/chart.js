$(function () {
    // Create the chart
    $('#container').highcharts('StockChart', {

        rangeSelector : {
            selected : 1,
            inputEnabled: $('#container').width() > 480
        },

        title : {
            text : 'Bitcoin Price'
        },


        series : [{
            name : 'Bitcoin',
            data : gon.chart_data,
            tooltip: {
                valueDecimals: 2
            }
        }]
    });

});
