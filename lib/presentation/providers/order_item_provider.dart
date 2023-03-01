import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tocopedia/domains/entities/order_item.dart';
import 'package:tocopedia/domains/use_cases/order_item/cancel_order_item.dart';
import 'package:tocopedia/domains/use_cases/order_item/complete_order_item.dart';
import 'package:tocopedia/domains/use_cases/order_item/get_buyer_order_items.dart';
import 'package:tocopedia/domains/use_cases/order_item/get_order_item.dart';
import 'package:tocopedia/domains/use_cases/order_item/get_seller_order_items.dart';
import 'package:tocopedia/domains/use_cases/order_item/process_order_item.dart';
import 'package:tocopedia/domains/use_cases/order_item/send_order_item.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';

class OrderItemProvider with ChangeNotifier {
  final GetBuyerOrderItems _getBuyerOrderItems;
  final GetSellerOrderItems _getSellerOrderItems;
  final GetOrderItem _getOrderItem;
  final CancelOrderItem _cancelOrderItem;
  final ProcessOrderItem _processOrderItem;
  final SendOrderItem _sendOrderItem;
  final CompleteOrderItem _completeOrderItem;
  final String? _authToken;

  String _message = "";

  String get message => _message;

  OrderItem? _orderItem;

  OrderItem? get orderItem => _orderItem;

  List<OrderItem>? _buyerOrderItemList;

  List<OrderItem>? get buyerOrderItemList => _buyerOrderItemList;

  List<OrderItem>? _sellerOrderItemList;

  List<OrderItem>? get sellerOrderItemList => _sellerOrderItemList;

  ProviderState _getOrderItemState = ProviderState.empty;

  ProviderState get getOrderItemState => _getOrderItemState;

  ProviderState _getBuyerOrderItemsState = ProviderState.empty;

  ProviderState get getBuyerOrderItemsState => _getBuyerOrderItemsState;

  ProviderState _getSellerOrderItemsState = ProviderState.empty;

  ProviderState get getSellerOrderItemsState => _getSellerOrderItemsState;

  OrderItemProvider(
      {required GetBuyerOrderItems getBuyerOrderItems,
      required GetSellerOrderItems getSellerOrderItems,
      required GetOrderItem getOrderItem,
      required CancelOrderItem cancelOrderItem,
      required ProcessOrderItem processOrderItem,
      required SendOrderItem sendOrderItem,
      required CompleteOrderItem completeOrderItem,
      required String? authToken})
      : _authToken = authToken,
        _completeOrderItem = completeOrderItem,
        _cancelOrderItem = cancelOrderItem,
        _sendOrderItem = sendOrderItem,
        _processOrderItem = processOrderItem,
        _getOrderItem = getOrderItem,
        _getSellerOrderItems = getSellerOrderItems,
        _getBuyerOrderItems = getBuyerOrderItems;

  Future<void> getBuyerOrderItems() async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");

      _getBuyerOrderItemsState = ProviderState.loading;
      notifyListeners();

      final orderItemList = await _getBuyerOrderItems.execute(_authToken!);
      _buyerOrderItemList = orderItemList;
      _getBuyerOrderItemsState = ProviderState.loaded;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _getBuyerOrderItemsState = ProviderState.error;
      notifyListeners();
    }
  }

  Future<void> getSellerOrderItems() async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");

      _getSellerOrderItemsState = ProviderState.loading;
      notifyListeners();

      final orderItemList = await _getSellerOrderItems.execute(_authToken!);
      _sellerOrderItemList = orderItemList;
      _getSellerOrderItemsState = ProviderState.loaded;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _getSellerOrderItemsState = ProviderState.error;
      notifyListeners();
    }
  }

  Future<void> getOrderItem(String orderItemId) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");

      _getOrderItemState = ProviderState.loading;
      notifyListeners();

      final orderItem = await _getOrderItem.execute(_authToken!, orderItemId);
      _orderItem = orderItem;
      _getOrderItemState = ProviderState.loaded;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _getOrderItemState = ProviderState.error;
      notifyListeners();
    }
  }

  bool _verifyToken() {
    return (_authToken != null && _authToken!.isNotEmpty);
  }
}
