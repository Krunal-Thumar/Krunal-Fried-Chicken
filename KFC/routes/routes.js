module.exports = (db) => {
	const express = require("express");
	var md5 = require("js-md5");
	const router = express.Router();

	// Display login page
	router.get("/login", (req, res) => {
		res.render("login", { error: null });
	});

	// Handle login form submission
	router.post("/login", (req, res) => {
		const { email, password } = req.body;
		const query = `SELECT * FROM users WHERE email = '${email}' and password = '${md5(password)}'`;

		db.query(query, [email], (err, results) => {
			if (err) {
				console.error(err);
				return res.send("An error occurred.");
			}
			if (results.length > 0) {
				const user = results[0];
				// Store user info in session
				req.session.userId = user.id;
				req.session.userEmail = user.email;
				res.redirect("/");
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
				const hashedPassword = md5(password);

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
		const userId = req.session.userId;
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
		res.render("cart", { cart, total, cartQuantityMap, userId });
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

	// Profile route
	router.get("/profile", isAuthenticated, (req, res) => {
		const userId = req.query.userId;

		const userQuery = `
			SELECT users.first_name, users.last_name, users.email, addresses.address, addresses.city 
			FROM users 
			LEFT JOIN addresses ON users.id = addresses.user_id 
			WHERE users.id = ${userId}`;

		db.query(userQuery, [userId], (err, results) => {
			if (err) {
				console.error("Error retrieving user profile:", err);
				return res.status(500).send("Error retrieving profile");
			}

			if (results.length > 0) {
				const user = results[0];
				res.render("profile", {
					user, userId
				});
			} else {
				res.status(404).send("User not found");
			}
		});
	});

	router.post("/update-profile", isAuthenticated, (req, res) => {
		const { firstName, lastName, address, city } = req.body;
		const userId = req.session.userId;

		const updateQuery = `
			UPDATE users 
			SET first_name = ?, last_name = ? 
			WHERE id = ?`;

		const addressUpdateQuery = `
			UPDATE addresses 
			SET address = ?, city = ? 
			WHERE user_id = ?`;

		// Update user information
		db.query(updateQuery, [firstName, lastName, userId], (err, result) => {
			if (err) {
				console.error("Error updating user:", err);
				return res.status(500).send("Error updating user profile.");
			}

			// First try to update the address
			db.query(addressUpdateQuery, [address, city, userId], (err, result) => {
				if (err) {
					console.error("Error updating address:", err);
					return res.status(500).send("Error updating address.");
				}

				// If no rows were affected, it means no address existed, so insert a new one
				if (result.affectedRows === 0) {
					const insertAddressQuery = `
						INSERT INTO addresses (user_id, address, city) 
						VALUES (?, ?, ?)`;

					db.query(insertAddressQuery, [userId, address, city], (err, result) => {
						if (err) {
							console.error("Error inserting address:", err);
							return res.status(500).send("Error inserting address.");
						}

						// Redirect back to the profile page after successful update
						res.redirect("/");
					});
				} else {
					// If the address was updated successfully, redirect
					res.redirect("/");
				}
			});
		});
	});

	// Home route
	router.get("/", isAuthenticated, (req, res) => {
		const cart = req.session.cart || [];
		const userId = req.session.userId;

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
				userId,
			});
		});
	});

	// Checkout Route
	router.get("/checkout", isAuthenticated, (req, res) => {
		const userId = req.session.userId;

		// Query to retrieve the user's address details
		const addressQuery = `SELECT address, city FROM addresses WHERE user_id = ?`;

		db.query(addressQuery, [userId], (err, results) => {
			if (err) {
				console.error("Error retrieving address:", err);
				return res.status(500).send("Error retrieving address.");
			}

			// Set address to null if no address is found, otherwise use the first result
			const address = results.length > 0 ? results[0] : null;

			// Render the checkout page, passing address data and cart details
			const cart = req.session.cart || [];
			const total = cart.reduce((acc, item) => acc + item.price * item.quantity, 0);

			res.render("checkout", { cart, total, address, userId });
		});
	});

	router.post("/pay/card", isAuthenticated, (req, res) => {
		// Query to get the user's card information from the database
		const userId = req.session.userId; // Assuming user ID is stored in req.user

		const query = "SELECT * FROM cards WHERE user_id = ?";

		db.execute(query, [userId], (err, results) => {
			if (err) {
				console.error("Database query error:", err);
				return res.status(500).send("Internal Server Error");
			}

			// Assuming results are in an array, we'll take the first one if it exists
			const cardInfo = results.length > 0 ? results[0] : null;

			// Render the card view and pass the card info
			res.render("card", { cardInfo });
		});
	});

	router.post("/pay/card/submit", isAuthenticated, (req, res) => {
		// Extract card details from the request body
		const { cardholderName, cardNumber, expiryDate, cvv } = req.body;
		const userId = req.session.userId; // Assuming you have user info in req.user after authentication

		// SQL query to insert the card details into the cards table
		const insertCardQuery = `
			INSERT INTO cards (user_id, cardholder_name, card_number, expiry_date, cvv) 
			VALUES (?, ?, ?, ?, ?)
		`;

		// Execute the query
		db.query(insertCardQuery, [userId, cardholderName, cardNumber, expiryDate, cvv], (error, results) => {
			if (error) {
				console.error("Error inserting card details:", error);
				return res.status(500).send("Internal server error.");
			}

			// Clear the cart session
			req.session.cart = [];

			// Redirect to confirmation page
			res.redirect("/confirmation?method=card");
		});
	});

	router.post("/pay/cash", isAuthenticated, (req, res) => {
		// Here, you could handle cash-on-delivery setup.
		req.session.cart = [];

		res.redirect("/confirmation?method=cash");
	});

	router.get("/confirmation", (req, res) => {
		const paymentMethod = req.query.method;
		const message = paymentMethod === "card" ? "Thank you! Your card payment was successful." : "Thank you! Your order has been placed for cash payment.";
		res.render("confirmation", { message });
	});

	router.get("/database", isAuthenticated, (req, res) => {
		res.send("DB_CONNECTION: mysql://username:password@localhost:3306/mydb");
	});

	return router;
};
