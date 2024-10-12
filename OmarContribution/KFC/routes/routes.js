module.exports = (db) => {
    const express = require('express');
    const bcrypt = require('bcrypt');  // For hashing passwords
    const router = express.Router();

    // Display login page
    router.get('/login', (req, res) => {
        res.render('login');
    });

    // Handle login form submission
    router.post('/login', (req, res) => {
        const { email, password } = req.body;
        const query = 'SELECT * FROM users WHERE email = ?';
    
        db.query(query, [email], (err, results) => {
            if (err) {
                console.error(err);
                return res.send('An error occurred.');
            }
            if (results.length > 0) {
                const user = results[0];
                bcrypt.compare(password, user.password, (err, match) => {
                    if (match) {
                        // Store user info in session
                        req.session.userId = user.id;
                        req.session.userEmail = user.email;
                        res.redirect('/');
                    } else {
                        res.send('Incorrect password.');
                    }
                });
            } else {
                res.send('User not found.');
            }
        });
    });
    

    // Display signup page
    router.get('/signup', (req, res) => {
        res.render('signup');
    });

    // Handle signup form submission
    router.post('/signup', async (req, res) => {
        const { email, password } = req.body;

        // Hash password before storing in DB
        const hashedPassword = await bcrypt.hash(password, 10);

        const query = 'INSERT INTO users (email, password) VALUES (?, ?)';
        db.query(query, [email, hashedPassword], (err, result) => {
            if (err) {
                console.error(err);
                return res.send('An error occurred during signup.');
            }
            res.redirect('/login');
        });
    });

    // Add to cart route
router.post('/add-to-cart', (req, res) => {
    const productId = req.body.productId;

    // Fetch the product from the database using productId
    const query = 'SELECT * FROM products WHERE id = ?';
    db.query(query, [productId], (err, result) => {
        if (err) {
            console.error(err);
            res.redirect('/');
        } else {
            const product = result[0];
            if (!req.session.cart) {
                req.session.cart = [];
            }

            // Check if the item already exists in the cart
            const existingProduct = req.session.cart.find(item => item.id === product.id);
            if (existingProduct) {
                // Increase the quantity if it exists
                existingProduct.quantity++;
            } else {
                // Add new product with quantity 1
                product.quantity = 1;
                req.session.cart.push(product);
            }

            res.redirect('/');
        }
    });
});

// View cart route
router.get('/cart', (req, res) => {
    const cart = req.session.cart || [];
    let total = 0;

    // Calculate the total price
    cart.forEach(item => {
        total += item.price * item.quantity; // Multiply price by quantity
    });

    res.render('cart', { cart, total });
});



// Checkout route
router.post('/checkout', (req, res) => {
    // Clear the cart
    req.session.cart = [];

    // Redirect to a confirmation page or homepage
    res.redirect('/');
});


    function isAuthenticated(req, res, next) {
        if (req.session.userId) {
            next();
        } else {
            res.redirect('/login');
        }
    }
    
    // router.get('/', isAuthenticated, (req, res) => {
    //     const query = 'SELECT * FROM products';
    //     db.query(query, (err, results) => {
    //         if (err) {
    //             console.error(err);
    //             return res.send('Error fetching products.');
    //         }
    //         res.render('index', { products: results });
    //     });
    // });

    // Home route
router.get('/', isAuthenticated, (req, res) => {
    const cart = req.session.cart || [];
    const query = 'SELECT * FROM products';

    db.query(query, (err, results) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error retrieving products');
        } else {
            // Create a map for easy access to cart quantities
            const cartQuantityMap = {};
            cart.forEach(item => {
                cartQuantityMap[item.id] = item.quantity;
            });

            res.render('index', { products: results, cartQuantityMap });
        }
    });
});
 

    return router;
};