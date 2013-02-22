// Generated by CoffeeScript 1.4.0

exports.index = function(req, res) {
  return res.render("index", {
    title: "Simplest Chat"
  });
};

exports.login = function(req, res) {
  if (req.user) {
    res.redirect('/');
  }
  return res.render("login", {
    title: "Simplest Chat!",
    errors: req.flash('error')
  });
};

exports.logout = function(req, res) {
  req.logout();
  return res.redirect('login');
};
