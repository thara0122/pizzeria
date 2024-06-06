import 'package:flutter/material.dart';
import 'package:pizzeria1/admin/pizza.dart';
import 'package:pizzeria1/cart/cartitem.dart';

class CartService with ChangeNotifier {
  final List<CartItem> _cart = [];

  List<CartItem> get cart => _cart;

  void addToCart(Pizza pizza) {
    final index = _cart.indexWhere((item) => item.pizza.id == pizza.id);
    if (index != -1) {
      _cart[index].quantity += 1;
    } else {
      _cart.add(CartItem(pizza: pizza));
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
