import 'dart:io';
import 'package:flutter/material.dart';
import 'confirm.dart';
import 'country_service.dart';

class CountryPageDetail extends StatefulWidget {
  final String country;
  final String region;
  final List<File> images;

  const CountryPageDetail({
    super.key,
    required this.country,
    required this.region,
    required this.images,
  });

  @override
  State<CountryPageDetail> createState() => _CountryPageDetailState();
}

class _CountryPageDetailState extends State<CountryPageDetail> {
  int maxCourses = 3;
  bool isLoading = true;

  Set<String> selectedCourses = {};
  Map<String, List<String>> courseData = {};

  @override
  void initState() {
    super.initState();
    loadCountryData();
  }

  String clean(String value) {
    return value
        .toLowerCase()
        .replaceAll('region-', '')
        .split(',')
        .first
        .trim();
  }

  Future<void> loadCountryData() async {
    try {
      final data = await CountryService.getCountryData(widget.country);

      if (data.isEmpty) {
        setState(() => isLoading = false);
        return;
      }

      maxCourses = int.tryParse(data['maxCourses'].toString()) ?? 3;

      final regionMap = Map<String, dynamic>.from(data['region'] ?? {});

      final regionKey = regionMap.keys.firstWhere(
        (key) => clean(key.toString()) == clean(widget.region),
        orElse: () => "",
      );

      if (regionKey.isEmpty) {
        setState(() => isLoading = false);
        return;
      }

      final regionData = Map<String, dynamic>.from(regionMap[regionKey] ?? {});

      Map<String, dynamic> coursesRaw = {};

      if (regionData.containsKey('categories')) {
        final categories =
            Map<String, dynamic>.from(regionData['categories'] ?? {});
        coursesRaw = Map<String, dynamic>.from(categories['courses'] ?? {});
      } else if (regionData.containsKey('courses')) {
        coursesRaw = Map<String, dynamic>.from(regionData['courses'] ?? {});
      }

      Map<String, List<String>> temp = {};

      coursesRaw.forEach((category, value) {
        if (value is List) {
          temp[category.toString()] = value.map((e) => e.toString()).toList();
        } else if (value is Map) {
          value.forEach((k, v) {
            if (v is List) {
              temp[k.toString()] = v.map((e) => e.toString()).toList();
            }
          });
        }
      });

      setState(() {
        courseData = temp;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("ERROR: $e");
      setState(() => isLoading = false);
    }
  }

  void toggleCourse(String course) {
    setState(() {
      if (selectedCourses.contains(course)) {
        selectedCourses.remove(course);
      } else {
        if (selectedCourses.length < maxCourses) {
          selectedCourses.add(course);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "You can only select $maxCourses courses",
              ),
            ),
          );
        }
      }
    });
  }

  bool get canProceed => selectedCourses.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: canProceed
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6CA8A2),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConfirmPage(
                          country: widget.country,
                          region: widget.region,
                          course: selectedCourses.join(", "),
                          images: widget.images,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Next",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              Text(
                "${widget.country} - ${widget.region}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              if (courseData.isEmpty) const Text("No courses available"),
              Expanded(
                child: ListView(
                  children: courseData.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            entry.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        ...entry.value.map((course) {
                          final selected = selectedCourses.contains(course);

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: InkWell(
                              onTap: () => toggleCourse(course),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selected
                                      ? const Color(0xFFE6F4F1)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF6CA8A2),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(child: Text(course)),
                                    if (selected)
                                      const Icon(
                                        Icons.check_circle,
                                        color: Color(0xFF6CA8A2),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
