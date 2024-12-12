import 'package:flutter/material.dart';
import 'package:m_n_m/features/auth/screens/sign_up_screen.dart';
import '../../../common/onboarding_items.dart';
import '../../../common/widgets/custom_button_2.dart';
import '../../../constants/global_variables.dart';
import '../../home/screens/home_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(height: size.height * 0.0026),
                    _buildHeader(),
                    _buildImageSection(index),
                  ],
                );
              },
            ),
            _buildBottomSection(size),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 30,
            width: 140,
            child: Image.asset(
              'assets/images/logo.jpg',
              fit: BoxFit.fill,
            ),
          ),
          if (_currentPage < onboardingData.length - 1)
            TextButton(
              onPressed: () {
                _pageController.jumpToPage(onboardingData.length - 1);
              },
              child: Text(
                "Skip",
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.titleColor.withOpacity(0.6),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageSection(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 14.00),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Image.asset(
          onboardingData[index].imagePath,
          height: 350,
          width: 350,
        ),
      ),
    );
  }

  Widget _buildBottomSection(Size size) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: size.height * 0.35,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
          image: DecorationImage(
            image: const AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.3),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            children: [
              Text(
                textAlign: TextAlign.center,
                onboardingData[_currentPage].title,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                  color: AppColors.titleColor,
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                onboardingData[_currentPage].description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              _buildDotsIndicator(),
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: _buildNavigationButtons(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onboardingData.length,
        (index) => _buildDot(index),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    if (_currentPage == onboardingData.length - 1) {
      return CustomButton(
        onTap: (() => Navigator.pushNamed(context, SignUpScreen.routeName
            // HomeScreen.routeName
            )),
        title: 'Get Started',
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: _currentPage == 0
              ? null
              : () {
                  setState(() {
                    _currentPage--;
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  });
                },
          child: Text(
            'Back',
            style: _currentPage == 0
                ? const TextStyle(fontSize: 16, color: Colors.transparent)
                : const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _currentPage++;
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          },
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.primaryColor,
            ),
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Text(
                    'Next',
                    style: TextStyle(
                        fontSize: 18, color: AppColors.onPrimaryColor),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.arrow_forward_outlined,
                      color: AppColors.onPrimaryColor),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: _currentPage == index ? 36.0 : 18.0,
      height: 18.0,
      decoration: BoxDecoration(
        borderRadius: _currentPage == index ? BorderRadius.circular(8) : null,
        shape: _currentPage == index ? BoxShape.rectangle : BoxShape.circle,
        color: _currentPage == index
            ? AppColors.primaryColor
            : Colors.black.withOpacity(0.7),
      ),
    );
  }
}
