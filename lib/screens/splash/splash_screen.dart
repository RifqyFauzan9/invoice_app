import 'package:flutter/material.dart';
import 'package:my_invoice_app/screens/splash/splash_content.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:my_invoice_app/static/splash_data.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getPropScreenWidth(25),
          vertical: getPropScreenWidth(60),
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              currentPage == 0
                  ? buildSkipButton(context)
                  : SizedBox(height: SizeConfig.screenHeight * 0.043),
              SizedBox(height: SizeConfig.screenHeight * 0.09),
              Expanded(
                flex: 11,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: splashData.length,
                  itemBuilder: (context, index) => SplashContent(
                    title: splashData[index]["title"]!,
                    subtitle: splashData[index]["subtitle"]!,
                    image: splashData[index]["image"]!,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: getPropScreenWidth(16)),
                  child: Column(
                    children: [
                      // Dot Builder
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          splashData.length,
                          (index) => dotBuilder(index: index),
                        ),
                      ),
                      const Spacer(),
                      // Button
                      FilledButton(
                        onPressed: () {
                          if (currentPage < splashData.length - 1) {
                            setState(() {
                              currentPage++;
                            });
                            _pageController.animateToPage(
                              currentPage,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            Navigator.pushNamed(
                                context, ScreenRoute.login.route);
                          }
                        },
                        child: Text('Continue'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  AnimatedContainer dotBuilder({required int index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: currentPage == index ? 20 : 8,
      decoration: BoxDecoration(
        color: currentPage == index
            ? Theme.of(context).colorScheme.primary
            : const Color(0xffd8d8d8),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
