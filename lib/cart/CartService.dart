import 'package:flutter/material.dart';
import 'package:pizzeria1/admin/pizza.dart';

import 'CartItem.dart';



class CartService with ChangeNotifier {
  final List<CartItem> _cart = [];

  List<CartItem> get cart => _cart;

  void addToCart(Pizza pizza, {bool extraCheese = false, bool extraMeat = false, String size = 'regular'}) {
    final index = _cart.indexWhere((item) => item.pizza.id == pizza.id && item.extraCheese == extraCheese && item.extraMeat == extraMeat && item.size == size);
    if (index != -1) {
      _cart[index].quantity += 1;
    } else {
      _cart.add(CartItem(pizza: pizza, extraCheese: extraCheese, extraMeat: extraMeat, size: size));
    }
    notifyListeners();
  }

  void removeFromCart(Pizza pizza) {
    final index = _cart.indexWhere((item) => item.pizza.id == pizza.id);
    if (index != -1) {
      if (_cart[index].quantity > 1) {
        _cart[index].quantity -= 1;
      } else {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  void updateCartItemQuantity(Pizza pizza, int quantity) {
    final index = _cart.indexWhere((item) => item.pizza.id == pizza.id);
    if (index != -1) {
      _cart[index].quantity = quantity;
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
