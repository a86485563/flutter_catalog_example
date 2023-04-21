
import 'package:flutter/material.dart';
import 'package:flutter_catalog_example/features/catalog/reposity/catalog_reposity.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../cart/model/Item.dart';
import '../../cart/service/cart_model.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        _MyAppBar(),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => _MyListItem(index)))
      ],
    ));
  }
}

class _MyListItem extends StatelessWidget {
  final int index;
  const _MyListItem(this.index);

  //context.select<T, R>(R cb(T value)), which allows a widget to listen to only a small part of T.
  @override
  Widget build(BuildContext context) {
    var item = context.select<CatalogReposity, Item>(
        (catalog) => catalog.getByPosition(index));

    var textTheme = Theme.of(context).textTheme.titleLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(color: item.color),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Text(item.name, style: textTheme),
            ),
            const SizedBox(width: 24),
            _AddButton(item: item),
          ],
        ),
      ),
    );
  }
}

//未加入之前，text 顯示add ，加入後顯示打勾。
class _AddButton extends StatelessWidget {
  final Item item;
  const _AddButton({required this.item});
  @override
  Widget build(BuildContext context) {
    //當有東西加入了cartModel就要回傳有東西改變。且希望他回傳的東西是布林值。
    bool isInCart =
        context.select<CartModel, bool>((model) => model.items.contains(item));
    return TextButton(
        onPressed: isInCart
            ? null
            : () {
                //當該item沒有在購物車內，被點擊了，就要加入購物車。
                var cart = context.read<CartModel>();
                cart.addItem(item);
              },
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.pressed)) {
              return Theme.of(context).primaryColor;
            }
            return null; // Defer to the widget's default.
          }),
        ),
        //child 定義button 長怎樣。 沒有在購物車內，顯示add，有則顯示打勾
        child: isInCart
            ? const Icon(Icons.check, semanticLabel: 'ADDED')
            : const Text('ADD'));
  }
}

class _MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text('Catalog', style: Theme.of(context).textTheme.displayLarge),
      floating: true,
      actions: [
        IconButton(
            onPressed: () {
              context.go('/catalog/cart');
            },
            icon: const Icon(Icons.shopping_cart))
      ],
    );
  }
}
