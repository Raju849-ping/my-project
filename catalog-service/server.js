const express = require('express');
const mongoose = require('mongoose');
const app = express();

app.use(express.json());

// MongoDB connection
mongoose.connect('mongodb://mongodb:27017/kirana');

// Schema
const Product = mongoose.model('Product', {
  name: String,
  quantity: Number,
  updatedAt: { type: Date, default: Date.now }
});

// 👤 USER API (view products)
app.get('/products', async (req, res) => {
  const data = await Product.find();
  res.send(data);
});

// 🧑‍💼 OWNER API (update stock)
app.post('/update', async (req, res) => {
  const { name, quantity } = req.body;

  let product = await Product.findOne({ name });

  if (product) {
    product.quantity = quantity;
    product.updatedAt = new Date();
    await product.save();
  } else {
    product = new Product({ name, quantity });
    await product.save();
  }

  console.log("Updated:", product);
  res.send(product);
});

app.listen(3000, () => console.log("Catalog Service Running"));
