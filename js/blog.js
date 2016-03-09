$(document).ready(function() {
  
  /* activate jquery isotope */
  var $container = $('#posts').isotope({
    itemSelector : '.item',
    isFitWidth: true
  });
  
  /*
  $(window).smartresize(function(){
    $container.isotope({
      columnWidth: '.col-md-3'
    });
  });

  $container.isotope({ filter: '*' });
  
  */

  var filter = function(){
    
    $container.isotope({ filter: function() {
      
      
      var name = $(this).find('.name').text().toLowerCase();
      var category = $(this).find('.category').text().toLowerCase();
    
      var search_box = $("#search_box").val().toLowerCase();
      var category_filter = $("#category_filter").val().toLowerCase();
      
      console.log(search_box, category_filter);
  
      if(category_filter == "all"){
        return name.match(search_box);
      } else {
        return name.match(search_box) && (category == category_filter);  
      }
      
    }});
    
  };
  
  $("#search_box").keyup(filter);
  
  $("#category_filter").change(filter);

});
