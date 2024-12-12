// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../providers/cart_provider.dart';

// class CartSubtotal extends ConsumerWidget {
//   const CartSubtotal({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     int sum = 0;
//     final cart = ref.watch(cartProvider);
//     cart.map((e) => sum += e.quantity * e.price as int).toList();
//     return Container(
//       margin: const EdgeInsets.all(10),
//       child: Row(
//         children: [
//           const Text(
//             'Subtotal ',
//             style: TextStyle(
//               fontSize: 20,
//             ),
//           ),
//           Text(
//             '\$$sum',
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
