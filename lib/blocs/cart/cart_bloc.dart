import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:edu_vista_final_project/models/course.dart';
import 'package:edu_vista_final_project/pages/paid_courses_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meta/meta.dart';
import 'package:paymob_payment/paymob_payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  List<Course> _cartItems = [];
  List<Course> _paidCourses = [];

  CartBloc() : super(CartInitial()) {
    on<LoadCart>(_loadCartItemsFromSharedPreferences);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<Payment>(_paymobPayment);
    on<LoadPaidCourses>(_loadPaidCourses);
    on<DeletePaidCourse>(_onDeletePaidCourse);
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

  FutureOr<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    _cartItems.add(event.course);
    await _saveCartItemsToSharedPreferences();
    emit(CartLoaded(_cartItems, _calculateTotalPrice()));
  }

  FutureOr<void> _onRemoveFromCart(
      RemoveFromCart event, Emitter<CartState> emit) async {
    _cartItems.remove(event.course);
    await _saveCartItemsToSharedPreferences();
    emit(CartLoaded(_cartItems, _calculateTotalPrice()));
  }

  double _calculateTotalPrice() {
    return _cartItems.fold(
      0,
      (total, course) => total + course.price!.toDouble(),
    );
  }

  Future<void> _paymobPayment(Payment event, Emitter<CartState> emit) async {
    emit(CartLoading());

    PaymobPayment.instance.initialize(
      apiKey: dotenv.env['apiKey']!,
      integrationID: int.parse(dotenv.env['integrationID']!),
      iFrameID: int.parse(dotenv.env['iFrameID']!),
    );

    int successfulPayments = 0;

    for (int i = 0; i < event.cartItems.length; i++) {
      final course = event.cartItems[i];

      try {
        final amountInEgp = (course.price! * 45.37).toDouble();

        final PaymobResponse? response = await PaymobPayment.instance.pay(
          context: event.context,
          currency: "EGP",
          amountInCents: amountInEgp.toString(),
        );

        if (response != null && response.success) {
          if (!_paidCourses.any((paidCourse) => paidCourse.id == course.id)) {
            _paidCourses.add(course);
            successfulPayments++;
          }

          log('Payment successful for course: ${course.title}');
        } else {
          log('Payment failed for course: ${course.title}');
        }
      } catch (e) {
        log('Payment error for course: ${course.title} - $e');
      }
    }

    await _savePaidCoursesToSharedPreferences();
    await _clearCart();

    if (event.context.mounted) {
      ScaffoldMessenger.of(event.context).showSnackBar(
        SnackBar(
          content: Text('$successfulPayments payment successful'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(event.context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => PaidCoursesPage(paidCourses: _paidCourses),
        ),
      );
    }
  }

  Future<void> _savePaidCoursesToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final paidCoursesJson = jsonEncode(_paidCourses);
    prefs.setString('paidCourses', paidCoursesJson);
  }

  Future<void> _loadPaidCourses(
      LoadPaidCourses event, Emitter<CartState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final paidCoursesJson = prefs.getString('paidCourses');
    if (paidCoursesJson != null) {
      final paidCourses = List<Course>.from(
        jsonDecode(paidCoursesJson).map((item) => Course.fromJson(item)),
      );
      _paidCourses = paidCourses;
      emit(PaidCoursesLoaded(_paidCourses));
    }
  }

  Future<void> _onDeletePaidCourse(
      DeletePaidCourse event, Emitter<CartState> emit) async {
    _paidCourses.remove(event.course);
    await _savePaidCoursesToSharedPreferences();
    emit(PaidCoursesLoaded(_paidCourses));
  }

  Future<void> _clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartItems');
    _cartItems.clear();
  }

  Future<bool> isCourseInCart(Course course) async {
    if (state is CartLoaded) {
      final cartItems = (state as CartLoaded).cartItems;
      return cartItems.any((item) => item.id == course.id);
    }
    return false;
  }
}
