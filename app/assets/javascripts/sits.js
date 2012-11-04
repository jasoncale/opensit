jQuery(document).ready(function($) {
  // $('.sit-teaser').click(function() {
  //   window.location=$(this).find("a.sit-link").attr("href");
  //   return false;
  // })

  $('.new-sit .radio_buttons input').click(function(){
    // If the 'sit' button was pressed
    if($(this).attr('id') == 'sit_s_type_0'){
      // Hide the title and show the duration selector
      $('.new-sit-title').hide();
      $('.new-sit-duration').show();
    }else{
      $(".new-sit-title").show();
      $('.new-sit-duration').hide();
    }
  });

});