const mysql = require("mysql");
const express = require("express");
const jwt = require("jsonwebtoken");
const crypto = require("crypto");
const dotenv = require("dotenv");
const bodyParser = require("body-parser");
const connection = require("mysql/lib/Connection");
const { process_params } = require("express/lib/router");
const { promises } = require("stream");
const { resolve } = require("path");
const app = express();
const KEY = "m yincredibl y(!!1!11!)<'SECRET>)Key'!";
var currID;
dotenv.config({ path: "./.env" });
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

const pool = mysql.createPool({
  connectionLimit: 10,
  host: "localhost",
  user: "KUSAI",
  password: "KUSAI",
  database: "fooddeliverydb",
});
exports.getUsers = async () => {
  console.log("hdsoksj");
  try {
    const response = await new Promise((resolve, reject) => {
      pool.query("SELECT * from users", (err, rows) => {
        if (!err) {
          console.log(rows);
          resolve(rows);
        } else {
          console.log(err);
          reject(err);
        }
      });
    });

    return response;
  } catch (err) {
    console.log(err);
  }
};

exports.getUser = async (id) => {
  try {
    const response = await new Promise((resolve, reject) => {
      pool.query("SELECT * FROM users WHERE id = ?", [id], (err, rows) => {
        if (!err) {
          console.log(rows);

          resolve(rows);
        } else {
          console.log(err);
          reject(err);
        }
      });
    });
    return response;
  } catch (err) {
    console.log(err);
  }
};

exports.createUser = async (user) => {
  var rowCount = 0;
  console.log(user.name);
  var password = crypto
    .createHash("sha256")
    .update(user.pw)
    .digest("hex")
    .substring(0, 31);
  try {
    const response = await new Promise((resolve, reject) => {
      pool.query(
        "SELECT * FROM users WHERE name = ?",
        [user.name],
        (err, rows) => {
          if (err) {
            console.log(err);
            reject(err);
          } else if (rows.length != 0) {
            console.error("can't create user " + user.name);
            resolve("A user with that username already exists");
          } else {
            console.log("Can create user " + user.name);
            pool.query(
              "INSERT INTO users(name, pw, email) VALUES (?, ?, ?)",
              [user.name, password, user.email],
              (err, rows) => {
                if (err) reject(new Error(err.message));
                resolve("user created");
              }
            );
          }

          console.log("The data from users table are: \n", rows);
          rowCount = rows.length;
        }
      );
    });
    return [response, rowCount];
  } catch (err) {
    console.log(err);
  }
};

exports.updateUser = async (info) => {
  console.log(info.id);
  console.log(info.name);
  console.log(info.pw);

  try {
    const response = await new Promise((resolve, reject) => {
      const query = `
                          UPDATE users
                          SET
                              name = COALESCE(?,name),
                              pw =  COALESCE(?,pw)       
                          WHERE id= ?
                         `;
      pool.query(query, [info.name, info.pw, info.id], (err, results) => {
        if (err) reject(new Error(err.message));
        resolve(results);
      });
    });
    return response;
  } catch (err) {
    console.log(err);
  }
};

exports.deleteUser = async (id) => {
  try {
    const response = await new Promise((resolve, reject) => {
      const query = `
                      delete from users 
                      where id = ?;
                         `;
      pool.query(query, id, (err, results) => {
        if (err) reject(new Error(err.message));
        resolve(results);
      });
    });
    return response;
  } catch (err) {
    console.log(err);
  }
};

exports.login = async (info) => {
  console.log("name and pw");
  console.log(info.name, info.pw);
  var password = crypto
    .createHash("sha256")
    .update(info.pw)
    .digest("hex")
    .substring(0, 31);
  console.log(password);
  try {
    const response = await new Promise((resolve, reject) => {
      pool.query(
        "SELECT * FROM users WHERE name = ? AND pw = ?",
        [info.name, password],
        // "select pw from users where name = ?",
        // [info.name],
        (err, row) => {
          if (err) {
            console.log(err);
            reject(new err(err.message));
          } else if (row.length != 0) {
            // console.log(row);
            var string = JSON.stringify(row);
            var jsonString = JSON.parse(string);
            userID = jsonString[0].id;
            console.log(row);

            var payload = {
              name: info.name,
            };

            var token = jwt.sign(payload, KEY, {
              algorithm: "HS256",
              expiresIn: "10m",
            });
            console.log(` exp ${token.expiresIn}`);
            console.log("Success");
            resolve(JSON.parse(`{"token":"${token}","id": ${userID}}`));
          } else {
            console.error("Failure");
            // res.status(401);
            resolve(err);
          }
        }
      );
    });
    console.log("response", response);
    currID = userID;
    console.log(`current id is ${currID}`);
    return response;
  } catch (err) {
    console.log(err);
  }
};

exports.getUserProfile = async (id) => {
  try {
    const response = await new Promise((resolve, reject) => {
      pool.query(
        "SELECT name, dob, email, origin, image, is_online FROM users WHERE id = ?",
        [id],
        (err, rows) => {
          if (!err) {
            console.log(rows);

            resolve(rows);
          } else {
            console.log(err);
            reject(err);
          }
        }
      );
    });
    return response;
  } catch (err) {
    console.log(err);
  }
};

exports.getCurrID = () => {
  console.log(`currID in function ${currID}`);
  return currID;
};

exports.findUSerType = async (id) => {
  if (id === this.getCurrID() && id != null) return "owner";
  // console.log(`id = ${id} currID = ${currID}`);
  try {
    const response = await new Promise((resolve, reject) => {
      pool.query(
        "SELECT * FROM Friends WHERE oneID =? AND twoID = ? OR(oneID =? AND twoID = ?)",
        [currID, id, id, currID],
        (err, rows) => {
          if (!err) {
            // console.log(`rows ${rows}`);
            if (rows.length != 0) resolve("friends");
          } else console.log(err);
          console.log("here");
          pool.query(
            "SELECT * FROM Request WHERE user_from = ? AND user_to = ?",
            [currID, id],
            (err, rows) => {
              if (!err) {
                if (rows.length != 0) resolve("req_sent");
              } else console.log(err);
              pool.query(
                "SELECT * FROM Request WHERE user_from = ? AND user_to = ?",
                [id, currID],
                (err, rows) => {
                  if (!err) {
                    if (rows.length != 0) resolve("req_received");
                  } else console.log(err);
                }
              );
            }
          );
        }
      );
    });
    return response;
  } catch (err) {
    console.log(err);
  }
};
