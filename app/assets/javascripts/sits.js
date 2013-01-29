jQuery(document).ready(function($) {

  // NEW SIT / title or duration
  $('.new-sit .radio_buttons input').click( function() {
    if ($(this).attr('id') == 'sit_s_type_0') {
      // Show the duration if 'sit' is selected
      $('.new-sit-title').hide();
      $('.new-sit-duration').fadeIn();
    } else {
      $('.new-sit-duration').hide();
      $('.new-sit-title').fadeIn();
    }
  });

  // NEW SIT / datepicker
  $('.new-sit #datepicker').datepicker({
    format: 'yyyy-mm-dd',
    autoclose: true,
    language: 'en',
  });

  $(".chzn-select").chosen();

  // $.pjax('a', '#pjax-container');

});