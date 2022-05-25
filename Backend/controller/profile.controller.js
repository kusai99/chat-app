const userModel = require("../model/user.model");

/**
  1- user enters his profile
  2- the profile is a friends'
  3- user1 sent friend request to user2
  4- user1 has received friend request from user2
 */

exports.getProfile = (req, res, next) => {
  let id = req.params.id || userModel.getCurrID();
  console.log(userModel.getCurrID());
  if (id === null) {
    console.log("id is null");
  }

  userModel
    .getUserProfile(id)
    .then((results) => {
      res.send(results);
      userModel
        .findUSerType(id)
        .then((type) => {
          console.log(`type ${type}`);
        })
        .catch((err) => {
          console.log(err);
        });
    })
    .catch((err) => {
      console.log(err);
    });
};
