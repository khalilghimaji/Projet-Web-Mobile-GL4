import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/providers/api_providers.dart';
import 'package:openapi/openapi.dart';

class DiamondPackage {
  final int id;
  final int amount;
  final String price;
  final bool popular;
  final String icon;

  const DiamondPackage({
    required this.id,
    required this.amount,
    required this.price,
    this.popular = false,
    required this.icon,
  });
}

class DiamondStoreScreen extends ConsumerStatefulWidget {
  const DiamondStoreScreen({super.key});

  @override
  ConsumerState<DiamondStoreScreen> createState() => _DiamondStoreScreenState();
}

class _DiamondStoreScreenState extends ConsumerState<DiamondStoreScreen> {
  final Map<int, bool> _loading = {};

  final List<DiamondPackage> _diamondPackages = const [
    DiamondPackage(id: 1, amount: 10, price: '\$0.99', icon: '💎'),
    DiamondPackage(id: 2, amount: 50, price: '\$4.99', icon: '💎💎'),
    DiamondPackage(
      id: 3,
      amount: 100,
      price: '\$8.99',
      popular: true,
      icon: '💎💎💎',
    ),
    DiamondPackage(id: 4, amount: 250, price: '\$19.99', icon: '💎💎💎💎'),
    DiamondPackage(id: 5, amount: 500, price: '\$34.99', icon: '💎💎💎💎💎'),
    DiamondPackage(id: 6, amount: 1000, price: '\$59.99', icon: '💎💎💎💎💎💎'),
  ];

  Future<void> _purchaseDiamonds(DiamondPackage pkg) async {
    setState(() => _loading[pkg.id] = true);

    try {
      final matchesApi = ref.read(matchesApiProvider);
      final dto = CanPredictMatchDto((b) => b.numberOfDiamondsBet = pkg.amount);

      await matchesApi.matchesControllerAddDiamond(canPredictMatchDto: dto);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully purchased ${pkg.amount} diamonds!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Failed to purchase diamonds. Please try again.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _loading[pkg.id] = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diamond Store')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: _diamondPackages.length,
        itemBuilder: (context, index) {
          final pkg = _diamondPackages[index];
          final isLoading = _loading[pkg.id] ?? false;

          return Card(
            elevation: pkg.popular ? 8 : 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: pkg.popular
                  ? const BorderSide(color: Colors.amber, width: 2)
                  : BorderSide.none,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (pkg.popular)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'POPULAR',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(pkg.icon, style: const TextStyle(fontSize: 32)),
                  const SizedBox(height: 8),
                  Text(
                    '${pkg.amount}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Diamonds',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pkg.price,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () => _purchaseDiamonds(pkg),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pkg.popular ? Colors.amber : null,
                        foregroundColor: pkg.popular ? Colors.black : null,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Purchase'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
