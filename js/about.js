$(function () { 

// Highcharts
    Highcharts.setOptions({
        chart: {
            height: 250,
            backgroundColor: "transparent",
            style: {
                fontFamily: "Lato",
            },
        },
        title: {
            text: ""
        },
        legend: {
            enabled: false,
        },
        credits: {
            enabled: false,
        },
        yAxis: {
            min: 0,
            labels: {
                enabled: false
            },
            title: {
                text: ""
            },
            gridLineColor: "transparent",
        },
    });

    plot_options_timeline = {
        chart: {
            type: "line",
            renderTo: "timeline",
            zoomType: "x",
        },
        xAxis: {
            labels: {
                enabled: true
            },
            type: "datetime",
            min: Date.UTC(2003,  10, 1),
            max: Date.UTC(new Date().getFullYear(),  new Date().getMonth() + 3, 29)
        },
        tooltip: {
            formatter: function() {
                    info = {
                        "Studies I": "Mathematics degree at PUC",
                        "Studies II": "Master in Statistics at PUC",
                        "Scoring Analyst": "at Corpbanca",
                        "Risk Analyst": "at Equifax Chile",
                        "Senior Data Scientist": "at Foris",
                        "Senior Scoring Analyst": "at Scotiabank",
                    };
                    
                    date_format = Highcharts.dateFormat('%Y - %B', new Date(this.x));
                    
                    return "<b>"+this.series.name+"</b><br/><em>"+date_format+"</em><br/>"+info[this.series.name];
            }
        },
        series: [
            { name: "Studies I",                lineWidth: 10, data: [ [Date.UTC(2004, 3, 1), 1], [Date.UTC(2007,11, 1), 1], ] },
            { name: "Studies II",               lineWidth: 10, data: [ [Date.UTC(2008, 3, 1), 2], [Date.UTC(2009,11, 1), 2], ] },
            { name: "Scoring Analyst",          lineWidth: 10, data: [ [Date.UTC(2010, 8, 1), 3], [Date.UTC(2011, 2, 1), 3], ] },
            { name: "Risk Analyst",             lineWidth: 10, data: [ [Date.UTC(2011, 2, 1), 4], [Date.UTC(2013, 1, 1), 4], ] },
            { name: "Senior Data Scientist",    lineWidth: 10, data: [ [Date.UTC(2013, 1, 1), 5], [Date.UTC(2014, 8, 1), 5], ] },
            { name: "Senior Scoring Analyst",   lineWidth: 10, data: [ [Date.UTC(2014, 8, 1), 6], [Date.UTC(2016, 8, 1), 6], ] },
            { name: "Senior Data Scientist",    lineWidth: 10, data: [ [Date.UTC(2016, 9, 1), 7], [Date.UTC(new Date().getFullYear(),  new Date().getMonth(), 1), 7], ]}
        ]
    };

    chart = new Highcharts.Chart(plot_options_timeline);

});
