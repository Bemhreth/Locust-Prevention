
const mongoose = require("mongoose");

const Schema = mongoose.Schema;


let user = new Schema({
    name : String,
    place : String,
    phone : String,
  });

let report = new Schema({
    location : String,
    name : String,
    phone : String,
    modeldata : String

})

  
const model1 = mongoose.model("user", user);
const model2 = mongoose.model("report" , report)

module.exports = {
    user: model1,
    report: model2
  }



