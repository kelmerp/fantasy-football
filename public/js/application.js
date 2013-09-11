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
    // $('form').append('<p class="wait">You tweet is being sent!</p>');
    // $('form').append('<img src="./images/wait.gif" />')

    $.ajax({
      type: "POST",
      url: '/tweet',
      data: tweet,
      dataType: "json",
      success: function(job_id){
        // console.log("this job id is",job_id.job_id)
        // $('body').html(success);
        setTimeout($.get('/status/'+job_id.job_id, function(job_status){
          window.location ="/";
          if (job_status.job_status)
            alert("Your tweet has been sent!");
        },"json"), 3000);
      }
    });
  });
});
