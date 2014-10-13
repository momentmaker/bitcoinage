$(function () {
    $('#chart').highcharts('StockChart', {
        rangeSelector: {
            selected: 1,
            inputEnabled: $('#chart').width() > 480
        },

        title: {
            text: 'Bitcoin Price',
            style: {fontSize: "24px"}
        },

        subtitle: {
            text: 'Source: Coindesk.com',
            style: {fontSize: "10px"}
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

        series: [{
            id: 'BITCOIN',
            name: 'USD to BTC',
            color: '#f89d2f',
            marker: {
              symbol: 'url(http://i.imgur.com/380q6kj.png)'
            },
            data: gon.chart_data,
            tooltip: {
                valueDecimals: 2
            }
        }]
    });

});
