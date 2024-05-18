import 'package:flutter/material.dart';
import 'package:pizzeria1/admin/pizza.dart';
import 'package:pizzeria1/admin/pizza_service.dart';

class EditPizzaScreen extends StatefulWidget {
  const EditPizzaScreen({super.key});

  @override
  State<EditPizzaScreen> createState() => _EditPizzaScreenState();
}

class _EditPizzaScreenState extends State<EditPizzaScreen> {
  final _pizzaService = PizzaService();
  List<Pizza> _pizzas = [];
  Pizza? _selectedPizza;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPizzas();
  }

  Future<void> _fetchPizzas() async {
    final pizzas = await _pizzaService.fetchPizzas();
    setState(() {
      _pizzas = pizzas;
    });
  }

  void _selectPizza(Pizza pizza) {
    setState(() {
      _selectedPizza = pizza;
      _nameController.text = pizza.name;
      _descriptionController.text = pizza.description;
      _priceController.text = pizza.price.toString();
    });
  }

  Future<void> _updatePizza() async {
    if (_selectedPizza == null) return;

    final name = _nameController.text;
    final description = _descriptionController.text;
    final price = double.parse(_priceController.text);

    // Update only if values have changed
    if (name != _selectedPizza!.name ||
        description != _selectedPizza!.description ||
        price != _selectedPizza!.price) {
      print("Updating pizza with ID: ${_selectedPizza!.id}");
      print("New name: $name, description: $description, price: $price");

      final updatedPizza = Pizza(
        id: _selectedPizza!.id,
        name: name,
        description: description,
        price: price,
        imageUrl: _selectedPizza!.imageUrl, // Keep the original image URL
      );

      await _pizzaService.updatePizza(updatedPizza.id!, name, description, price);
      // Update succeeded

      setState(() {
        _pizzas[_pizzas.indexOf(_selectedPizza!)] = updatedPizza;
        _selectedPizza = null; // Clear selected pizza after update
        _nameController.text = ""; // Clear text fields after update
        _descriptionController.text = "";
        _priceController.text = "";
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No changes detected. Please modify pizza details.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pizzas'),
      ),
      body: _pizzas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _pizzas.length,
                    itemBuilder: (context, index) {
                      final pizza = _pizzas[index];
                      return ListTile(
                        title: Text(pizza.name),
                        subtitle: Text(pizza.price.toStringAsFixed(2)),
                        onTap: () => _selectPizza(pizza),
                      );
                    },
                  ),
                ),
                if (_selectedPizza != null)
                  Padding(
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
                        ElevatedButton(
                          onPressed: _updatePizza,
                          child: const Text('Save Changes'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
