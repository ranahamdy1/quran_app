import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SurahListScreen extends StatefulWidget {
  final Function(int page) onSurahSelected;

  SurahListScreen({super.key, required this.onSurahSelected});

  @override
  _SurahListScreenState createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  final Dio _dio = Dio();
  List<String> surahNames = [];
  List<int> surahPages =
  [
    1, 2, 50, 77, 106, 128, 151, 177, 187, 208, 221, 235, 249, 255, 262, 267,
    282, 293, 305, 312, 322, 332, 342, 350, 359, 367, 377, 385, 396, 404, 411,
    415, 418, 428, 434, 440, 446, 453, 458, 467, 477, 483, 489, 496, 499, 502,
    507, 511, 515, 518, 520, 523, 526, 528, 531, 534, 537, 542, 545, 549, 551,
    553, 554, 556, 558, 560, 562, 564, 566, 568, 570, 572, 574, 575, 577, 578,
    580, 582, 583, 585, 586, 587, 587, 589, 590, 591, 591, 592, 593, 594, 595,
    595, 596, 596, 597, 597, 598, 598, 599, 599, 600, 600, 601, 601, 601, 602,
    602, 602, 603, 603, 603, 604, 604, 604
  ];

  List<String> surahNamesTest = [
    "الفاتحة", "البقرة", "آل عمران", "النساء", "المائدة", "الأنعام", "الأعراف",
    "الأنفال", "التوبة", "يونس", "هود", "يوسف", "الرعد", "إبراهيم", "الحجر",
    "النحل", "الإسراء", "الكهف", "مريم", "طه", "الأنبياء", "الحج", "المؤمنون",
    "النور", "الفرقان", "الشعراء", "النمل", "القصص", "العنكبوت", "الروم",
    "لقمان", "السجدة", "الأحزاب", "سبأ", "فاطر", "يس", "الصافات", "ص", "الزمر",
    "غافر", "فصلت", "الشورى", "الزخرف", "الدخان", "الجاثية", "الأحقاف", "محمد",
    "الفتح", "الحجرات", "ق", "الذاريات", "الطور", "النجم", "القمر", "الرحمن",
    "الواقعة", "الحديد", "المجادلة", "الحشر", "الممتحنة", "الصف", "الجمعة",
    "المنافقون", "التغابن", "الطلاق", "التحريم", "الملك", "القلم", "الحاقة",
    "المعارج", "نوح", "الجن", "المزمل", "المدثر", "القيامة", "الإنسان", "المرسلات",
    "النبأ", "النازعات", "عبس", "التكوير", "الانفطار", "المطففين", "الانشقاق", "البروج",
    "الطارق", "الأعلى", "الغاشية", "الفجر", "البلد", "الشمس", "الليل", "الضحى", "الشرح",
    "التين", "العلق", "القدر", "البينة", "الزلزلة", "العاديات", "القارعة", "التكاثر",
    "العصر", "الهمزة", "الفيل", "قريش", "الماعون", "الكوثر", "الكافرون", "النصر", "المسد",
    "الإخلاص", "الفلق", "الناس"
  ];



  bool _isLoading = true;

  Future<void> fetchSurahList() async {
    try {
      final response = await _dio.get('https://api.alquran.cloud/v1/surah');
      final data = response.data['data'] as List;

      setState(() {
        surahNames = data.map<String>((surah) => surah['name'] as String).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch surah list: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSurahList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('القرآن الكريم'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: surahNames.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(surahNames[index]),
            onTap: () {
              widget.onSurahSelected(surahPages[index]);
            },
          );
        },
      ),
    );
  }
}
