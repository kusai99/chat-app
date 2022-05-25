const router = require("express").Router();

const profileController = require("../controller/profile.controller.js");
// router.get("/my-profile", profileController.getProfile);
router.get("/:id", profileController.getProfile);

module.exports = router;
