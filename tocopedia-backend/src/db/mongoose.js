const mongoose = require("mongoose");

mongoose.set("strictQuery", false);
mongoose
  .connect(process.env.MONGODB_URL, {
    useNewUrlParser: true,
  })
  .then(() => console.log("connected to mongoDB"))
  .catch((e) => console.log(e));

module.exports = mongoose;
