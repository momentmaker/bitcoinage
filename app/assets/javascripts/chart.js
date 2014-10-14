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

        legend: {
            enabled: true,
            backgroundColor: '#FFFFFF',
            layout: 'vertical',
            floating: true,
            align: 'left',
            verticalAlign: 'top',
            x: 90,
            y: 120,
            shadow: true
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
          }, {
            id: 'BUY',
            type: 'column',
            name: 'Price Bought',
            color: '#216C2A',
            marker: {
              symbol: 'url(http://i.imgur.com/380q6kj.png)'
            },
            data: gon.buy_data,
            tooltip: {
                valueDecimals: 2
            },
          }, {
            id: 'SELL',
            type: 'column',
            name: 'Price Sold',
            color: '#8A0707',
            marker: {
              symbol: 'url(http://i.imgur.com/380q6kj.png)'
            },
            data: gon.sell_data,
            tooltip: {
                valueDecimals: 2
            }
          }]
    });

});
