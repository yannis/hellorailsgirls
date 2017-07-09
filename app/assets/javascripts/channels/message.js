App.messages = App.cable.subscriptions.create("MessageChannel", {
  connected: function() {
    console.log('connected');
  },

  disconnected: function() {},

  received: function(data) {
    let title = $("<div class='carousel-item'></div>");
    titleh1 = $('<h1></h1>');
    titleh1.append('Hello ' + data.name + '!');
    title.append(titleh1)
    $('.carousel-item.active').after(title);

    let message = $('<blockquote class="blockquote" style="display: none;"></blockquote>');
    message.append('<p>' + data.message + '</p>');
    message.append('<footer class="blockquote-footer">' + data.name + '</footer>');
    $('#messages').prepend(message);
    message.fadeIn();
  }
});
