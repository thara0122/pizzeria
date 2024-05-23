import 'package:flutter/material.dart';
import 'package:pizzeria1/PizzaDetailScreen.dart';
import 'package:pizzeria1/admin/pizza.dart';
import 'package:pizzeria1/admin/pizza_service.dart';
import 'package:pizzeria1/auth/login_screen.dart';

class ViewPizza extends StatefulWidget {
  const ViewPizza({Key? key}) : super(key: key);

  @override
  State<ViewPizza> createState() => _ViewPizzaState();
}

class _ViewPizzaState extends State<ViewPizza> {
  List<Pizza> _pizzas = []; // State variable to store fetched pizzas
  List<Pizza> _filteredPizzas = []; // State variable to store filtered pizzas
  final _pizzaService = PizzaService();
  final _searchController =
      TextEditingController(); // Controller for search input

  @override
  void initState() {
    super.initState();
    _fetchPizzas(); // Fetch pizzas on widget initialization

    // Listen to changes in the search controller
    _searchController.addListener(_filterPizzas);
  }

  Future<void> _fetchPizzas() async {
    final pizzas = await _pizzaService.fetchPizzas();
    setState(() {
      _pizzas = pizzas;
      _filteredPizzas = pizzas; // Initialize filtered pizzas with all pizzas
    });
  }

  void _filterPizzas() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPizzas = _pizzas.where((pizza) {
        return pizza.name.toLowerCase().contains(query) ||
            pizza.description.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: _pizzas.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Hope You Are Hungry!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search Here...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Popular',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 4,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _filteredPizzas.length,
                        itemBuilder: (context, index) {
                          final pizza = _filteredPizzas[index];
                          return PizzaCard(pizza: pizza);
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle_outlined),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class PizzaCard extends StatelessWidget {
  final Pizza pizza;

  const PizzaCard({required this.pizza, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PizzaDetailScreen(pizza: pizza),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: pizza.imageUrl.isNotEmpty
                      ? Image.network(
                          pizza.imageUrl,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          'https://via.placeholder.com/150',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                pizza.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.redAccent, size: 16),
                  Text(
                    '5.0',
                    style: TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '\RM ${pizza.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Icon(Icons.add_shopping_cart_sharp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
