const express = require('express');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

// In-memory "database"
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

// DELETE: Remove all items
app.delete('/items/all', (req, res) => {
  items = [];
  res.json({ message: 'All items have been deleted' });
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
