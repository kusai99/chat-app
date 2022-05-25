const userModel = require("../model/user.model");
// const crypto = require("crypto");
const jwt = require("jsonwebtoken");
const KEY = "m yincredibl y(!!1!11!)<'SECRET>)Key'!";

exports.getUsers = (req, res, next) => {
  let users = userModel.getUsers();
  users.then((users) => {
    console.log(users);
    res.send(users);
  });
};

exports.getUser = (req, res, next) => {
  id = req.params.id;
  let user = userModel.getUser(id);
  user.then((user) => {
    console.log(user);
    res.send(user);
  });
};

exports.createUser = (req, res, next) => {
  let users = userModel.createUser(req.body);
  users.then((users) => {
    console.log(users);
    res.send(users);
  });
};

exports.updateUser = (req, res, next) => {
  if (req.body.name == "") req.body.name = null;
  if (req.body.pw == "") req.body.pw = null;

  userModel
    .updateUser({
      name: req.body.name,
      pw: req.body.pw,
      id: req.params.id,
    })
    .then((results) => {
      res.redirect(`/${req.params.id}`);
    })
    .catch((err) => {
      next(err);
    });
};

exports.deleteUser = (req, res, next) => {
  id = req.params.id;
  let result = userModel.deleteUser(id);
  result
    .then((results) => {
      console.log(results.affectedRows);
      res.redirect("/");
    })
    .catch((err) => {
      next(err);
    });
};

exports.login = (req, res, next) => {
  console.log(req.body.name + " attempted login");
  if (req.body.name == "") req.body.name = null;
  if (req.body.pw == "") req.body.pw = null;
  userModel
    .login({
      name: req.body.name,
      pw: req.body.pw, // change to password
    })
    .then((results) => {
      res.send(results);
      console.log(results);
    })
    .catch((err) => {
      console.log(err);
    });
};

exports.getUserData = (req, res, next) => {
  console.log("inside getUserData");
  var str = req.get("Authorization");
  console.log(`auth ${str}`);
  try {
    jwt.verify(str, KEY, { algorithm: "HS256" });
    res.send("user data");
  } catch {
    res.status(401);
    res.send("Bad Token");
  }
};
