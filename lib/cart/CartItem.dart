import 'package:pizzeria1/admin/pizza.dart';
import 'package:pizzeria1/cart/addon.dart';

class CartItem {
  final Pizza pizza;
  int quantity;
  bool extraCheese;
  bool extraMeat;
  String size;
  List<AddOn> addOns;

  CartItem({
    required this.pizza,
    this.quantity = 1,
    this.extraCheese = false,
    this.extraMeat = false,
    this.size = 'regular',
    List<AddOn>? addOns,
  }) : addOns = addOns ?? [];

  factory CartItem.fromMap(Map<String, dynamic> data) {
    return CartItem(
      pizza: Pizza(
        id: data['id'],
        name: data['name'],
        description: data['description'] ?? '',
        price: data['price'],
        imageUrl: data['imageUrl'] ?? '',
      ),
      quantity: data['quantity'],
      extraCheese: data['extraCheese'] ?? false,
      extraMeat: data['extraMeat'] ?? false,
      size: data['size'] ?? 'regular',
      addOns: (data['addOns'] as List<dynamic>? ?? [])
          .map((addOn) => AddOn(name: addOn['name'], price: addOn['price']))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': pizza.id,
      'name': pizza.name,
      'description': pizza.description,
      'price': pizza.price,
      'imageUrl': pizza.imageUrl,
      'quantity': quantity,
      'extraCheese': extraCheese,
      'extraMeat': extraMeat,
      'size': size,
      'addOns': addOns.map((addOn) => {
        'name': addOn.name,
        'price': addOn.price,
      }).toList(),
    };
  }
}
