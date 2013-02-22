window.SimplestChat ||= {}

socket = io.connect('http://localhost')

socket.on 'connected', (data)->
  _.each data.client_names , (name)->
    lis = $('li.onamae')
    _.each lis , (li)->
      $li = $(li)
      if $li.hasClass(name)
        $li.children('.icon-user:first').show()
        #should break loop

  socket.emit 'introduce', name: $('#username').val()

socket.on 'some one connected', (data)->
  console.log data.name + ' has connected'
  $('li.' + data.name).children('.icon-user:first').show()

socket.on 'some one disconnected', (data)->
  console.log data.name + ' has disconnected'
  $('li.' + data.name).children('.icon-user:first').hide()

