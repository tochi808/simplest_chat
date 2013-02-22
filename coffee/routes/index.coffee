
#
# * GET home page.
# 
exports.index = (req, res) ->
  res.render "index",
    title: "Simplest Chat"

exports.login = (req, res) ->
  res.redirect '/' if req.user
  
  res.render "login",
    title: "Simplest Chat!"
    errors: req.flash 'error'

exports.logout = (req, res) ->
  req.logout()
  res.redirect 'login'
