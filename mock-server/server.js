const jsonServer = require("json-server");
const server = jsonServer.create();
const router = jsonServer.router("db.json");
const jsonTasks = require("./db.json");
const {tasks} = JSON.parse(JSON.stringify(jsonTasks));
const middlewares = jsonServer.defaults();

server.use(jsonServer.bodyParser);
server.use(middlewares);

server.use((req, res) => {

 const identifier = req.path.replace('/tasks/', '')

  if(identifier == "err500/err500") {
    res.status(500).json({ code: 500, details: "error_500" });
    return;
  }

  const task = tasks.map((taskObj) => {
      if (taskObj[identifier]) {
          return taskObj[identifier];
      }
  })[0];

  if(!task) {
    res.status(404).json({ code: 404, details: "error_404_not_found" });
    return;
  }
  
  res.status(200).json({ ...task });
  return;
});

server.use(router);

server.listen(3000, () => {
  console.log("JSON Server is running");
});