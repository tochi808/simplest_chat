window.SimplestChat ||= {}

socket = io.connect('http://localhost')

socket.on 'connect', ()->
  name = $('#username').val()
  socket.emit 'introduce', name: name

socket.on 'some one has come', (data)->
  name = data.name
  console.log name
  $('li.' + name).append $('<i>').attr("class", "icon-user")


