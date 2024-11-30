// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../providers/store_provider.dart';

// class NearbyStoresScreen extends ConsumerWidget {
//   const NearbyStoresScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final locationAsyncValue = ref.read(locationProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Nearby Stores"),
//       ),
//       body: locationAsyncValue.when(
//         data: (position) {
//           // Fetch stores based on the real-time position
//           final storesAsyncValue = ref.watch(storeProvider(position));

//           return storesAsyncValue.when(
//             data: (categories) => ListView.builder(
//               itemCount: categories.length,
//               itemBuilder: (context, index) {
//                 final category = categories[index];
//                 return ExpansionTile(
//                   title: Text(category.category.name),
//                   children: category.stores.map((store) {
//                     return ListTile(
//                       title: Text(store.storeName),
//                       subtitle: Column(
//                         children: [
//                           ListView.builder(
//                             itemBuilder: (context, index) =>
//                                 Text(store.items[index].name),
//                           )
//                         ],
//                       ),
//                       // subtitle: Text('Distance: ${store.distance} km'),
//                     );
//                   }).toList(),
//                 );
//               },
//             ),
//             loading: () => const Center(child: CircularProgressIndicator()),
//             error: (err, stack) =>
//                 Center(child: Text('Error fetching stores: $err')),
//           );
//         },
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (err, stack) =>
//             Center(child: Text('Error fetching location: $err')),
//       ),
//     );
//   }
// }


// // 5bGKfVgAo4q9mDMTFx4LTsDulHmsKPt9
// // 5bGKfVgAo4q9mDMTFx4LTsDulHmsKPt9
// // f9ZxHaj5bUUlbjlT