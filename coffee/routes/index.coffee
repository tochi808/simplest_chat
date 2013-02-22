module.exports = (models)->
  User = models.User

  return {
    index: (req, res) ->
      unless req.user 
        req.flash 'error', 'not authorized'
        res.redirect '/login'
        return

      console.log req.user

      User.findExceptMyself req.user.id, (err, users)->
        res.render "index",
          title: "Simplest Chat"
          username: req.user.name
          users: users 

    login: (req, res) ->
      res.redirect '/' if req.user
      
      res.render "login",
        title: "Simplest Chat!"
        errors: req.flash 'error'

    logout: (req, res) ->
      User.findById req.user.id, (err, user)->
        user.signed_in = false

        user.save (err, user)->
          req.logout()
          res.redirect 'login'
  }
