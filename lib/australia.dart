import 'dart:io';
import 'package:flutter/material.dart';
import 'country_page_detail.dart';

class AustraliaPage extends StatelessWidget {
  final List<File> images;

  const AustraliaPage({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            children: [
              // TOP BAR
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // TITLE
              const Text(
                "Select Region",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 5),

              Container(
                width: 105,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFFB71C1C),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 90),

              // SYDNEY
              buildRegionButton(
                text: "Sydney",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CountryPageDetail(
                        country: "Australia",
                        region: "Sydney",
                        images: images,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 35),

              // PERTH
              buildRegionButton(
                text: "Perth",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CountryPageDetail(
                        country: "Australia",
                        region: "Perth",
                        images: images,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 35),

              // MELBOURNE
              buildRegionButton(
                text: "Melbourne",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CountryPageDetail(
                        country: "Australia",
                        region: "Melbourne",
                        images: images,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRegionButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 230,
      height: 44,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          side: const BorderSide(
            color: Color(0xFF78AFA6),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
