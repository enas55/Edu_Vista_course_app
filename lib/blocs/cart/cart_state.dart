part of 'cart_bloc.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<Course> cartItems;
  final double totalPrice;

  CartLoaded(this.cartItems, this.totalPrice);
}

class CartLoadingFailed extends CartState {
  final String error;

  CartLoadingFailed(this.error);
}

// paymob payment

final class PayMob extends CartState {}

class PaymentSuccess extends CartState {
  final String message;

  PaymentSuccess(this.message);
}

class PaymentFailed extends CartState {
  final String error;

  PaymentFailed(this.error);
}
