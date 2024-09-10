import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:edu_vista_final_project/models/course.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  List<Course> _cartItems = [];
  CartBloc() : super(CartInitial()) {
    on<LoadCart>(_loadCartItemsFromSharedPreferences);
    on<AddToCart>(onAddToCart);
    on<RemoveFromCart>(onRemoveFromCart);
  }

  Future<void> _loadCartItemsFromSharedPreferences(
      LoadCart event, Emitter<CartState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final cartItemsJson = prefs.getString('cartItems');
    if (cartItemsJson != null) {
      final cartItems = List<Course>.from(
        jsonDecode(cartItemsJson).map((item) => Course.fromJson(item)),
      );
      _cartItems = cartItems;
      emit(
        CartUpdated(
          _cartItems,
          _calculateTotalPrice(),
        ),
      );
    }
  }

  Future<void> _saveCartItemsToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItemsJson = jsonEncode(_cartItems);
    prefs.setString('cartItems', cartItemsJson);
  }

  FutureOr<void> onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    _cartItems.add(event.course);
    _saveCartItemsToSharedPreferences();
    emit(CartUpdated(
      _cartItems,
      _calculateTotalPrice(),
    ));
  }

  FutureOr<void> onRemoveFromCart(
      RemoveFromCart event, Emitter<CartState> emit) async {
    _cartItems.remove(event.course);
    _saveCartItemsToSharedPreferences();
    emit(
      CartUpdated(
        _cartItems,
        _calculateTotalPrice(),
      ),
    );
  }

  double _calculateTotalPrice() {
    return _cartItems.fold(
      0,
      (total, course) => total + course.price!.toDouble(),
    );
  }
}
