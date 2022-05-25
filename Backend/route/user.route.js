const router = require("express").Router();
const userController = require("../controller/user.controller");
const bodyParser = require("body-parser");
const express = require("express");
const jwt = require("jsonwebtoken");

router.get("/home", userController.getUserData);
router.get("/:id", userController.getUser);

router.post("/signup", express.urlencoded(), userController.createUser);
router.post("/edit/:id", express.urlencoded(), userController.updateUser);
router.post("/delete/:id", userController.deleteUser);
router.post("/login", express.urlencoded(), userController.login);
router.get("/", userController.getUsers);

module.exports = router;
