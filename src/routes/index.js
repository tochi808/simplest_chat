// Generated by CoffeeScript 1.4.0

module.exports = function(models) {
  var User;
  User = models.User;
  return {
    index: function(req, res) {
      if (!req.user) {
        req.flash('error', 'not authorized');
        res.redirect('/login');
        return;
      }
      console.log(req.user);
      return User.findExceptMyself(req.user.id, function(err, users) {
        return res.render("index", {
          title: "Simplest Chat",
          username: req.user.name,
          users: users
        });
      });
    },
    login: function(req, res) {
      if (req.user) {
        res.redirect('/');
      }
      return res.render("login", {
        title: "Simplest Chat!",
        errors: req.flash('error')
      });
    },
    logout: function(req, res) {
      return User.findById(req.user.id, function(err, user) {
        user.signed_in = false;
        return user.save(function(err, user) {
          req.logout();
          return res.redirect('login');
        });
      });
    }
  };
};
