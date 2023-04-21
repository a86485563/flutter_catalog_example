import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/cart_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: Text('Cart', style: Theme.of(context).textTheme.displayLarge)),
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.yellow,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: _CartList(),
              ),
            ),
            const Divider(),
            _CartTotal(),
          ],
        ),
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemNameStyle = Theme.of(context).textTheme.titleLarge;
    //從context 取得CartModel
    var cart = context.watch<CartModel>();
    return ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (BuildContext context, int index) => (ListTile(
              leading: const Icon(Icons.done),
              trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => cart.removeItem(cart.items[index])),
              title: Text(
                cart.items[index].name,
                style: itemNameStyle,
              ),
            )));
  }
}

class _CartTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var hugeStyle =
        Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 48);

    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<CartModel>(
              builder: (context, cart, child) =>
                  Text('\$${cart.totalPrice}', style: hugeStyle)),
          const SizedBox(width: 24),
          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Buying not supported yet.')));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: const Text('BUY'),
          )
        ],
      ),
    );
  }
}
