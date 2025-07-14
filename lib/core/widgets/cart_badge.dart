import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/services/auth_service.dart';
import '../../features/cart/screens/cart_screen.dart';
import '../../features/cart/services/cart_service.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Consumer<CartService>(
      builder: (context, cartService, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                // Check login before opening cart
                if (authService.isAuthenticated) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartScreen(),
                    ),
                  );
                } else {
                  _showLoginRequiredDialog(context);
                }
              },
            ),
            if (cartService.itemCount > 0)
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '${cartService.itemCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text('You need to log in to use this feature.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            child: const Text('Log In'),
          ),
        ],
      ),
    );
  }
}
