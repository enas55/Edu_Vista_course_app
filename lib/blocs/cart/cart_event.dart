part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final Course course;
  AddToCart(this.course);
}

class RemoveFromCart extends CartEvent {
  final Course course;

  RemoveFromCart(this.course);
}

class Payment extends CartEvent {
  final BuildContext context;
  final List<Course> courses;

  Payment(this.context, this.courses);
}
