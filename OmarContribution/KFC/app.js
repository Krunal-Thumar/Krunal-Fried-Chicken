const express = require('express');
const path = require('path');
const mysql = require('mysql2');  // Import MySQL module
const app = express();
const PORT = 3000;

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));  // Ensure the 'views' folder is correctly configured

const session = require('express-session');

app.use(session({
    secret: 'yourSecretKey',
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false }  // Use `true` for HTTPS
}));


app.use(express.static(path.join(__dirname, 'public')));
app.use(express.urlencoded({ extended: true }));

// Connect to MariaDB (MySQL)
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'root',
    database: 'krunal_fried_chicken_db'
});

db.connect((err) => {
    if (err) {
        console.error('Database connection failed: ' + err.stack);
        return;
    }
    console.log('Connected to database.');
});

// Set up routes
const routes = require('./routes/routes')(db);  // Pass the db connection to routes
app.use('/', require('./routes/routes')(db));  // Correctly link your routes

app.listen(PORT, () => {
    console.log(`Server running  on http://localhost:${PORT}`);
});