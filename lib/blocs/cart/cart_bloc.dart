import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:edu_vista_final_project/models/course.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meta/meta.dart';
import 'package:paymob_payment/paymob_payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  List<Course> _cartItems = [];
  CartBloc() : super(CartInitial()) {
    on<LoadCart>(_loadCartItemsFromSharedPreferences);
    on<AddToCart>(onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<Payment>(_paymobPayment);
  }

  Future<void> _loadCartItemsFromSharedPreferences(
      LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final prefs = await SharedPreferences.getInstance();
    final cartItemsJson = prefs.getString('cartItems');
    if (cartItemsJson != null) {
      final cartItems = List<Course>.from(
        jsonDecode(cartItemsJson).map((item) => Course.fromJson(item)),
      );
      _cartItems = cartItems;
      emit(
        CartLoaded(
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
    emit(CartLoaded(
      _cartItems,
      _calculateTotalPrice(),
    ));
  }

  FutureOr<void> _onRemoveFromCart(
      RemoveFromCart event, Emitter<CartState> emit) async {
    _cartItems.remove(event.course);
    _saveCartItemsToSharedPreferences();
    emit(
      CartLoaded(
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

  Future<void> _paymobPayment(Payment event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      const double exchangeRate = 50;
      double totalCartPrice =
          event.courses.fold(0.0, (sum, course) => sum + course.price!);
      final priceInEGP = totalCartPrice * exchangeRate;
      final amountInCents = (priceInEGP * 100).toInt();

      PaymobPayment.instance.initialize(
        apiKey: dotenv.env['apiKey']!,
        integrationID: int.parse(dotenv.env['integrationID']!),
        iFrameID: int.parse(dotenv.env['iFrameID']!),
      );

      final PaymobResponse? response = await PaymobPayment.instance.pay(
        context: event.context,
        currency: "EGP",
        amountInCents: amountInCents.toString(),
      );

      if (response != null && response.success) {
        for (var course in event.courses) {
          await _savePaidCourse(course.id!);
        }

        emit(PaymentSuccess('Successful payment process'));

        log('Transaction ID: ${response.transactionID}');
        log('Success: ${response.success}');
      } else {
        emit(PaymentFailed('Payment failed or response is null'));
        log('Payment failed or response is null');
      }
    } catch (e) {
      emit(PaymentFailed('Something went wrong : $e'));
      log('Payment Error: $e');
    }
  }

  Future<void> _savePaidCourse(String courseId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> paidCourses = prefs.getStringList('paid_courses') ?? [];

    if (!paidCourses.contains(courseId)) {
      paidCourses.add(courseId);
      await prefs.setStringList('paid_courses', paidCourses);
    }
  }
}
