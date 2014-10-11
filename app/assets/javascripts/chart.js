$(function () {
    // Create the chart
    $('#chart').highcharts('StockChart', {

        rangeSelector: {
            selected: 1,
            inputEnabled: $('#chart').width() > 480
        },

        title: {
            text: 'Bitcoin Price'
        },

        subtitle: {
            text: 'Source: Coindesk.com'
        },

        yAxis: {
            title: {
                text: 'USD'
            },
            labels: {
                formatter: function () {
                    return '$' + this.value;
                }
            }
        },

        plotOptions: {
            series: {
                marker: {
                    enabled: true
                }
            }
        },

        series: [{
            id: 'BITCOIN',
            name: 'USD to BTC',
            color: '#f89d2f',
            data: gon.chart_data,
            tooltip: {
                valueDecimals: 2
            }
        }]
    });

});
