
###
Module dependencies.
###
express = require("express")
models = require('./models')
routes = require("./routes")(models)
user = require("./routes/user")
http = require("http")
path = require("path")
assets = require("connect-assets")
flash = require("connect-flash")
passport = require('passport')
localStrategy = require('passport-local').Strategy
app = express()

passport.serializeUser (user, done)->
  done(null, user.id);

passport.deserializeUser (id, done) ->
  models.User.findById id, (err, user)=>
    done(err, user);
    
passport.use new localStrategy (username, password, done)->
  models.User.findOne name: username, (err, user)->
    if err 
      return done(err)
    if !user
      return done null, false, {message: "ユーザー名かパスワードが不正です"}
    if !user.validatePassword(password)
      return done null, false, {message: "ユーザー名かパスワードが不正です"}

    return done(null, user)

app.configure ->
  app.set "port", process.env.PORT or 3000
  app.set "views", path.join( __dirname , "../views" )
  app.set "view engine", "jade"
  app.use express.favicon()
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser("your secret here")
  app.use express.session()
  app.use flash()
  app.use passport.initialize()
  app.use passport.session()
  app.use app.router
  app.use assets()
  app.use express.static(path.join(__dirname, "../public"))


app.configure "development", ->
  app.use express.errorHandler()


app.get "/", routes.index

app.get  "/login", routes.login
app.post "/login", passport.authenticate 'local',
  successRedirect: '/'
  failureRedirect: '/login'
  failureFlash: true

app.get "/logout", routes.logout



server = http.createServer(app)

io = require('socket.io').listen server
server.listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")

io.sockets.on 'connection', (socket)->
  socket.on 'introduce', (data)->
    socket.set 'name', data.name, ()->
      models.User.findOne name: data.name, (err, user)->
        user.connected = true
        user.save (err, user)->
          socket.broadcast.emit 'some one has come', name: data.name 

  socket.on 'disconnect', (data)->
    socket.get 'name', (err, name)->
      models.User.findOne name: name, (err, user)->
        user.connected = false 
        user.save (err, user)->
          console.log 'disconnected!!!'


