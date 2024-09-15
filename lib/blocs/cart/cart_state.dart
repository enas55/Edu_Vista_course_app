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

class PaymentInProgress extends CartState {}

class PaymentSuccess extends CartState {
  final String transactionId;

  PaymentSuccess(this.transactionId);
}

class PaymentFailed extends CartState {
  final String error;

  PaymentFailed(this.error);
}

// paid courses

class PaidCoursesLoading extends CartState {}

class PaidCoursesLoaded extends CartState {
  final List<Course> paidCourses;

  PaidCoursesLoaded(this.paidCourses);
}

class PaidCoursesFailed extends CartState {
  final String error;

  PaidCoursesFailed(this.error);
}

// clear cart

class CartCleared extends CartState {}
