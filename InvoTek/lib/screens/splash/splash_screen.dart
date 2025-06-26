import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:my_invoice_app/static/splash_data.dart';
import 'package:my_invoice_app/style/colors/invoice_color.dart';

import '../../static/screen_route.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getPropScreenWidth(25),
            vertical: getPropScreenWidth(50),
          ),
          child: Column(
            children: [
              _selectedIndex == 0
                  ? buildSkipButton(context)
                  : SizedBox(height: SizeConfig.screenHeight * 0.045),
              const Spacer(),
              SizedBox(
                height: 400,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  itemCount: splashData.length,
                  itemBuilder: (context, index) {
                    final data = splashData[index];
                    return SplashContent(
                      image: data['image']!,
                      title: data['title']!,
                      subtitle: data['subtitle']!,
                    );
                  },
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  splashData.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: AnimatedDot(isActive: _selectedIndex == index),
                  ),
                ),
              ),
              const Spacer(flex: 2),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getPropScreenWidth(16),
                ),
                child: FilledButton(
                  onPressed: () {
                    if (_selectedIndex < splashData.length - 1) {
                      setState(() {
                        _selectedIndex++;
                      });
                      _pageController.animateToPage(
                        _selectedIndex,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.pushNamed(context, ScreenRoute.login.route);
                    }
                  },
                  child: Text('Next'.toUpperCase()),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  Align buildSkipButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          ScreenRoute.login.route,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: Text(
            'Skip',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedDot extends StatelessWidget {
  const AnimatedDot({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 20 : 6,
      decoration: BoxDecoration(
        color: isActive
            ? InvoiceColor.primary.color
            : Color(0xFF868686).withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class SplashContent extends StatelessWidget {
  const SplashContent({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  final String image, title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: SvgPicture.asset(image),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
