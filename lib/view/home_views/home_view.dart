import 'package:civic_service_app/view/scheme_views/scheme_view.dart';
import 'package:civic_service_app/viewmodel/complaint_viewmodel.dart';
import 'package:civic_service_app/widgets/header/header.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:civic_service_app/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart'; // Add this import

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _carouselController = CarouselSliderController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int _currentIndex = 0;
  bool _isLoading = true;
  bool _isLoggedIn = false;

  // Local image assets list with corresponding URLs
  final List<Map<String, String>> _imageAssets = [
    {
      'asset': 'assets/schemes/IMG-20250915-WA0090.jpg',
      'url': 'https://www.myscheme.gov.in/schemes/mgnrega',
    },
    {
      'asset': 'assets/schemes/IMG-20250915-WA0091.jpg',
      'url':
          'https://schemes.vikaspedia.in/viewcontent/schemesall/schemes-for-farmers/pradhan-mantri-kisan-samman-nidhi?lgn=en',
    },
    {
      'asset': 'assets/schemes/IMG-20250915-WA0092.jpg',
      'url': 'https://www.nic.gov.in/project/pm-kisan/',
    },
    {
      'asset': 'assets/schemes/IMG-20250915-WA0093.jpg',
      'url': 'https://abdm.gov.in/',
    },
  ];

  // Local images for the horizontal list with corresponding URLs
  final List<Map<String, String>> _horizontalImageAssets = [
    {
      'asset': 'assets/mini_schemes/IMG-20250915-WA0084.jpg',
      'url':
          'https://www.myscheme.gov.in/search/category/Banking,Financial%20Services%20and%20Insurance',
    },
    {
      'asset': 'assets/mini_schemes/IMG-20250915-WA0085.jpg',
      'url':
          'https://www.myscheme.gov.in/search/category/Health%20&%20Wellness',
    },
    {
      'asset': 'assets/mini_schemes/IMG-20250915-WA0086.jpg',
      'url':
          'https://www.myscheme.gov.in/search/category/Agriculture,Rural%20&%20Environment',
    },
    {
      'asset': 'assets/mini_schemes/IMG-20250915-WA0087.jpg',
      'url':
          'https://www.myscheme.gov.in/search/category/Science,%20IT%20&%20Communications',
    },
    {
      'asset': 'assets/mini_schemes/IMG-20250915-WA0088.jpg',
      'url':
          'https://www.myscheme.gov.in/search/category/Skills%20&%20Employment',
    },
    {
      'asset': 'assets/mini_schemes/IMG-20250915-WA0089.jpg',
      'url': 'https://www.myscheme.gov.in/search/category/Travel%20&%20Tourism',
    },
    {
      'asset': 'assets/mini_schemes/IMG-20250915-WA0005.jpg',
      'url':
          'https://www.myscheme.gov.in/search/category/Housing%20&%20Shelter',
    },
  ];

  @override
  void initState() {
    super.initState();
    _autoAdvanceCarousel();
    _checkAuthStatus();
  }

  void _autoAdvanceCarousel() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _carouselController.nextPage();
        _autoAdvanceCarousel();
      }
    });
  }

  Future<void> _checkAuthStatus() async {
    try {
      final user = _auth.currentUser;
      setState(() {
        _isLoggedIn = user != null;
      });

      if (_isLoggedIn) {
        // Use the ViewModel to fetch the latest complaint
        final complaintViewModel = Provider.of<ComplaintViewModel>(
          context,
          listen: false,
        );
        await complaintViewModel.fetchLatestComplaints();
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isLoggedIn = false;
      });
    }
  }

  double _getProgressPercentage(Map<String, dynamic> complaint) {
    // Customize this based on your complaint status logic
    final status = complaint['status']?.toString().toLowerCase() ?? '';

    switch (status) {
      case 'submitted':
        return 0.25;
      case 'in_progress':
        return 0.5;
      case 'resolved':
        return 1.0;
      case 'rejected':
        return 0.0;
      default:
        return 0.1;
    }
  }

  String _getStatusText(Map<String, dynamic> complaint) {
    final status = complaint['status']?.toString() ?? 'Submitted';
    return status;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final complaintViewModel = Provider.of<ComplaintViewModel>(context);

    // Get the latest complaint from the ViewModel
    final latestComplaint = complaintViewModel.complaints.isNotEmpty
        ? complaintViewModel.complaints.first
        : null;

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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewScreen(
                            url: item['url']!,
                            title: 'Details',
                          ),
                        ),
                      );
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

              // Complaint Status Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _isLoading || complaintViewModel.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _isLoggedIn
                          ? latestComplaint != null
                                ? _buildComplaintProgress(
                                    latestComplaint,
                                    colorScheme,
                                  )
                                : _buildNoComplaintsPrompt(context)
                          : _buildLoginPrompt(context),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebViewScreen(
                                    url: item['url']!,
                                    title: 'Details',
                                  ),
                                ),
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

  Widget _buildComplaintProgress(
    Map<String, dynamic> complaint,
    ColorScheme colorScheme,
  ) {
    final progress = _getProgressPercentage(complaint);
    final status = _getStatusText(complaint);
    final complaintId = complaint['complaintId']?.toString() ?? 'N/A';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(
            context,
          )!.translate('progress_for_your_last_complaint'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Complaint ID: $complaintId',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),

        LinearPercentIndicator(
          lineHeight: 50.0,
          percent: progress,
          animation: true,
          animationDuration: 1200,
          barRadius: const Radius.circular(12),
          backgroundColor: Colors.grey[300]!,
          linearGradient: const LinearGradient(
            colors: [Colors.amber, Colors.yellow],
          ),
          center: Text(
            '${(progress * 100).toStringAsFixed(0)}% ${AppLocalizations.of(context)!.translate('completed')}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),

        const SizedBox(height: 16),
        Text(
          'Status: ${status.toUpperCase()}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _getStatusColor(status, colorScheme),
          ),
        ),
      ],
    );
  }

  Widget _buildNoComplaintsPrompt(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.report_problem, size: 64, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context)!.translate('no_complaints_found'),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.translate('add_complaint_to_track'),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.person_outline, size: 64, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(
            context,
          )!.translate('please_login_to_view_progress'),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.translate('login_to_track_complaints'),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Color _getStatusColor(String status, ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return Colors.blue;
      case 'in_progress':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return colorScheme.primary;
    }
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
