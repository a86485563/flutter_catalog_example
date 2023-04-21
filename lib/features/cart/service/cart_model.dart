import 'dart:collection';

import 'package:flutter/material.dart';
import '../../catalog/reposity/catalog_reposity.dart';
import '../model/Item.dart';

class CartModel extends ChangeNotifier {
  //內部使用的，可以被更動。
  // final List<Item> _items = [];
  // //提供外部存取的。不能被更動。
  // UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  /// The private field backing [catalog].
  late CatalogReposity _catalog;

  /// Internal, private state of the cart. Stores the ids of each item.
  final List<int> _itemIds = [];

  CatalogReposity get catalog => _catalog;
  set catalog(CatalogReposity newCatalog) {
    _catalog = newCatalog;
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  List<Item> get items => _itemIds.map((id) => _catalog.getById(id)).toList();

  int get totalPrice =>
      items.fold(0, (total, current) => total + current.price);

  void addItem(Item item) {
    _itemIds.add(item.id);
    notifyListeners();
  }

  void removeItem(Item item) {
    _itemIds.remove(item.id);
    notifyListeners();
  }
}
