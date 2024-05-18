import 'package:flutter/material.dart';
import 'package:pizzeria1/PizzaCart.dart';
import 'package:pizzeria1/admin/pizza.dart';
import 'package:pizzeria1/admin/pizza_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Pizza> _pizzas = []; // State variable to store fetched pizzas
  
  final _pizzaService = PizzaService();
  
  @override
  void initState() {
    super.initState();
    _fetchPizzas(); // Fetch pizzas on widget initialization
  }

  Future<void> _fetchPizzas() async {
    final pizzas = await _pizzaService.fetchPizzas();
    setState(() {
      _pizzas = pizzas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizza Menu'),
      ),
      body: _pizzas.isEmpty
          ? const Center(child: Text('Loading pizzas...'))
          : ListView.builder(
              itemCount: _pizzas.length,
              itemBuilder: (context, index) {
                final pizza = _pizzas[index];
                return PizzaCard(pizza: pizza); // Use PizzaCard widget
              },
            ),
    );
  }
}
