(function($){
   function strEndsWith(str, t, i) {
    if (i==false) {
      return (t == this.substring(this.length - t.length));
    } else {
      return (t.toLowerCase() == this.substring(this.length - t.length).toLowerCase());
    }
  }
  
  // Based on http://www.germanforblack.com/javascript-sleeping-keypress-delays-and-bashing-bad-articles  
  function only_every(func, millisecond_delay) {
    if (!window.only_every_func)
    {
      var function_object = func;
      window.only_every_func = setTimeout(function() { function_object(); window.only_every_func = null}, millisecond_delay);
     }
  }
  
  $(function() { // onload
    var comment_form = $('#new_comment')
    var input_elements = comment_form.find(':text, textarea')
    var fetch_comment_preview = function() {
      var dest = window.location.href;
      dest = dest.split('#')[0];
      dest = dest.split('?')[0];

      if (strEndsWith(dest, 'comments'))
        dest += '/comments';

      jQuery.ajax({
        data: comment_form.serialize(),
        url:  dest + '/new',
        timeout: 2000,
        dataType: 'text/html',
        error: function() {
          if ($('#comment-preview').length == 0) {
            comment_form.after('<div id="comment-preview"></div>')
          }
          $('#comment-preview').text("Failed to submit");
        },
        success: function(r) {
          if ($('#comment-preview').length == 0) {
            comment_form.after('<h2>Your comment will look like this:</h2><div id="comment-preview"></div>')
          }
          $('#comment-preview').html(r)
        }
      })
    }

    input_elements.keyup(function () {
      only_every(fetch_comment_preview, 1000);
    })
    if (input_elements.any(function() { return $(this).val().length > 0 }))
      fetch_comment_preview();
  })
  
})(jQuery);

