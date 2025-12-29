const express = require('express');
const cors = require('cors');
require('dotenv').config();
const routes = require('./api/routes/routes.js');
const connectDB = require('./api/config/mongodb.js');

const app = express();


connectDB();


app.use(cors());
app.use(express.json());

app.use('/', routes);

module.exports = app;