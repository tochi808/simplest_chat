mongoose = require('mongoose')
db = mongoose.connect('mongodb://localhost/simplest-chat')
Schema = db.Schema

UserSchema = new Schema
  name    : String
  password: String

UserSchema.methods.validatePassword = (password)->
  return this.password == password

UserSchema.statics.findExceptMyself = (my_id, cb)->
  this.where('_id').ne(my_id).exec cb


module.exports.User = mongoose.model 'User', UserSchema
