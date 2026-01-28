import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/providers/api_providers.dart';
import 'package:openapi/openapi.dart';
import 'package:mobile/widgets/app_drawer.dart';

class DiamondPackage {
  final int id;
  final int amount;
  final String price;
  final bool popular;
  final String icon;
  final String description;
  final Color gradientStart;
  final Color gradientEnd;

  const DiamondPackage({
    required this.id,
    required this.amount,
    required this.price,
    this.popular = false,
    required this.icon,
    required this.description,
    required this.gradientStart,
    required this.gradientEnd,
  });
}

class DiamondStoreScreen extends ConsumerStatefulWidget {
  const DiamondStoreScreen({super.key});

  @override
  ConsumerState<DiamondStoreScreen> createState() => _DiamondStoreScreenState();
}

class _DiamondStoreScreenState extends ConsumerState<DiamondStoreScreen>
    with TickerProviderStateMixin {
  final Map<int, bool> _loading = {};
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<DiamondPackage> _diamondPackages = const [
    DiamondPackage(
      id: 1,
      amount: 10,
      price: '\$0.99',
      icon: '💎',
      description: 'Perfect for trying out predictions',
      gradientStart: Color(0xFFE8F5E8),
      gradientEnd: Color(0xFFB8D4B8),
    ),
    DiamondPackage(
      id: 2,
      amount: 50,
      price: '\$4.99',
      icon: '💎💎',
      description: 'Great value for regular users',
      gradientStart: Color(0xFFE3F2FD),
      gradientEnd: Color(0xFFBBDEFB),
    ),
    DiamondPackage(
      id: 3,
      amount: 100,
      price: '\$8.99',
      popular: true,
      icon: '💎💎💎',
      description: 'Most popular choice!',
      gradientStart: Color(0xFFFFF3E0),
      gradientEnd: Color(0xFFFFE0B2),
    ),
    DiamondPackage(
      id: 4,
      amount: 250,
      price: '\$19.99',
      icon: '💎💎💎💎',
      description: 'For serious predictors',
      gradientStart: Color(0xFFF3E5F5),
      gradientEnd: Color(0xFFE1BEE7),
    ),
    DiamondPackage(
      id: 5,
      amount: 500,
      price: '\$34.99',
      icon: '💎💎💎💎💎',
      description: 'Premium package',
      gradientStart: Color(0xFFE8EAF6),
      gradientEnd: Color(0xFFC5CAE9),
    ),
    DiamondPackage(
      id: 6,
      amount: 1000,
      price: '\$59.99',
      icon: '💎💎💎💎💎💎',
      description: 'Ultimate value pack',
      gradientStart: Color(0xFFFCE4EC),
      gradientEnd: Color(0xFFF8BBD9),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _purchaseDiamonds(DiamondPackage pkg) async {
    setState(() => _loading[pkg.id] = true);

    try {
      final matchesApi = ref.read(matchesApiProvider);
      final dto = CanPredictMatchDto((b) => b.numberOfDiamondsBet = pkg.amount);

      await matchesApi.matchesControllerAddDiamond(canPredictMatchDto: dto);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text('Successfully purchased ${pkg.amount} diamonds!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                const Text('Failed to purchase diamonds. Please try again.'),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
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
      appBar: AppBar(
        title: const Text('Diamond Store'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber[200]!),
            ),
            child: Row(
              children: [
                const Icon(Icons.diamond, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  '1,250', // This would come from user state
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
            ),
          ),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600
                        ? 3
                        : 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final pkg = _diamondPackages[index];
                    return _buildDiamondCard(pkg);
                  }, childCount: _diamondPackages.length),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('💎', style: TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Diamond Store',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Purchase diamonds to make predictions',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info_outline, color: Colors.white, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Use diamonds to predict match outcomes',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiamondCard(DiamondPackage pkg) {
    final isLoading = _loading[pkg.id] ?? false;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Card(
        elevation: pkg.popular ? 12 : 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [pkg.gradientStart, pkg.gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: pkg.popular
                ? Border.all(color: Colors.amber, width: 3)
                : null,
          ),
          child: Stack(
            children: [
              if (pkg.popular)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      'POPULAR',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Diamond icons with animation
                    Flexible(
                      flex: 2,
                      child: Center(
                        child: AnimatedScale(
                          scale: isLoading ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            pkg.icon,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                    ),

                    // Amount
                    Flexible(
                      flex: 1,
                      child: Center(
                        child: Text(
                          '${pkg.amount}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ),

                    // Price
                    Flexible(
                      flex: 1,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Text(
                            pkg.price,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Purchase button
                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () => _purchaseDiamonds(pkg),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: pkg.popular
                                ? Colors.amber
                                : Colors.blue,
                            foregroundColor: pkg.popular
                                ? Colors.black
                                : Colors.white,
                            elevation: 2,
                            shadowColor:
                                (pkg.popular ? Colors.amber : Colors.blue)
                                    .withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 14,
                                  width: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.shopping_cart, size: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
