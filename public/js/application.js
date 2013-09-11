$(document).ready(function() {

  $('form').submit(function(event){
    event.preventDefault();
    $('p.error').hide();
    var tweet = {};
    tweet.tweet = $('.tweet-input').val();

    // disable the form
    $('.tweet-input').prop('disabled', true);
    $('.tweet-button').prop('disabled', true);

    // append a message
    $('form').append('<p class="wait">You tweet is being sent!</p>');

    $.ajax({
      type: "POST",
      url: '/tweet',
      data: tweet,
      success: function(success){
        $('body').html(success);
      }
    });
  });
});
