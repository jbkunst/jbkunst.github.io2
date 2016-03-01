(function() {
  
  /* ----------------------------------------------------------------------- */
  /* https://www.google.com/design/spec/style/color.html#color-color-palette */ 
  time = 10000;
  
  function change_color(){

    colors = [ //900
      "#B71C1C",  // red
      "#4A148C",  // purlple
      "#1A237E",  // indigo
      "#0D47A1",  // blue
      "#004D40",  // teal
      "#212121",  // gray
      "#1FA67A"   // FontAwesome color
      ];
      
    var rand = Math.floor(Math.random() * colors.length);
    var col900 = colors[rand];
  
    d3.selectAll("header")
      .transition().duration(time/4)
      .style({"background-color": col900});
    
    d3.selectAll("table th")
      .transition().duration(time/4)
      .style({"border-bottom": "2px solid " + col900});
      
    d3.selectAll("wrapper a")
      .transition().duration(time/4)
      .style({"color": col900});
      
    d3.select("#theme-color").attr("content", col900);
      
  }
  
  change_color();
  
  d3.select("body")
    .transition().delay(time/16).duration(time/16)
    .style({"opacity": 1});
      
  setInterval(function(){ change_color() }, 2*time);
  
  /* -----------------------------------------------------------------*/
  /* http://stackoverflow.com/questions/9877263/time-delayed-redirect */
  $(".internallink").click(function (e) {
    e.preventDefault(); //will stop the link href to call the blog page
    d3.select("body")
      .transition().duration(time/16)
      .style({"opacity": 0});
    var go_to = this.href;
    console.log(go_to);
    setTimeout(function () {
      window.location.href = go_to; //will redirect to your blog page (an ex: blog.html)
    }, time/16); //will call the function after 2 secs.
  });
  
})();
