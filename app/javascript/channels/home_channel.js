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
          {
            $('#contents_news').append(data.data);
            $('#button_load_more').data("page", data.page);
            if (typeof data.id !== 'undefined'){
              $('#modal-body-'+data.id).html(data.data.table.content);
              if (data.data.table.image_meta === null)
              {
                $('#'+data.id).attr("src", "https://loremflickr.com/320/240?lock=1");
                
              }
              else
              {
                $('#'+data.id).attr("src", data.data.table.image_meta);
                var img_temp = $('<img src="'+data.data.table.image_meta+'" width="100%" alt="Image of news" class="text-center">')
                $('#modal-body-'+data.id).prepend(img_temp);
              }
                
            }
          }
          else
            $('#contents_news').html(data.data);
          $('.wrap').hide();
          $('#button_load_more').show();
          $('#button_load_more').prop("disabled",false);

        }
        // Called when there's incoming data on the websocket for this channel
      },
    });
  }
});