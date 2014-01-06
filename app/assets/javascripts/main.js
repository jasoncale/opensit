$(document).ready(function(){
  $.each($('.rich-textarea'), function(index, el){
    $(el).wysihtml5({
      "font-styles": false, //Font styling, e.g. h1, h2, etc. Default true
      "emphasis": true, //Italics, bold, etc. Default true
      "lists": true, //(Un)ordered lists, e.g. Bullets, Numbers. Default true
      "html": false, //Button which allows you to edit the generated HTML. Default false
      "link": true, //Button to insert a link. Default true
      "image": false, //Button to insert an image. Default true,
      "color": false //Button to change color of font
    });
  });

  // SIT TEASER / Click through
  $('.sit-teaser').click( function() {
    Turbolinks.visit($(this).find('.sit-link').attr('href'));
  });

  // NEW/EDIT SIT / title or duration
  $('.sit_type.radio_buttons input').click( function() {
    if ($(this).attr('id') == 'sit_s_type_0') {
      $('.new-sit-title').hide();
    } else {
      $('.new-sit-title').fadeIn();
    }
  });

  if ($('.sit_type.radio_buttons .diary_type').is(':checked')) {
    $('.new-sit-title').show();
  };

  // Privacy dropdown
  $('.new-sit .dropdown-menu').click(function(e) {
      e.stopPropagation();
  });
  $('.edit-sit .dropdown-menu').click(function(e) {
      e.stopPropagation();
  });

  $( ".datepicker" ).datepicker({
    dateFormat: 'yy-mm-dd', 
    changeMonth: true,
    changeYear: true
  });

  $(".chzn-select").chosen({max_selected_options: 1});

  // FAVOURITES / add and remove
  $('#favourite_button').on('click', '.toggle-favourite', function(e) {
    e.preventDefault();
    $(this).closest('form').submit();
  });

  // EDIT PROFILE / private stream warning
  $('.edit-profile .private-stream input').click( function() {
    if ($(this).is(':checked')) {
      $('.private-stream-warning-unticked').hide();
      $('.private-stream-warning-ticked').show();
    } else {
      $('.private-stream-warning-ticked').hide();
      $('.private-stream-warning-unticked').show();
    }
  });
});

// Loading indicator and Google Analytics
$(document).on('page:fetch', function() {
  $(".loading-indicator").show();
});

$(document).on('page:change', function() {
  $(".loading-indicator").hide();
});