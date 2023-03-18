const express = require('express');
const dotenv = require('dotenv').config();
const { errorHandler } = require('./middleware/errorMiddleware');
const port = process.env.PORT || 3000;

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.use('/api/notes', require('./routes/noteRoutes'));

app.use(errorHandler);

app.listen(port, () => console.log(`Server is running on port ${port}`));
