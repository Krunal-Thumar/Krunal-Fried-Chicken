module.exports = (db) => {
	const express = require("express");
	const bcrypt = require("bcrypt"); // For hashing passwords
	const router = express.Router();

	// Display login page
	router.get("/login", (req, res) => {
		res.render("login", { error: null });
	});

	// Handle login form submission
	router.post("/login", (req, res) => {
		const { email, password } = req.body;
		const query = "SELECT * FROM users WHERE email = ?";

		db.query(query, [email], (err, results) => {
			if (err) {
				console.error(err);
				return res.send("An error occurred.");
			}
			if (results.length > 0) {
				const user = results[0];
				bcrypt.compare(password, user.password, (err, match) => {
					if (match) {
						// Store user info in session
						req.session.userId = user.id;
						req.session.userEmail = user.email;
						res.redirect("/");
					} else {
						res.render("login", { error: "Invalid email or password." });
					}
				});
			} else {
				res.render("login", { error: "User does not exist!" });
			}
		});
	});

	// Display signup page
	router.get("/signup", (req, res) => {
		res.render("signup", { error: null });
	});

	// Handle signup form submission
	router.post("/signup", async (req, res) => {
		const { firstName, lastName, email, password } = req.body;

		try {
			// Check if the email already exists in the database
			const emailCheckQuery = "SELECT * FROM users WHERE email = ?";
			db.query(emailCheckQuery, [email], async (err, results) => {
				if (err) {
					console.error(err);
					return res.render("signup", { error: "An error occurred during signup." });
				}

				if (results.length > 0) {
					// Email already exists
					return res.render("signup", { error: "Email is already registered. Please log in." });
				}

				// Hash the password before saving it in the database
				const hashedPassword = await bcrypt.hash(password, 10);

				// Insert the new user into the database with firstName, lastName, email, and hashedPassword
				const insertQuery = "INSERT INTO users (first_name, last_name, email, password) VALUES (?, ?, ?, ?)";
				db.query(insertQuery, [firstName, lastName, email, hashedPassword], (err, result) => {
					if (err) {
						console.error(err);
						return res.render("signup", { error: "An error occurred during signup." });
					}

					// Redirect to login after successful signup
					res.redirect("/login");
				});
			});
		} catch (error) {
			console.error(error);
			return res.render("signup", { error: "Server error. Please try again later." });
		}
	});

	// View cart route
	router.get("/cart", (req, res) => {
		const cart = req.session.cart || [];
		const cartQuantityMap = cart.reduce((acc, item) => {
			acc[item.id] = item.quantity;
			return acc;
		}, {});
		let total = 0;

		// Calculate the total price
		cart.forEach((item) => {
			total += item.price * item.quantity; // Multiply price by quantity
		});

		// Render the cart page with the cart items and total
		res.render("cart", { cart, total, cartQuantityMap });
	});

	// Checkout route
	router.post("/checkout", (req, res) => {
		// Clear the cart
		req.session.cart = [];

		// Redirect to a confirmation page or homepage
		res.redirect("/");
	});

	function isAuthenticated(req, res, next) {
		if (req.session.userId) {
			next();
		} else {
			res.redirect("/login");
		}
	}

	router.post("/update-cart", (req, res) => {
		const { productId, action } = req.body;

		// Fetch the cart from the session or initialize it if it doesn't exist
		const cart = req.session.cart || [];
		const product = cart.find((item) => item.id == productId);

		if (!product && action === "increase") {
			// If the product doesn't exist and we're increasing, add it to the cart
			const query = "SELECT * FROM products WHERE id = ?";
			db.query(query, [productId], (err, results) => {
				if (err || results.length === 0) {
					return res.redirect("/");
				}
				const newProduct = results[0];
				newProduct.quantity = 1;
				cart.push(newProduct);
				req.session.cart = cart;

				return res.redirect("/");
			});
		} else if (product) {
			// If the product exists, update its quantity
			if (action === "increase") {
				product.quantity += 1;
			} else if (action === "decrease" && product.quantity > 0) {
				product.quantity -= 1;
			}

			// If the quantity reaches 0, you can optionally remove the product from the cart
			if (product.quantity === 0) {
				const productIndex = cart.indexOf(product);
				cart.splice(productIndex, 1);
			}

			req.session.cart = cart;
			return res.redirect("/");
		} else {
			return res.redirect("/");
		}
	});

	router.get("/logout", (req, res) => {
		// Destroy the session to log out the user
		req.session.destroy((err) => {
			if (err) {
				console.error("Error logging out:", err);
				return res.redirect("/"); // If an error occurs, redirect to home page
			}
			// Clear the cookie associated with the session
			res.clearCookie("connect.sid");
			// Redirect to login page after logout
			res.redirect("/login");
		});
	});

	router.get("/profile", isAuthenticated, (req, res) => {
		const cart = req.session.cart || [];
		const cartQuantityMap = cart.reduce((acc, item) => {
			acc[item.id] = item.quantity;
			return acc;
		}, {});

		const userId = req.session.userId;
		const query = "SELECT * FROM users WHERE id = ?";
		db.query(query, [userId], (err, results) => {
			if (err) {
				console.error(err);
				return res.send("An error occurred.");
			}
			if (results.length > 0) {
				const user = results[0];
				res.render("profile", { user, cartQuantityMap });
			} else {
				res.send("User does not exist!");
			}
		});
	});

	// Home route
	router.get("/", isAuthenticated, (req, res) => {
		const cart = req.session.cart || [];

		// Create a map for easy access to cart quantities
		const cartQuantityMap = cart.reduce((acc, item) => {
			acc[item.id] = item.quantity;
			return acc;
		}, {});

		const query = "SELECT * FROM products";

		db.query(query, (err, products) => {
			if (err) {
				console.error("Error retrieving products:", err);
				return res.status(500).send("Error retrieving products");
			}

			// Render the index page, passing the necessary variables
			res.render("index", {
				products,
				cartQuantityMap,
			});
		});
	});

	return router;
};