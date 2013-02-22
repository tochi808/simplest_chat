// Generated by CoffeeScript 1.4.0
/*
Module dependencies.
*/

var app, assets, express, flash, http, localStrategy, models, passport, path, routes, user;

express = require("express");

routes = require("./routes");

user = require("./routes/user");

http = require("http");

path = require("path");

assets = require("connect-assets");

flash = require("connect-flash");

passport = require('passport');

localStrategy = require('passport-local').Strategy;

models = require('./models');

app = express();

passport.serializeUser(function(user, done) {
  return done(null, user.id);
});

passport.deserializeUser(function(id, done) {
  var _this = this;
  return models.User.findById(id, function(err, user) {
    return done(err, user);
  });
});

passport.use(new localStrategy(function(username, password, done) {
  return models.User.findOne({
    name: username
  }, function(err, user) {
    if (err) {
      return done(err);
    }
    if (!user) {
      return done(null, false, {
        message: "ユーザー名かパスワードが不正です"
      });
    }
    if (!user.validatePassword(password)) {
      return done(null, false, {
        message: "ユーザー名かパスワードが不正です"
      });
    }
    return done(null, user);
  });
}));

app.configure(function() {
  app.set("port", process.env.PORT || 3000);
  app.set("views", path.join(__dirname, "../views"));
  app.set("view engine", "jade");
  app.use(express.favicon());
  app.use(express.logger("dev"));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser("your secret here"));
  app.use(express.session());
  app.use(flash());
  app.use(passport.initialize());
  app.use(passport.session());
  app.use(app.router);
  app.use(assets());
  return app.use(express["static"](path.join(__dirname, "../public")));
});

app.configure("development", function() {
  return app.use(express.errorHandler());
});

app.get("/", routes.index);

app.get("/login", routes.login);

app.post("/login", passport.authenticate('local', {
  successRedirect: '/',
  failureRedirect: '/login',
  failureFlash: true
}));

app.get("/logout", routes.logout);

http.createServer(app).listen(app.get("port"), function() {
  return console.log("Express server listening on port " + app.get("port"));
});