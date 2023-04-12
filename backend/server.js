const express = require('express');
const cors = require('cors');
const colors = require('colors');
const dotenv = require('dotenv').config();
const { errorHandler } = require('./middleware/errorMiddleware');
const connectDB = require('./config/db');
const port = process.env.PORT || 3000;

connectDB();

const app = express();

app.use(cors({
    origin: '*', // allow to server to accept request from different origin
}));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.use('/api/notes', require('./routes/noteRoutes'));
app.use('/api/users', require('./routes/userRoutes'));
app.use('/api/tags', require('./routes/tagRoutes'));

app.use(errorHandler);

app.listen(port, () => console.log(`Server is running on port ${port}`));
