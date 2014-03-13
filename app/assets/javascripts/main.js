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
  $('.sit-teaser-block .block-content').click( function() {
    Turbolinks.visit($(this).find('.sit-link').attr('href'));
  });
  // Search results
  $('.sit-teaser').click( function() {
    Turbolinks.visit($(this).find('.sit-link').attr('href'));
  });
  // Recent activity
  $('.recent-activity .activity').click( function() {
    Turbolinks.visit($(this).find('.sit-link').attr('href'));
  });

  // NEW/EDIT SIT / title or duration
  $('.sit_type input').click( function() {
    if ($(this).attr('id') == 'sit_s_type_0') {
      $('.new-sit-title').hide();
    } else {
      $('.new-sit-title').fadeIn();
    }
  });

  if ($('.sit_type .diary_type').is(':checked')) {
    $('.new-sit-title').show();
  };

  // Privacy dropdown
  $('.new-sit .dropdown-menu').click(function(e) {
      e.stopPropagation();
  });
  $('.edit-sit .dropdown-menu').click(function(e) {
      e.stopPropagation();
  });

  // Old datepicker config - keep in case we revert
  // $('[data-behaviour~=datepicker]').datepicker({
  //   format: 'yyyy-mm-dd',
  //   changeMonth: true,
  //   changeYear: true,
  //   autoclose: true,
  // });

  $('#datetimepicker').datetimepicker({
    autoclose: true,
  });

  $(".chzn-select").chosen({max_selected_options: 1});

  // FAVOURITES / add and remove
  $('#favourite_button').on('click', '.toggle-favourite', function(e) {
    e.preventDefault();
    $(this).closest('form').submit();
  });

  // VIEW SIT / Likers list
  $('#likers-list').click( function(event){
    return false;
  });
  $('#likers-list').popover({
    animation: true,
    html: true,
    trigger: 'click',
  });

  // LIKES / a sit
  $('#like_button').on('click', '.toggle-like', function(e) {
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

  // MASONRY
  if ($('.page-content.me .sit-container').length) {
    var container = document.querySelector('.sit-container');
    var msnry = new Masonry( container, {
      columnWidth: '.col-md-3',
      itemSelector: '.tile',
      stamp: ".stamp"
    });
  }

  if ($('.page-content.favourites').length) {
    var container = document.querySelector('.sit-container');
    var msnry = new Masonry( container, {
      columnWidth: '.col-md-3',
      itemSelector: '.tile',
      stamp: ".stamp"
    });
  }

  if ($('.page-content.explore').length) {
    var container = document.querySelector('.sit-container');
    var msnry = new Masonry( container, {
      columnWidth: '.col-md-3',
      itemSelector: '.tile',
      stamp: ".stamp"
    });
  }

  if ($('.front-page').length) {
    var container = document.querySelector('.sit-container');
    var msnry = new Masonry( container, {
      columnWidth: '.col-md-2',
      itemSelector: '.tile',
      stamp: ".stamp",
    });
  }

  if ($('.view-user').length) {
    var container = document.querySelector('.sit-container');
    var msnry = new Masonry( container, {
      columnWidth: '.col-md-4',
      itemSelector: '.tile',
      stamp: ".stamp",
    });
  }

  if ($('.view-tag').length) {
    var container = document.querySelector('.sit-container');
    var msnry = new Masonry( container, {
      columnWidth: '.col-md-3',
      itemSelector: '.tile',
      stamp: ".stamp",
    });
  }

  (function() {
        var shr = document.createElement('script');
        shr.setAttribute('data-cfasync', 'false');
        shr.src = '//dsms0mj1bbhn4.cloudfront.net/assets/pub/shareaholic.js';
        shr.type = 'text/javascript'; shr.async = 'true';
        shr.onload = shr.onreadystatechange = function() {
          var rs = this.readyState;
          if (rs && rs != 'complete' && rs != 'loaded') return;
          var site_id = '3a20bcc88a931fb230f2bf39a6410dc6';
          try { Shareaholic.init(site_id); } catch (e) {}
        };
        var s = document.getElementsByTagName('script')[0];
        s.parentNode.insertBefore(shr, s);
      })();
});

// Loading indicator
$(document).on('page:fetch', function() {
  $(".loading-indicator").show();
});

$(document).on('page:change', function() {
  $(".loading-indicator").hide();
});
