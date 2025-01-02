import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:quran_app/surah_list/view/surah_list_screen.dart';

class QuranPageViewer extends StatefulWidget {
  final int initialPage;

  const QuranPageViewer({Key? key, this.initialPage = 1}) : super(key: key);

  @override
  _QuranPageViewerState createState() => _QuranPageViewerState();
}

class _QuranPageViewerState extends State<QuranPageViewer> {
  final Dio _dio = Dio();
  late PageController _pageController; // PageController
  int _currentPage = 1;
  final Map<int, List<String>> _pagesCache = {};
  final Map<int, String> _surahNamesCache = {};
  bool _isLoading = false;

  Future<void> fetchPage(int pageNumber) async {
    if (_pagesCache.containsKey(pageNumber)) return;

    try {
      final response = await _dio.get(
        'https://api.alquran.cloud/v1/page/$pageNumber/quran-uthmani',
      );
      final data = response.data['data'];
      final ayahs = data['ayahs'] as List;

      setState(() {
        _pagesCache[pageNumber] = ayahs.map<String>((ayah) => '${ayah['text']} (${ayah['numberInSurah']})').toList();
        _surahNamesCache[pageNumber] = ayahs.isNotEmpty
            ? ayahs[0]['surah']['name'] ?? 'Unknown Surah'
            : 'Unknown Surah';
      });
    } catch (e) {
      print('Failed to load page: $e');
    }
  }

  void navigateToSurahList() async {
    final selectedPage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurahListScreen(
          onSurahSelected: (page) => Navigator.pop(context, page),
        ),
      ),
    );

    if (selectedPage != null) {
      setState(() {
        _currentPage = selectedPage;
      });
      _pageController.jumpToPage(_currentPage - 1); // Update PageController
      fetchPage(selectedPage);
    }
  }

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: _currentPage - 1); // Initialize PageController
    fetchPage(_currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('القرآن الكريم'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: navigateToSurahList,
          ),
        ],
      ),
      body: _isLoading && !_pagesCache.containsKey(_currentPage)
          ? const Center(child: CircularProgressIndicator())
          : PageView.builder(
        controller: _pageController, // Use PageController
        itemCount: 604,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index + 1;
          });
          fetchPage(_currentPage);
        },
        itemBuilder: (context, index) {
          final page = _pagesCache[index + 1] ?? [];
          final surahName = _surahNamesCache[index + 1] ?? 'اختر سورة';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Text(
                  surahName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: page.length,
                    itemBuilder: (context, i) {
                      return Text(
                        page[i],
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Page ${index + 1}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}