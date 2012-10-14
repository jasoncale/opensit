jQuery(document).ready(function($) {
  $('.sit-teaser').click(function() {
    window.location=$(this).find("a.sit-link").attr("href"); 
    return false;
  })
});