import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const PolicyScanApp());
}

class PolicyScanApp extends StatelessWidget {
  const PolicyScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      title: 'Policy Pilot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF136C91),
          secondary: const Color(0xFFD3F2FF),
          surface: const Color(0xFFDCF4FF),
          background: const Color(0xFFCAE6FB),
          onPrimary: Colors.white,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Color(0xFF191953)),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const OnboardingScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/fan.png',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Policy Pilot',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Smart Financial Protection',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuint,
    ));

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/fan2.png',
                  width: 180,
                  height: 180,
                ),
                const SizedBox(height: 30),
                Text(
                  'Your Financial Protection Suite',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A2477),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'AI-powered tools for insurance analysis, loan calculations, '
                      'and financial planning - all in one place.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color:Color(0xFF211350),
                  ),
                ),
                const SizedBox(height: 40),
                AnimatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const MainScreen(),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AnimatedButton({super.key, required this.onPressed});

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF5E46AC),
                Color(0xFF513C98),
                Color(0xFF1A0E40),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final PageController _heroController = PageController();

  final List<Widget> _screens = [
    const HomeScreen(),
    const InsuranceToolsScreen(),
    const LoanCalculatorScreen(),
    const InsightsScreen(),
  ];

  final List<Map<String, dynamic>> _heroItems = [
    {
      'title': 'Bazaar Gyan (Market Insights)',
      'subtitle': 'Bhavishya ki jankari, smart nivesh ki taiyari',
      'color': Color(0xFF1A5585),
      'route': InsightsScreen(),
    },
    {
      'title': 'Fraud Rakshak (Scam Protector)',
      'subtitle': 'Surakshit rahein, dhokhebazi se bachain',
      'color': Colors.red.shade600,
      'route': FraudDetectionScreen(),
    },
    {
      'title': 'Bima Shakti (Insurance Power)',
      'subtitle': 'Raksha kare, dhan bachaye - Complete protection solutions',
      'color': Color(0xFF200F5C),
      'route': const InsuranceToolsScreen(),
    },
    {
      'title': 'EMI Mitra (Loan Friend)',
      'subtitle': 'Chhutki mein EMI hisaab - Smart loan calculations',
      'color': Colors.green.shade700,
      'route': LoanCalculatorScreen(),
    },
    {
      'title': 'Premium Gyani (Premium Expert)',
      'subtitle': 'AI-powered beema anuman - Smart premium predictions',
      'color': Colors.purple.shade700,
      'route': PremiumPredictionScreen(),
    },
    {
      'title': 'Samavesh Index (Inclusivity Tracker)',
      'subtitle': 'Sabka saath, sabka vikas - Track financial inclusivity',
      'color': Colors.orange.shade700,
      'route': InclusivityIndexScreen(),
    },
  ];

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: Column(
        children: [
          // AppBar with improved styling
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade100,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.only(top: kToolbarHeight / 2),
            child: Column(
              children: [
                AppBar(

                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: const Text(
                      'Policy Pilot',
                    style: TextStyle(
                      color: Color(0xFF371377),
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.shade50,
                        ),
                        child: Icon(
                          Icons.account_circle,
                          color: Color(0xFF371377),
                          size: 28,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),

                // Hero Slider Section
                SizedBox(
                  height: 180,
                  child: PageView.builder(
                    controller: _heroController,
                    itemCount: _heroItems.length,
                    itemBuilder: (context, index) {
                      final item = _heroItems[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => item['route']),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  item['color'],
                                  Color.lerp(item['color'], Colors.black, 0.2)!,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: item['color'].withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item['title'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item['subtitle'],
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Dots indicator for hero slider
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _heroItems.length,
                          (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index
                              ? Color(0xFF371377)
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _screens[_currentIndex],
            ),
          ),
        ],
      ),

      // Enhanced Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade100,
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedItemColor: const Color(0xFF371377),
            unselectedItemColor: Colors.grey.shade600,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == 0
                        ? Colors.blue.shade50
                        : Colors.transparent,
                  ),
                  child: const Icon(Icons.home_outlined),
                ),
                activeIcon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.shade50,
                  ),
                  child: const Icon(Icons.home),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == 1
                        ? Colors.blue.shade50
                        : Colors.transparent,
                  ),
                  child: const Icon(Icons.health_and_safety_outlined),
                ),
                activeIcon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.shade50,
                  ),
                  child: const Icon(Icons.health_and_safety),
                ),
                label: 'Insurance',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == 2
                        ? Colors.blue.shade50
                        : Colors.transparent,
                  ),
                  child: const Icon(Icons.calculate_outlined),
                ),
                activeIcon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.shade50,
                  ),
                  child: const Icon(Icons.calculate),
                ),
                label: 'Loans',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == 3
                        ? Colors.blue.shade50
                        : Colors.transparent,
                  ),
                  child: const Icon(Icons.insights_outlined),
                ),
                activeIcon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.shade50,
                  ),
                  child: const Icon(Icons.insights),
                ),
                label: 'Insights',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Access Section
          const Text(
            'Quick Access',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),

          // Feature cards with improved UI
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildFeatureCard(
                context,
                icon: Icons.health_and_safety,
                title: 'Insurance Tools',
                color: Color(0xFF0B4971),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InsuranceToolsScreen()),
                  );
                },
              ),
              _buildFeatureCard(
                context,
                icon: Icons.calculate,
                title: 'Loan Calculator',
                color: Colors.green.shade700,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoanCalculatorScreen()),
                  );
                },
              ),
              _buildFeatureCard(
                context,
                icon: Icons.adb_outlined,
                title: 'AI Advisor',
                color: Colors.purple.shade700,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AIAdvisorScreen()),
                  );
                },
              ),
              _buildFeatureCard(
                context,
                icon: Icons.analytics,
                title: 'Risk Profiler',
                color: Colors.orange.shade700,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RiskProfilerScreen()),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Promotional Banner with better design
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Color(0xFF3F5EC5),
                  Color(0xFF0C4777),
                  Color(0xFF10435E),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.white, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Premium Feature",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Upgrade to unlock advanced tools and insights",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Recent Activity Section
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          _buildActivityItem(
            icon: Icons.receipt,
            title: 'Policy Renewal',
            subtitle: 'Your health insurance is due in 15 days',
            color: Colors.red.shade100,
            iconColor: Colors.red,
          ),
          _buildActivityItem(
            icon: Icons.check_circle,
            title: 'Payment Received',
            subtitle: 'Loan EMI paid successfully',
            color: Colors.green.shade100,
            iconColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 30, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap to explore',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}







class InsuranceToolsScreen extends StatelessWidget {
  const InsuranceToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE6F2FF),
            Color(0xFFF0F8FF),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Insurance Tools',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildToolCard(
              context,
              icon: Icons.monetization_on,
              color: Colors.blue,
              title: 'Life Insurance Premium Prediction',
              destination: const PremiumPredictionScreen(),
            ),
            _buildToolCard(
              context,
              icon: Icons.analytics,
              color: Colors.green,
              title: 'Risk Profiling & Underwriting',
              destination: const RiskProfilerScreen(),
            ),
            _buildToolCard(
              context,
              icon: Icons.adb_rounded,
              color: Colors.purple,
              title: 'AI Policy Recommendation',
              destination: const AIAdvisorScreen(),
            ),
            _buildToolCard(
              context,
              icon: Icons.warning,
              color: Colors.orange,
              title: 'Claim Fraud Detection',
              destination: const FraudDetectionScreen(),
            ),
            _buildToolCard(
              context,
              icon: Icons.people,
              color: Colors.teal,
              title: 'Inclusivity Index Calculator',
              destination: const InclusivityIndexScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard(
      BuildContext context, {
        required IconData icon,
        required Color color,
        required String title,
        required Widget destination,
      }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) => destination,
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoanCalculatorScreen extends StatefulWidget {
  const LoanCalculatorScreen({super.key});

  @override
  State<LoanCalculatorScreen> createState() => _LoanCalculatorScreenState();
}

class _LoanCalculatorScreenState extends State<LoanCalculatorScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  double _loanAmount = 10000;
  double _interestRate = 5.0;
  int _loanTerm = 12;
  double _monthlyPayment = 0;
  double _totalPayment = 0;
  double _totalInterest = 0;
  bool _showResults = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _calculateLoan() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      double monthlyRate = _interestRate / 100 / 12;
      int numberOfPayments = _loanTerm;

      _monthlyPayment = _loanAmount *
          (monthlyRate * pow(1 + monthlyRate, numberOfPayments)) /
          (pow(1 + monthlyRate, numberOfPayments) - 1);

      _totalPayment = _monthlyPayment * numberOfPayments;
      _totalInterest = _totalPayment - _loanAmount;

      setState(() {
        _showResults = true;
      });

      _animationController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE6F2FF),
            Color(0xFFF0F8FF),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Loan Calculator',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Loan Amount',
                          prefixIcon: const Icon(Icons.attach_money),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _loanAmount.toString(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter loan amount';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _loanAmount = double.parse(value!);
                        },
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Interest Rate: ${_interestRate.toStringAsFixed(2)}%',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          Slider(
                            value: _interestRate,
                            min: 1,
                            max: 20,
                            divisions: 190,
                            label: _interestRate.toStringAsFixed(2),
                            onChanged: (value) {
                              setState(() {
                                _interestRate = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Loan Term: $_loanTerm months',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          Slider(
                            value: _loanTerm.toDouble(),
                            min: 1,
                            max: 60,
                            divisions: 59,
                            label: _loanTerm.toString(),
                            onChanged: (value) {
                              setState(() {
                                _loanTerm = value.toInt();
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          ),
                          onPressed: _calculateLoan,
                          child: Text(
                            'Calculate',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_showResults) ...[
                const SizedBox(height: 24),
                FadeTransition(
                  opacity: _animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(_animation),
                    child: Text(
                      'Loan Summary',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FadeTransition(
                  opacity: _animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(_animation),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildResultRow(
                              'Monthly Payment',
                              _monthlyPayment,
                              Icons.payment,
                              Colors.blue,
                            ),
                            const Divider(),
                            _buildResultRow(
                              'Total Payment',
                              _totalPayment,
                              Icons.money,
                              Colors.green,
                            ),
                            const Divider(),
                            _buildResultRow(
                              'Total Interest',
                              _totalInterest,
                              Icons.trending_up,
                              Colors.orange,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeTransition(
                  opacity: _animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(_animation),
                    child: Text(
                      'Payment Schedule',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FadeTransition(
                  opacity: _animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(_animation),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: List.generate(
                            _loanTerm > 12 ? 12 : _loanTerm,
                                (index) => Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue.shade100,
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  title: Text(
                                    'Month ${index + 1}',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  trailing: Text(
                                    NumberFormat.currency(
                                      symbol: '\$',
                                      decimalDigits: 2,
                                    ).format(_monthlyPayment),
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (index < (_loanTerm > 12 ? 11 : _loanTerm - 1))
                                  const Divider(height: 1),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeTransition(
                  opacity: _animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(_animation),
                    child: SizedBox(
                      height: 200,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: BarChart(
                            BarChartData(
                              barGroups: [
                                BarChartGroupData(
                                  x: 0,
                                  barRods: [
                                    BarChartRodData(
                                      toY: _loanAmount,
                                      color: Colors.blue,
                                      width: 20,
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 1,
                                  barRods: [
                                    BarChartRodData(
                                      toY: _totalInterest,
                                      color: Colors.orange,
                                      width: 20,
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 2,
                                  barRods: [
                                    BarChartRodData(
                                      toY: _totalPayment,
                                      color: Colors.green,
                                      width: 20,
                                    ),
                                  ],
                                ),
                              ],
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: true),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      switch (value.toInt()) {
                                        case 0:
                                          return const Text('Principal');
                                        case 1:
                                          return const Text('Interest');
                                        case 2:
                                          return const Text('Total');
                                        default:
                                          return const Text('');
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (_loanTerm > 12)
                  FadeTransition(
                    opacity: _animation,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'View Full Schedule',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, double value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Text(
            NumberFormat.currency(
              symbol: '\$',
              decimalDigits: 2,
            ).format(value),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class PremiumPredictionScreen extends StatefulWidget {
  const PremiumPredictionScreen({super.key});

  @override
  State<PremiumPredictionScreen> createState() => _PremiumPredictionScreenState();
}

class _PremiumPredictionScreenState extends State<PremiumPredictionScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  int _age = 30;
  String _gender = 'Male';
  bool _smoker = false;
  double _coverageAmount = 100000;
  int _term = 20;
  String _healthStatus = 'Excellent';
  String _predictionResult = '';
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<String> _healthOptions = [
    'Excellent',
    'Good',
    'Average',
    'Poor'
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _predictPremium() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        final model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: 'AIzaSyA0dr_zXm5Bl-Vr1gizLi4tFBpekPpO3wA',
        );

        final prompt = """
        Estimate a life insurance premium based on these parameters:
        - Age: $_age
        - Gender: $_gender
        - Smoker: $_smoker
        - Coverage Amount: \$${_coverageAmount.toStringAsFixed(0)}
        - Term: $_term years
        - Health Status: $_healthStatus
        
        Provide the response in this format:
        
        **Estimated Premium**: [amount]
        **Factors Considered**:
        - [factor 1]
        - [factor 2]
        - [factor 3]
        
        **Recommendations**:
        - [recommendation 1]
        - [recommendation 2]
        """;

        final response = await model.generateContent([Content.text(prompt)]);
        setState(() {
          _predictionResult = response.text ?? 'Unable to generate prediction';
        });
        _animationController.forward(from: 0);
      } catch (e) {
        setState(() {
          _predictionResult = 'Error: $e';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Premium Prediction',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE6F2FF),
              Color(0xFFF0F8FF),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Age',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          initialValue: _age.toString(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter age';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _age = int.parse(value!);
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _gender,
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            prefixIcon: const Icon(Icons.transgender),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          items: ['Male', 'Female', 'Other']
                              .map((gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _gender = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          title: Text(
                            'Smoker',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          value: _smoker,
                          secondary: const Icon(Icons.smoking_rooms),
                          onChanged: (value) {
                            setState(() {
                              _smoker = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Coverage Amount (\$)',
                            prefixIcon: const Icon(Icons.attach_money),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          initialValue: _coverageAmount.toStringAsFixed(0),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter coverage amount';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _coverageAmount = double.parse(value!);
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Term (years)',
                            prefixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          initialValue: _term.toString(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter term';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _term = int.parse(value!);
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _healthStatus,
                          decoration: InputDecoration(
                            labelText: 'Health Status',
                            prefixIcon: const Icon(Icons.health_and_safety),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          items: _healthOptions
                              .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _healthStatus = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            ),
                            onPressed: _predictPremium,
                            child: Text(
                              'Predict Premium',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
                if (_predictionResult.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  FadeTransition(
                    opacity: _animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(_animation),
                      child: Text(
                        'Prediction Results',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: _animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(_animation),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _predictionResult,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 200,
                                child: LineChart(
                                  LineChartData(
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: [
                                          FlSpot(0, 100),
                                          FlSpot(1, 120),
                                          FlSpot(2, 150),
                                          FlSpot(3, 180),
                                          FlSpot(4, 200),
                                        ],
                                        isCurved: true,
                                        color: Colors.blue,
                                        barWidth: 4,
                                        belowBarData: BarAreaData(show: false),
                                      ),
                                    ],
                                    titlesData: FlTitlesData(
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (value, meta) {
                                            return Text('Year ${value.toInt() + 1}');
                                          },
                                        ),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RiskProfilerScreen extends StatefulWidget {
  const RiskProfilerScreen({super.key});

  @override
  State<RiskProfilerScreen> createState() => _RiskProfilerScreenState();
}

class _RiskProfilerScreenState extends State<RiskProfilerScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  int _age = 40;
  String _occupation = 'Office Worker';
  bool _hasDangerousHobbies = false;
  String _medicalHistory = 'None';
  String _familyHistory = 'None';
  String _riskProfile = '';
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<String> _occupations = [
    'Office Worker',
    'Construction Worker',
    'Healthcare Worker',
    'Pilot',
    'Professional Athlete',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _calculateRiskProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        final model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: 'AIzaSyA0dr_zXm5Bl-Vr1gizLi4tFBpekPpO3wA',
        );

        final prompt = """
        Analyze insurance risk profile based on these parameters:
        - Age: $_age
        - Occupation: $_occupation
        - Dangerous Hobbies: $_hasDangerousHobbies
        - Medical History: $_medicalHistory
        - Family History: $_familyHistory
        
        Provide analysis in this format:
        
        **Risk Profile**: [Low/Medium/High]
        **Risk Factors**:
        - [factor 1]
        - [factor 2]
        - [factor 3]
        
        **Underwriting Recommendations**:
        - [recommendation 1]
        - [recommendation 2]
        
        **Suggested Policy Adjustments**:
        - [adjustment 1]
        - [adjustment 2]
        """;

        final response = await model.generateContent([Content.text(prompt)]);
        setState(() {
          _riskProfile = response.text ?? 'Unable to generate risk profile';
        });
        _animationController.forward(from: 0);
      } catch (e) {
        setState(() {
          _riskProfile = 'Error analyzing claim: $e';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Risk Profiler',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE6F2FF),
              Color(0xFFF0F8FF),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Risk Profiling & Underwriting Automation',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Age',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          initialValue: _age.toString(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter age';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _age = int.parse(value!);
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _occupation,
                          decoration: InputDecoration(
                            labelText: 'Occupation',
                            prefixIcon: const Icon(Icons.work),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          items: _occupations
                              .map((job) => DropdownMenuItem(
                            value: job,
                            child: Text(job),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _occupation = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          title: Text(
                            'Dangerous Hobbies',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          subtitle: Text(
                            'e.g., skydiving, rock climbing',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          value: _hasDangerousHobbies,
                          secondary: const Icon(Icons.dangerous),
                          onChanged: (value) {
                            setState(() {
                              _hasDangerousHobbies = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Medical History',
                            prefixIcon: const Icon(Icons.medical_services),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          initialValue: _medicalHistory,
                          onSaved: (value) {
                            _medicalHistory = value!;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Family Medical History',
                            prefixIcon: const Icon(Icons.family_restroom),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          initialValue: _familyHistory,
                          onSaved: (value) {
                            _familyHistory = value!;
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            ),
                            onPressed: _calculateRiskProfile,
                            child: Text(
                              'Calculate Risk Profile',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
                if (_riskProfile.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  FadeTransition(
                    opacity: _animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(_animation),
                      child: Text(
                        'Risk Analysis',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: _animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(_animation),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _riskProfile,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 200,
                                child: PieChart(
                                  PieChartData(
                                    sections: [
                                      PieChartSectionData(
                                        value: 40,
                                        color: Colors.green,
                                        title: 'Low Risk',
                                        radius: 60,
                                      ),
                                      PieChartSectionData(
                                        value: 35,
                                        color: Colors.orange,
                                        title: 'Medium Risk',
                                        radius: 60,
                                      ),
                                      PieChartSectionData(
                                        value: 25,
                                        color: Colors.red,
                                        title: 'High Risk',
                                        radius: 60,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class AIAdvisorScreen extends StatefulWidget {
  const AIAdvisorScreen({super.key});

  @override
  State<AIAdvisorScreen> createState() => _AIAdvisorScreenState();
}

class _AIAdvisorScreenState extends State<AIAdvisorScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();

    // Add welcome message
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    final welcomeMessage = '''
👋 Hello! I'm your AI Insurance Advisor. 

I can help you with:
• Policy recommendations
• Coverage explanations
• Claims guidance
• Premium estimates
• Risk assessment

How can I assist you today?''';

    _messages.add(ChatMessage(
      text: welcomeMessage,
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final userMessage = _messageController.text;
    _messageController.clear();

    setState(() {
      _messages.add(ChatMessage(
        text: userMessage,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: 'AIzaSyA0dr_zXm5Bl-Vr1gizLi4tFBpekPpO3wA',
      );

      final history = _messages.map((msg) {
        return Content.text(msg.text);
      }).toList();

      final prompt = '''
You are an expert insurance advisor AI assistant. Provide clear, concise, and professional advice about insurance matters.
Format your responses with:
- Clear headings in bold
- Bullet points for lists
- Proper spacing between sections
- Simple, easy-to-understand language
- When appropriate, use emojis to enhance readability

Current conversation context:
${history.join('\n')}
''';

      final response = await model.generateContent([Content.text(prompt)]);

      setState(() {
        _messages.add(ChatMessage(
          text: response.text ?? "I couldn't understand that. Could you please rephrase your question?",
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _animationController.reset();
        _animationController.forward();
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: "⚠️ Sorry, I encountered an error. Please try again later.",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI Insurance Advisor',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
              Theme.of(context).colorScheme.primary.withOpacity(0.02),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ChatBubble(
                        key: ValueKey(message.timestamp),
                        message: message.text,
                        isUser: message.isUser,
                        timestamp: message.timestamp,
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Analyzing your request...',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(24),
                shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Ask about insurance policies...',
                            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).hintColor,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 3,
                          minLines: 1,
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send_rounded,
                            color: Theme.of(context).colorScheme.primary),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime timestamp;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: isUser ? const Radius.circular(18) : const Radius.circular(4),
              bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(18),
            ),
            color: isUser
                ? Theme.of(context).colorScheme.primary
                : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Format the message with rich text for better presentation
              RichText(
                text: TextSpan(
                  children: _parseMessage(message, isUser, context),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('h:mm a').format(timestamp),
                    style: TextStyle(
                      color: isUser ? Colors.white70 : Colors.grey.shade600,
                      fontSize: 10,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<TextSpan> _parseMessage(String text, bool isUser, BuildContext context) {
    final List<TextSpan> spans = [];
    final lines = text.split('\n');
    final textColor = isUser ? Colors.white : Theme.of(context).colorScheme.onSurface;

    for (var line in lines) {
      if (line.trim().isEmpty) {
        spans.add(const TextSpan(text: '\n'));
        continue;
      }

      // Check for bold patterns (simplified for this example)
      if (line.startsWith('**') && line.endsWith('**')) {
        spans.add(TextSpan(
          text: '${line.substring(2, line.length - 2)}\n',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ));
      } else if (line.startsWith('- ') || line.startsWith('• ')) {
        spans.add(TextSpan(
          text: '• ${line.substring(2)}\n',
          style: TextStyle(
            color: textColor,
            fontSize: 15,
          ),
        ));
      } else {
        spans.add(TextSpan(
          text: '$line\n',
          style: TextStyle(
            color: textColor,
            fontSize: 15,
          ),
        ));
      }
    }

    return spans;
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class FraudDetectionScreen extends StatefulWidget {
  const FraudDetectionScreen({super.key});

  @override
  State<FraudDetectionScreen> createState() => _FraudDetectionScreenState();
}

class _FraudDetectionScreenState extends State<FraudDetectionScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _claimDetailsController = TextEditingController();
  String _fraudAnalysis = '';
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _claimDetailsController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _analyzeClaim() async {
    if (_claimDetailsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter claim details')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: 'AIzaSyA0dr_zXm5Bl-Vr1gizLi4tFBpekPpO3wA',
      );

      final prompt = """
      Analyze this insurance claim for potential fraud indicators:
      
      Claim Details:
      ${_claimDetailsController.text}
      
      Provide analysis in this format:
      
      **Fraud Risk**: [Low/Medium/High]
      **Potential Red Flags**:
      - [Flag 1]
      - [Flag 2]
      - [Flag 3]
      
      **Recommendations**:
      - [Recommendation 1]
      - [Recommendation 2]
      
      **Next Steps**:
      - [Step 1]
      - [Step 2]
      """;

      final response = await model.generateContent([Content.text(prompt)]);
      setState(() {
        _fraudAnalysis = response.text ?? 'Unable to analyze claim';
        _animationController.reset();
        _animationController.forward();
      });
    } catch (e) {
      setState(() {
        _fraudAnalysis = 'Error analyzing claim: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fraud Detection',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE6F2FF),
              Color(0xFFF0F8FF),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.blue.shade50,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.warning, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              'Early Claim Fraud Detection',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _claimDetailsController,
                          maxLines: 8,
                          decoration: InputDecoration(
                            hintText: 'Enter claim details, policy information, and any suspicious observations...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.search),
                            label: const Text('Analyze for Fraud'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade400,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _analyzeClaim,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                  ),
                ),
              if (_fraudAnalysis.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text(
                  'Fraud Analysis Results',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          Colors.blue.shade50,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _fraudAnalysis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 200,
                            child: BarChart(
                              BarChartData(
                                barGroups: [
                                  BarChartGroupData(
                                    x: 0,
                                    barRods: [
                                      BarChartRodData(
                                        toY: 70,
                                        color: Colors.red,
                                        width: 20,
                                      ),
                                    ],
                                    showingTooltipIndicators: [0],
                                  ),
                                  BarChartGroupData(
                                    x: 1,
                                    barRods: [
                                      BarChartRodData(
                                        toY: 40,
                                        color: Colors.orange,
                                        width: 20,
                                      ),
                                    ],
                                    showingTooltipIndicators: [0],
                                  ),
                                  BarChartGroupData(
                                    x: 2,
                                    barRods: [
                                      BarChartRodData(
                                        toY: 20,
                                        color: Colors.green,
                                        width: 20,
                                      ),
                                    ],
                                    showingTooltipIndicators: [0],
                                  ),
                                ],
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: true),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        switch (value.toInt()) {
                                          case 0:
                                            return const Text('High Risk');
                                          case 1:
                                            return const Text('Medium Risk');
                                          case 2:
                                            return const Text('Low Risk');
                                          default:
                                            return const Text('');
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class InclusivityIndexScreen extends StatefulWidget {
  const InclusivityIndexScreen({super.key});

  @override
  State<InclusivityIndexScreen> createState() => _InclusivityIndexScreenState();
}

class _InclusivityIndexScreenState extends State<InclusivityIndexScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String _region = 'Urban';
  double _incomeLevel = 50000;
  double _educationRate = 70;
  double _awarenessLevel = 50;
  String _inclusivityResult = '';
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _calculateInclusivity() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        final model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: 'AIzaSyA0dr_zXm5Bl-Vr1gizLi4tFBpekPpO3wA',
        );

        final prompt = """
        Calculate an insurance inclusivity index based on these parameters:
        - Region: $_region
        - Average Income Level: \$${_incomeLevel.toStringAsFixed(0)}
        - Education Rate: ${_educationRate.toStringAsFixed(0)}%
        - Insurance Awareness: ${_awarenessLevel.toStringAsFixed(0)}%
        
        Provide the response in this format:
        
        **Inclusivity Index**: [score]/100
        **Interpretation**: [brief explanation]
        
        **Key Barriers**:
        - [Barrier 1]
        - [Barrier 2]
        
        **Recommendations for Improvement**:
        - [Recommendation 1]
        - [Recommendation 2]
        """;

        final response = await model.generateContent([Content.text(prompt)]);
        setState(() {
          _inclusivityResult = response.text ?? 'Unable to calculate index';
          _animationController.reset();
          _animationController.forward();
        });
      } catch (e) {
        setState(() {
          _inclusivityResult = 'Error: $e';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inclusivity Index',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE6F2FF),
              Color(0xFFF0F8FF),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          Colors.teal.shade50,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.people, color: Colors.teal),
                              SizedBox(width: 8),
                              Text(
                                'Insurance Penetration Inclusivity Index',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _region,
                            decoration: InputDecoration(
                              labelText: 'Region Type',
                              prefixIcon: const Icon(Icons.map),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.7),
                            ),
                            items: ['Urban', 'Suburban', 'Rural']
                                .map((region) => DropdownMenuItem(
                              value: region,
                              child: Text(region),
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _region = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Average Income: \$${_incomeLevel.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Slider(
                                value: _incomeLevel,
                                min: 10000,
                                max: 150000,
                                divisions: 14,
                                label: _incomeLevel.toStringAsFixed(0),
                                activeColor: Colors.teal,
                                inactiveColor: Colors.teal.shade100,
                                onChanged: (value) {
                                  setState(() {
                                    _incomeLevel = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Education Rate: ${_educationRate.toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Slider(
                                value: _educationRate,
                                min: 0,
                                max: 100,
                                divisions: 10,
                                label: _educationRate.toStringAsFixed(0),
                                activeColor: Colors.teal,
                                inactiveColor: Colors.teal.shade100,
                                onChanged: (value) {
                                  setState(() {
                                    _educationRate = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Insurance Awareness: ${_awarenessLevel.toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Slider(
                                value: _awarenessLevel,
                                min: 0,
                                max: 100,
                                divisions: 10,
                                label: _awarenessLevel.toStringAsFixed(0),
                                activeColor: Colors.teal,
                                inactiveColor: Colors.teal.shade100,
                                onChanged: (value) {
                                  setState(() {
                                    _awarenessLevel = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                              onPressed: _calculateInclusivity,
                              child: const Text(
                                'Calculate Inclusivity Index',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                      ),
                    ),
                  ),
                if (_inclusivityResult.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Inclusivity Analysis',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white,
                            Colors.teal.shade50,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _inclusivityResult,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 200,
                              child: LineChart(
                                LineChartData(
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: [
                                        FlSpot(0, 30),
                                        FlSpot(1, 45),
                                        FlSpot(2, 60),
                                        FlSpot(3, 75),
                                        FlSpot(4, 90),
                                      ],
                                      isCurved: true,
                                      color: Colors.teal,
                                      barWidth: 4,
                                      belowBarData: BarAreaData(show: false),
                                    ),
                                  ],
                                  titlesData: FlTitlesData(
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          return Text('Year ${value.toInt() + 1}');
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _questionController = TextEditingController();
  String _answer = '';
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _questionController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _getFinancialInsight() async {
    if (_questionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your question')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: 'AIzaSyA0dr_zXm5Bl-Vr1gizLi4tFBpekPpO3wA',
      );

      final prompt = """
      You are a financial advisor. Provide clear, concise advice on the following question:
      
      Question: ${_questionController.text}
      
      Provide your answer in markdown format with these sections:
      
      **Answer**
      [Your main answer]
      
      **Key Takeaways**
      - [Takeaway 1]
      - [Takeaway 2]
      
      **Additional Resources**
      [Any relevant resources or next steps]
      """;

      final response = await model.generateContent([Content.text(prompt)]);
      setState(() {
        _answer = response.text ?? 'No answer available';
        _animationController.reset();
        _animationController.forward();
      });
    } catch (e) {
      setState(() {
        _answer = 'Error getting insights: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Financial Insights',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE6F2FF),
              Color(0xFFF0F8FF),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Financial Insights',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Get AI-powered insights for your financial questions',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.purple.shade50,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: _questionController,
                          decoration: InputDecoration(
                            labelText: 'Ask a financial question',
                            prefixIcon: const Icon(Icons.question_mark),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.lightbulb),
                            label: const Text('Get Insight'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 4,
                            ),
                            onPressed: _getFinancialInsight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                    ),
                  ),
                ),
              if (_answer.isNotEmpty) ...[
                const Text(
                  'Insight',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          Colors.purple.shade50,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _answer,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 200,
                            child: PieChart(
                              PieChartData(
                                sections: [
                                  PieChartSectionData(
                                    value: 40,
                                    color: Colors.blue,
                                    title: 'Savings',
                                    radius: 60,
                                  ),
                                  PieChartSectionData(
                                    value: 30,
                                    color: Colors.green,
                                    title: 'Investments',
                                    radius: 60,
                                  ),
                                  PieChartSectionData(
                                    value: 20,
                                    color: Colors.orange,
                                    title: 'Expenses',
                                    radius: 60,
                                  ),
                                  PieChartSectionData(
                                    value: 10,
                                    color: Colors.red,
                                    title: 'Debt',
                                    radius: 60,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              const Text(
                'Quick Questions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildQuickQuestion('How to save for retirement?'),
                  _buildQuickQuestion('Best investment strategies?'),
                  _buildQuickQuestion('How to improve credit score?'),
                  _buildQuickQuestion('Tax saving tips?'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickQuestion(String question) {
    return ActionChip(
      label: Text(question),
      backgroundColor: Colors.purple.shade100,
      elevation: 2,
      onPressed: () {
        _questionController.text = question;
        _getFinancialInsight();
      },
    );
  }
}

double pow(double x, int exponent) {
  double result = 1;
  for (int i = 0; i < exponent; i++) {
    result *= x;
  }
  return result;
}