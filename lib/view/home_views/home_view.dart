import 'package:civic_service_app/view/scheme_views/scheme_view.dart';
import 'package:civic_service_app/widgets/header/header.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:civic_service_app/l10n/app_localizations.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _carouselController = CarouselSliderController();
  int _currentIndex = 0;

  // Local image assets list with corresponding URLs
  final List<Map<String, String>> _imageAssets = [
    {
      'asset': 'assets/schemes/IMG-20250915-WA0090.jpg',
      'url':
          'https://www.myscheme.gov.in/schemes/mgnrega', // Replace with actual URL
    },
    {
      'asset': 'assets/schemes/IMG-20250915-WA0091.jpg',
      'url':
          'https://schemes.vikaspedia.in/viewcontent/schemesall/schemes-for-farmers/pradhan-mantri-kisan-samman-nidhi?lgn=en', // Replace with actual URL
    },
    {
      'asset': 'assets/schemes/IMG-20250915-WA0092.jpg',
      'url':
          'https://www.nic.gov.in/project/pm-kisan/', // Replace with actual URL
    },
    {
      'asset': 'assets/schemes/IMG-20250915-WA0093.jpg',
      'url': 'https://abdm.gov.in/', // Replace with actual URL
    },
  ];

  // Local images for the horizontal list with corresponding URLs
  final List<Map<String, String>> _horizontalImageAssets = [
    {
      'asset': 'assets/mini_schemes/IMG-20250915-WA0084.jpg',
      'url':
          'https://www.myscheme.gov.in/search/category/Banking,Financial%20Services%20and%20Insurance', // Replace with actual URL
    },
    {
      'asset': 'assets/mini_schemes/IMG-20250915-WA0085.jpg',
      'url':
          'https://www.myscheme.gov.in/search/category/Health%20&%20Wellness', // Replace with actual URL
    },
    {
      'asset': 'assets/mini_schemes/IMG-20250915-WA0086.jpg',
      'url':
          'https://www.myscheme.gov.in/search/category/Agriculture,Rural%20&%20Environment', // Replace with actual URL
    },
    {
      'asset': 'assets/mini_schemes/IMG-20250915-WA0087.jpg',
      'url':
          'https://www.myscheme.gov.in/search/category/Science,%20IT%20&%20Communications', // Replace with actual URL
    },
    {
      'asset': 'assets/mini_schemes/IMG-20250915-WA0088.jpg',
      'url':
          'https://www.myscheme.gov.in/search/category/Skills%20&%20Employment', // Replace with actual URL
    },
    {
      'asset': 'assets/mini_schemes/IMG-20250915-WA0089.jpg',
      'url':
          'https://www.myscheme.gov.in/search/category/Travel%20&%20Tourism', // Replace with actual URL
    },
    {
      'asset': 'assets/mini_schemes/IMG-20250915-WA0005.jpg',
      'url':
          'https://www.myscheme.gov.in/search/category/Housing%20&%20Shelter', // Replace with actual URL
    },
  ];

  @override
  void initState() {
    super.initState();
    _autoAdvanceCarousel();
  }

  void _autoAdvanceCarousel() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _carouselController.nextPage();
        _autoAdvanceCarousel();
      }
    });
  }

  // Function to launch URL in default browser

  // Function to open URL in embedded webvie

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.tertiary.withAlpha(175),
              colorScheme.primary.withAlpha(50),
              colorScheme.primary.withAlpha(25),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Header(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(
                      context,
                    )!.translate('search_for_ekyc'),
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
              CarouselSlider.builder(
                carouselController: _carouselController,
                options: CarouselOptions(
                  autoPlayAnimationDuration: const Duration(seconds: 2),
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: false,
                  viewportFraction: 0.85,
                  aspectRatio: 16 / 9,
                  enableInfiniteScroll: false,
                  padEnds: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                itemCount: _imageAssets.length,
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  final item = _imageAssets[index];
                  return GestureDetector(
                    onTap: () {
                      // Open in embedded webview when tapped
                      WebViewScreen(url: item['url']!, title: 'Details');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(50),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.asset(
                            item['asset']!,
                            fit: BoxFit.contain,
                            errorBuilder:
                                (
                                  BuildContext context,
                                  Object error,
                                  StackTrace? stackTrace,
                                ) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.error),
                                  );
                                },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _imageAssets.asMap().entries.map((entry) {
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 4.0,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.primary.withAlpha(
                        _currentIndex == entry.key ? 225 : 100,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(
                            context,
                          )!.translate('progress_for_your_last_complaint'),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        LinearPercentIndicator(
                          lineHeight: 50.0,
                          percent: 0.67,
                          animation: true,
                          animationDuration: 1200,
                          barRadius: const Radius.circular(12),
                          backgroundColor: Colors.grey[300]!,
                          linearGradient: const LinearGradient(
                            colors: [Colors.amber, Colors.yellow],
                          ),
                          center: Text(
                            AppLocalizations.of(
                              context,
                            )!.translate('x_completed', ['2', '3']),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSummaryItem(
                              AppLocalizations.of(
                                context,
                              )!.translate('pending'),
                              '3',
                              colorScheme.tertiary,
                            ),
                            _buildSummaryItem(
                              AppLocalizations.of(
                                context,
                              )!.translate('completed'),
                              '2',
                              colorScheme.primary,
                            ),

                            _buildSummaryItem(
                              AppLocalizations.of(
                                context,
                              )!.translate('completed'),
                              '1',
                              colorScheme.primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _horizontalImageAssets.length,
                        itemBuilder: (context, index) {
                          final item = _horizontalImageAssets[index];
                          return GestureDetector(
                            onTap: () {
                              WebViewScreen(
                                url: item['url']!,
                                title: 'Detials',
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      item['asset']!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              width: 100,
                                              height: 100,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.error),
                                            );
                                          },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withAlpha(100),
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
