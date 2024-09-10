part of 'cart_bloc.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

class CartUpdated extends CartState {
  final List<Course> cartItems;
  final double totalPrice;

  CartUpdated(this.cartItems, this.totalPrice);
}
