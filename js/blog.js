$(function(){
  
  $('#grid').isotope({
    itemSelector: '.grid-item',
    masonry: {
      columnWidth: 50,
      isFitWidth: true
    }
  });
  
  var filter = function(){
    $('#grid').isotope({ filter: function() {
      var name = $(this).find('.name').text().toLowerCase();
      var category = $(this).find('.category').text().toLowerCase();
    
      var search_box = $("#search_box").val().toLowerCase();
      var category_filter = $("#category_filter").val().toLowerCase();

      if(category_filter == "all"){
        return name.match(search_box);
      } else {
        return name.match(search_box) && (category == category_filter);  
      }
    
    }})
    
  }
  
  $("#search_box").keyup(filter);
  
  $("#category_filter").change(filter);
  
});
