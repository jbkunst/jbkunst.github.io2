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
            { name: "Senior Scoring Analyst",   lineWidth: 10, data: [ [Date.UTC(2014, 8, 1), 6], [Date.UTC(new Date().getFullYear(),  new Date().getMonth(), 1), 6], ]}
        ]
    };

    chart = new Highcharts.Chart(plot_options_timeline);

// Wordcloud
    var fill = d3.scale.category20();
    var width = parseInt($("#container3").css("width"));
    var height = parseInt($("#container3").css("height"));

    var words = [
      {text: "R", size: 25}, {text: "Statistics", size: 20},
      {text: "D3JS", size: 25}, {text: "Javascript", size: 25},
      {text: "Python", size: 20}, {text: "Modelling", size: 20},
      {text: "Visualization", size: 20}, {text: "Github", size: 20},
      {text: "Django", size: 20}, {text: "Arduino", size: 20},
      {text: "Guitar", size: 20}, {text: "Music", size: 20},
      {text: "Programming", size: 20}, {text: "The smell of freshly-cut grass", size: 10},
      {text: "I don't like wordclouds", size: 10}, {text: "Predictions", size: 20},
      {text: "Data", size: 25}, {text: "Domotic", size: 20},
      {text: "Shiny", size: 20}, {text: "dplyr", size: 20},
      {text: "RStudio", size: 20}, {text: "", size: 20},
      {text: "", size: 20}, {text: "", size: 20},
      {text: "", size: 20}, {text: "", size: 20},
      {text: "", size: 20}, {text: "", size: 20}];

    d3.layout.cloud().size([width, height])
        .words(words)
        .padding(5)
        .rotate(function() { return Math.floor(Math.random() * 120) + 1 - 60; })
        //.rotate(function() { return ~~(Math.random() * 2) * 90; })
        //.rotate(function() { return 0; })
        .font("Lato")
        .fontSize(function(d) { return d.size; })
        .on("end", draw)
        .start();

    function draw(words) {
        d3.select("#container3").append("svg")
                .attr("width", width)
                .attr("height", height)
            .append("g")
                .attr("transform", "translate("+ width/2 +","+ height/2+")")
            .selectAll("text")
                .data(words)
            .enter().append("text")
            .style("font-size", function(d) { return d.size + "px"; })
            .style("font-family", 'Lato')
            .style("fill", function(d, i) { return fill(i); })
            .attr("text-anchor", "middle")
            .attr("transform", function(d) {
                return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
            })
            .text(function(d) { return d.text; });
        }

});
