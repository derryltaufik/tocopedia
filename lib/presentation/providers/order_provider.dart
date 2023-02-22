import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tocopedia/domains/entities/order.dart';
import 'package:tocopedia/domains/use_cases/order/cancel_order.dart';
import 'package:tocopedia/domains/use_cases/order/checkout.dart';
import 'package:tocopedia/domains/use_cases/order/get_order.dart';
import 'package:tocopedia/domains/use_cases/order/get_user_orders.dart';
import 'package:tocopedia/domains/use_cases/order/pay_order.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';

class OrderProvider with ChangeNotifier {
  final GetOrder _getOrder;
  final GetUserOrders _getUserOrders;
  final Checkout _checkout;
  final PayOrder _payOrder;
  final CancelOrder _cancelOrder;
  final String? _authToken;

  String _message = "";

  String get message => _message;

  Order? _order;

  Order? get order => _order;

  List<Order>? _orderList;

  List<Order>? get orderList => _orderList;

  ProviderState _getOrderState = ProviderState.empty;

  ProviderState get getOrderState => _getOrderState;

  ProviderState _getUserOrdersState = ProviderState.empty;

  ProviderState get getUserOrdersState => _getUserOrdersState;

  OrderProvider(
      {required GetOrder getOrder,
      required GetUserOrders getUserOrders,
      required Checkout checkout,
      required PayOrder payOrder,
      required CancelOrder cancelOrder,
      required String? authToken})
      : _authToken = authToken,
        _getOrder = getOrder,
        _cancelOrder = cancelOrder,
        _payOrder = payOrder,
        _checkout = checkout,
        _getUserOrders = getUserOrders;

  Future<void> getOrder(String orderId) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");

      _getOrderState = ProviderState.loading;
      notifyListeners();

      final order = await _getOrder.execute(_authToken!, orderId);
      _order = order;
      _getOrderState = ProviderState.loaded;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _getOrderState = ProviderState.error;
      notifyListeners();
    }
  }

  Future<void> getUserOrders() async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");

      _getUserOrdersState = ProviderState.loading;
      notifyListeners();

      final orderList = await _getUserOrders.execute(_authToken!);
      orderList
        .removeWhere((element) =>
            element.status != "unpaid" &&
                DateTime.now().difference(element.createdAt!).inHours > 24);
      _orderList = orderList;
      _getUserOrdersState = ProviderState.loaded;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _getUserOrdersState = ProviderState.error;
      notifyListeners();
    }
  }

  Future<Order> checkOut(String addressId) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");
      final order = await _checkout.execute(_authToken!, addressId);
      return order;
    } on Exception catch (e) {
      rethrow;
    }
  }

  Future<Order> payOrder(String orderId) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");
      await Future.delayed(const Duration(seconds: 3));

      final order = await _payOrder.execute(_authToken!, orderId);
      return order;
    } on Exception catch (e) {
      rethrow;
    }
  }

  Future<Order> cancelOrder(String orderId) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");
      await Future.delayed(const Duration(seconds: 3));

      final order = await _cancelOrder.execute(_authToken!, orderId);
      return order;
    } on Exception catch (e) {
      rethrow;
    }
  }

  bool _verifyToken() {
    return (_authToken != null && _authToken!.isNotEmpty);
  }
}
