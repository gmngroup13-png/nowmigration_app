import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nowmigration_app/australia.dart';
import 'country_page_detail.dart';

class CountryPage extends StatelessWidget {
  final List<File> images;

  const CountryPage({
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

              const SizedBox(height: 10),

              // TITLE
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(text: "Select "),
                    TextSpan(
                      text: "Country",
                      style: TextStyle(
                        color: Color(0xFFB71C1C),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Container(
                width: 105,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFFB71C1C),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 80),

              // CANADA
              buildCountryButton(
                text: "Canada",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CountryPageDetail(
                        country: "Canada",
                        region: "Toronto",
                        images: images,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              // AUSTRALIA
              buildCountryButton(
                text: "Australia",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AustraliaPage(
                        images: images,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              // IRELAND
              buildCountryButton(
                text: "Ireland",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CountryPageDetail(
                        country: "Ireland",
                        region: "Dublin",
                        images: images,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              // MALTA
              buildCountryButton(
                text: "Malta",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CountryPageDetail(
                        country: "Malta",
                        region: "Kalkara",
                        images: images,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              // MAURITIUS
              buildCountryButton(
                text: "Mauritius",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CountryPageDetail(
                        country: "Mauritius",
                        region: "Montagne Blanche",
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

  Widget buildCountryButton({
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
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
