mongoose = require('mongoose')
db = mongoose.connect('mongodb://localhost/simplest-chat')
Schema = db.Schema

UserSchema = new Schema
  name: String
  password: String

UserSchema.methods.validatePassword = (password)->
  return this.password == password

module.exports.User = mongoose.model 'User', UserSchema
