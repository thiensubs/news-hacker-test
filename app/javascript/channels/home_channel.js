import consumer from "./consumer"
$(document).on('turbolinks:load',function(){
  if ($('#contents_news').length) {
    consumer.subscriptions.create({channel: "HomeChannel", job_id: $('#contents_news').data().job_id}, {
      connected() {
        $('.wrap').show();
        // Called when the subscription is ready for use on the server
        console.log('connected~~');
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        if (data)
        {
          if (Object.keys(data).length>2)
            $('#contents_news').append(data.data);
          else
            $('#contents_news').html(data.data);
          $('.wrap').hide();
          $('#button_load_more').prop("disabled",false);
        }
        // Called when there's incoming data on the websocket for this channel
      },
    });
  }
});