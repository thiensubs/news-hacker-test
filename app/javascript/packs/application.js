// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("channels")
require('jquery/dist/jquery')
require('bootstrap/dist/js/bootstrap')
require('packs/pace')
import "src/home.scss";
import "src/pace.scss";
import "src/water.sass";
import $ from 'jquery';
import "bootstrap/dist/css/bootstrap.css";

Pace.paceOptions = {
  // Disable the 'elements' source
  elements: false,

  // Only show the progress on regular and ajax-y page navigation,
  // not every request
  restartOnRequestAfter: false,
  restartOnPushState: false
}
$(document).on('turbolinks:load', function() {
  $('body').tooltip({
    selector: '[data-toggle="tooltip"]',
    container: 'body',
  });

  $('body').popover({
    selector: '[data-toggle="popover"]',
    container: 'body',
    html: true,
    trigger: 'hover',
  });
  $('#button_load_more').click(function(e) {
    $(this).prop("disabled",true);
    $('.wrap').show();
    var next_page;
    next_page=parseInt($('#button_load_more').data().page)+1;
    $.ajax({
      type: "GET",
      url: '/',
      data: {page: next_page, channel_id: $('#contents_news').data().job_id},
      async: false,
      success: function(data) {
      }
    });
  });
});

$( document ).ready(function() {
  $('.wrap').hide();
})
// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
