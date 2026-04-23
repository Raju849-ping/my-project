const express = require('express');
const mongoose = require('mongoose');

const app = express();
app.use(express.json());

// Use ENV variable (IMPORTANT)
const MONGO_URL = process.env.MONGO_URL || "mongodb://mongodb:27017/kirana";

// Retry connection (CRITICAL FIX)
const connectDB = async () => {
  try {
    await mongoose.connect(MONGO_URL);
    console.log("✅ MongoDB Connected");
  } catch (err) {
    console.log("❌ DB Connection Failed, retrying in 5s...");
    setTimeout(connectDB, 5000);
  }
};

connectDB();

// Schema
const Product = mongoose.model('Product', {
  name: String,
  quantity: Number,
  updatedAt: { type: Date, default: Date.now }
});

// Health check (needed for K8s)
app.get('/health', (req, res) => {
  res.send("OK");
});

// 👤 USER API
app.get('/products', async (req, res) => {
  const data = await Product.find();
  res.send(data);
});

// 🧑‍💼 OWNER API
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

  res.send(product);
});

app.listen(3000, () => console.log("🚀 Catalog Service Running"));
