const express = require("express");
const app = express();
const bodyParser = require("body-parser");
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
const server = require("http").createServer(app);
const port = 3010 || process.env.port;

const userRouter = require("./route/user.route");
const profileRouter = require("./route/profile.route");

app.use("/", userRouter);
app.use("/profile", profileRouter);

const socketIO = require("socket.io");
const io = socketIO(server);
io.on("connection", (client) => {
  console.log("client connected, id: ", client.id);
  client.on("sendMsg", () => {
    client.broadcast.to("myRoom").emit("newMsg");
  });
  client.on("joinRoom", () => {
    client.join("myRoom");
  });
});

server.listen(port, "0.0.0.0", () => console.log(`listening on port ${port}`));
