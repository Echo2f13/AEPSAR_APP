const express = require('express');
const bodyParser = require('body-parser');
const multer = require('multer');
const path = require('path');
const fs = require('fs');

const app = express();
app.use(bodyParser.json());

// Set up multer for handling file uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/'); // Directory to save uploaded images
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname)); // Append timestamp to filename
  },
});
const upload = multer({ storage });

// Create uploads directory if it doesn't exist
if (!fs.existsSync('uploads')) {
  fs.mkdirSync('uploads');
}

// In-memory "database" for items
let items = [
  {
    id: 1,
    name: 'John Doe',
    age: 30,
    'phone-number': '+91 123456789',
    'emg-contact-name': 'Jane Doe',
    'emg-contact-relation': 'Spouse',
    'emg-contact-phno': '+91 987654321',
    'blood-grp': 'O+',
  },
  {
    id: 2,
    name: 'Jane Smith',
    age: 25,
    'phone-number': '+91 987654321',
    'emg-contact-name': 'John Smith',
    'emg-contact-relation': 'Brother',
    'emg-contact-phno': '+91 123456789',
    'blood-grp': 'B-',
  }
];

// In-memory "database" for emergency protocol submissions
let emergencyProtocols = [];

// Root route to provide a welcome message
app.get('/', (req, res) => {
  res.send('Welcome to the Smart Ambulance System API. Use /items to access the data.');
});

// GET: Retrieve all items
app.get('/items', (req, res) => {
  res.json(items);
});

// GET: Retrieve a single item by ID
app.get('/items/:id', (req, res) => {
  const item = items.find(i => i.id === parseInt(req.params.id));
  if (item) {
    res.json(item);
  } else {
    res.status(404).json({ message: 'Item not found' });
  }
});

// POST: Create a new item
app.post('/items', (req, res) => {
  const newItem = {
    id: items.length + 1,
    name: req.body.name,
    age: req.body.age,
    'phone-number': req.body['phone-number'],
    'emg-contact-name': req.body['emg-contact-name'],
    'emg-contact-relation': req.body['emg-contact-relation'],
    'emg-contact-phno': req.body['emg-contact-phno'],
    'blood-grp': req.body['blood-grp'],
  };
  items.push(newItem);
  res.status(201).json(newItem);
});

// DELETE: Remove all items
app.delete('/alldelete', (req, res) => {
  items = [];
  res.json({ message: 'All items have been deleted' });
});

// PUT: Update an existing item
app.put('/items/:id', (req, res) => {
  const item = items.find(i => i.id === parseInt(req.params.id));
  if (item) {
    item.name = req.body.name;
    item.age = req.body.age;
    item['phone-number'] = req.body['phone-number'];
    item['emg-contact-name'] = req.body['emg-contact-name'];
    item['emg-contact-relation'] = req.body['emg-contact-relation'];
    item['emg-contact-phno'] = req.body['emg-contact-phno'];
    item['blood-grp'] = req.body['blood-grp'];
    res.json(item);
  } else {
    res.status(404).json({ message: 'Item not found' });
  }
});

// DELETE: Remove an item by ID
app.delete('/items/:id', (req, res) => {
  const itemExists = items.some(i => i.id === parseInt(req.params.id));
  if (itemExists) {
    items = items.filter(i => i.id !== parseInt(req.params.id));
    res.json({ message: 'Item deleted' });
  } else {
    res.status(404).json({ message: 'Item not found' });
  }
});

// POST: API for emergency protocol
app.post('/emergencyProtocol', upload.array('images'), (req, res) => {
  const { name, 'phone-number': phoneNumber, 'emg-contact-phno': emergencyContact, 'blood-grp': bloodGroup, location } = req.body;

  console.log('Received Data:', {
    name,
    phoneNumber,
    emergencyContact,
    bloodGroup,
    location,
  });

  // Log received images
  if (req.files) {
    req.files.forEach((file) => {
      console.log('Received Image:', file.filename);
    });
  }

  // Store received emergency protocol data
  const emergencyData = {
    name,
    phoneNumber,
    emergencyContact,
    bloodGroup,
    location,
    images: req.files.map(file => file.filename), // Store filenames of uploaded images
  };
  emergencyProtocols.push(emergencyData); // Add data to the array

  res.status(200).json({ message: 'Data received successfully!' });
});

// GET: Retrieve all emergency protocol submissions
app.get('/emergencyProtocol', (req, res) => {
  res.json(emergencyProtocols); // Send the array of emergency protocol data
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
