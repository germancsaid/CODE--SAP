import passport from 'passport';
import { Strategy as LocalStrategy } from 'passport-local';
import bcrypt from 'bcrypt';

import player from "../models/player";

//serialization
passport.serializeUser((newUser, done) => {
  done(null, newUser._id);
});

passport.deserializeUser(async (id, done) => {
  const user = await player.findById(id);
  done(null, user);
});

//signup
passport.use('local-signup', new LocalStrategy({
  usernameField: 'email',
  passwordField: 'password',
  passReqToCallback: true
}, async (req, email, password, done) => {
  const user = await player.findOne({'Email': email})
  console.log(user)
  if(user) {
    return done(null, false, {message:'The Email is already Taken.'});
  } else {
    const newUser = new player();
    newUser.Email = email

    const hashedPassword = await bcrypt.hash(password, 10)
    newUser.Password = hashedPassword
    newUser.PlayerName = req.body.name;
    
    console.log(newUser);
    await newUser.save();
    done(null, newUser);
  }
}));

//signin
passport.use('local-signin', new LocalStrategy({
  usernameField: 'email',
  passwordField: 'password',
  passReqToCallback: true
}, async (req, email, password, done) => {
  const user = await player.findOne({Email: email});
  if(!user) {
    return done(null, false, {message: 'No User Found'});
  }
  if(!bcrypt.compareSync(password, user.Password)) {
    return done(null, false, {message:'Incorrect Password'});
  }
  return done(null, user);
}));