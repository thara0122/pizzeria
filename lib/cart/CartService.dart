import 'package:flutter/material.dart';
import 'package:pizzeria1/admin/pizza.dart';
import 'package:pizzeria1/cart/addon.dart';
import 'package:pizzeria1/cart/CartItem.dart';

class CartService with ChangeNotifier {
  final List<CartItem> _cart = [];

  List<CartItem> get cart => _cart;

  void addToCart(Pizza pizza,
      {bool extraCheese = false,
      bool extraMeat = false,
      String size = 'regular'}) {
    final index = _cart.indexWhere((item) =>
        item.pizza.id == pizza.id &&
        item.extraCheese == extraCheese &&
        item.extraMeat == extraMeat &&
        item.size == size);
    if (index != -1) {
      _cart[index].quantity += 1;
    } else {
      _cart.add(CartItem(
          pizza: pizza,
          extraCheese: extraCheese,
          extraMeat: extraMeat,
          size: size));
    }
    notifyListeners();
  }

  void addAddOnToCartItem(int index, AddOn addOn) {
    if (index < 0 || index >= _cart.length) return;

    final cartItem = _cart[index];
    final updatedAddOns = List<AddOn>.from(cartItem.addOns)..add(addOn);
    _cart[index] = CartItem(
      pizza: cartItem.pizza,
      quantity: cartItem.quantity,
      extraCheese: cartItem.extraCheese,
      extraMeat: cartItem.extraMeat,
      size: cartItem.size,
      addOns: updatedAddOns,
    );
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

  double get subtotal => _cart.fold(
      0.0,
      (total, current) =>
          total +
          current.pizza.price * current.quantity +
          current.addOns
              .fold(0.0, (addOnTotal, addOn) => addOnTotal + addOn.price));

  double get tax => subtotal * 0.07; // Example tax rate

  double get discount => 0; // Example discount

  double get total => subtotal + tax - discount;
}
