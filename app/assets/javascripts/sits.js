jQuery(document).ready(function($) {
  // $('.sit-teaser').click(function() {
  //   window.location=$(this).find("a.sit-link").attr("href");
  //   return false;
  // })

  $('.new-sit .radio_buttons input').click(function(){
    // If the 'sit' button was pressed
    if($(this).attr('id') == 'sit_s_type_0'){
      // Show the duration if 'sit' is selected
      $('.new-sit-title').hide();
      $('.new-sit-duration').fadeIn();
    }else{
      $('.new-sit-duration').hide();
      $('.new-sit-title').fadeIn();
    }
  });

});