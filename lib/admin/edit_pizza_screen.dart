import 'package:flutter/material.dart';
import 'pizza.dart';
import 'pizza_service.dart';

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

    if (name != _selectedPizza!.name ||
        description != _selectedPizza!.description ||
        price != _selectedPizza!.price) {
      final updatedPizza = Pizza(
        id: _selectedPizza!.id,
        name: name,
        description: description,
        price: price,
        imageUrl: _selectedPizza!.imageUrl,
      );

      await _pizzaService.updatePizza(
          updatedPizza.id!, name, description, price);

      setState(() {
        _pizzas[_pizzas.indexOf(_selectedPizza!)] = updatedPizza;
        _selectedPizza = null;
        _nameController.clear();
        _descriptionController.clear();
        _priceController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No changes detected. Please modify pizza details.'),
        ),
      );
    }
  }

  Future<void> _deletePizza() async {
    if (_selectedPizza == null) return;

    final confirmation = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Pizza Deletion'),
        content: const Text('Are you sure you want to delete this pizza?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmation == true) {
      await _pizzaService.deletePizza(_selectedPizza!.id!);
      setState(() {
        _pizzas.remove(_selectedPizza!);
        _selectedPizza = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pizza deleted successfully'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pizzas'),
        backgroundColor: Colors.redAccent,
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
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          title: Text(
                            pizza.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            '\RM ${pizza.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          onTap: () => _selectPizza(pizza),
                        ),
                      );
                    },
                  ),
                ),
                if (_selectedPizza != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Pizza Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Price',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _updatePizza,
                              icon: Icon(Icons.save),
                              label: const Text('Save Pizza'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _deletePizza,
                              icon: Icon(Icons.delete),
                              label: const Text('Delete Pizza'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
