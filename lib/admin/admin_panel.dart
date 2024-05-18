import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'pizza_service.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final _pizzaService = PizzaService();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController(); // For image URL
  File? _imageFile; // To store the selected image file

  // Function to handle image selection (optional)
  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        _imageUrlController.text = pickedFile.path; // Update image URL controller
      } else {
        print('No image selected.');
      }
    });
  }

  void _addNewPizza() async {
    final name = _nameController.text;
    final description = _descriptionController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0; // Handle invalid input
    final imageUrl = _imageUrlController.text; // Get the image URL

    // Upload image to storage (optional, see next steps)
    // String uploadedImageUrl = await _uploadImage(imageFile);

    await _pizzaService.addPizza(name, description, price, imageUrl: imageUrl);

    // Clear input fields
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _imageUrlController.clear();
    _imageFile = null; // Clear image selection
  }

  // Optional: Function to upload image to storage (implement storage logic)
  Future<String> _uploadImage(File imageFile) async {
    // Implement image upload logic using Firebase Storage or another service

    // Replace with your actual upload logic
    return 'https://placeholder.com/image.jpg'; // Placeholder for now
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Pizza Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            TextField( // For image URL input
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL (Optional)'),
            ),
            ElevatedButton(
              onPressed: _pickImage, // Trigger image selection
              child: const Text('Select Image'),
            ),
            if (_imageFile != null) // Display selected image (optional)
              Image.file(_imageFile!, height: 100, width: 100),
            ElevatedButton(
              onPressed: _addNewPizza,
              child: const Text('Add New Pizza'),
            ),
          ],
        ),
      ),
    );
  }
}
