module.exports = (models)->
  User = models.User

  return {
    index: (req, res) ->
      unless req.user 
        req.flash 'error', 'not authorized'
        res.redirect '/login'
        return

      User.findExceptMyself req.user.id, (err, users)->
        res.render "index",
          title: "Simplest Chat"
          users: users 

    login: (req, res) ->
      res.redirect '/' if req.user
      
      res.render "login",
        title: "Simplest Chat!"
        errors: req.flash 'error'

    logout: (req, res) ->
      req.logout()
      res.redirect 'login'
  }
