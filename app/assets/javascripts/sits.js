jQuery(document).ready(function($) {
  $('.sit-teaser').click(function() {
    window.location=$(this).find("a.sit-link").attr("href"); 
    return false;
  })

  $('.radio_buttons').click(function(){
    if ($(this).attr("id") == "sit_s_type_0")
    {
      $('.new-sit-title').hide();
      $('.new-sit-duration').show();
    } else {
      $(".new-sit-title").show();
      $('.new-sit-duration').hide();
    }
	    
	});
});