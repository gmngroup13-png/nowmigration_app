import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'country.dart';
import 'submit.dart';

class ConfirmPage extends StatefulWidget {
  final String country;
  final String region;
  final String course;
  final List<File> images;

  const ConfirmPage({
    super.key,
    required this.country,
    required this.region,
    required this.course,
    required this.images,
  });

  @override
  State<ConfirmPage> createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  /// 🔥 Upload images to Firebase Storage

  Future<List<String>> uploadImages(String docId) async {
    List<String> urls = [];

    const cloudName = "dyau1rfsv";
    const uploadPreset = "yb9yezty";

    for (int i = 0; i < widget.images.length; i++) {
      final file = widget.images[i];

      if (!file.existsSync()) {
        debugPrint("File missing: ${file.path}");
        continue;
      }

      try {
        debugPrint("Uploading image $i...");

        var request = http.MultipartRequest(
          'POST',
          Uri.parse(
            "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
          ),
        );

        request.fields['upload_preset'] = uploadPreset;

        // Upload into your custom folder
        request.fields['folder'] = 'Nowmigration_applications/$docId';

        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            file.path,
          ),
        );

        final response = await request.send();

        if (response.statusCode == 200) {
          final responseData =
              jsonDecode(await response.stream.bytesToString());

          final imageUrl = responseData['secure_url'];

          urls.add(imageUrl);

          debugPrint("Uploaded image $i");
          debugPrint(imageUrl);
        } else {
          final error = await response.stream.bytesToString();

          debugPrint(
            "Upload failed: ${response.statusCode}",
          );
          debugPrint(error);
        }
      } catch (e) {
        debugPrint("Cloudinary error: $e");
      }
    }

    return urls;
  }

  /// ✅ SAVE APPLICATION (Firestore + Images)
  Future<void> saveApplication(String email) async {
    try {
      debugPrint("🔥 STEP 1: Creating application (auto ID)");

      final docRef =
          FirebaseFirestore.instance.collection('applications').doc();

      final docId = docRef.id;

      debugPrint("🔥 STEP 2: Uploading images...");

      final imageUrls = await uploadImages(docId);

      await docRef.set({
        "id": docId,
        "country": widget.country,
        "region": widget.region,
        "course": widget.course,
        "email": email,
        "images": imageUrls,
        "createdAt": FieldValue.serverTimestamp(),
      });

      debugPrint("✅ STEP 3: Firestore write SUCCESS (ID: $docId)");
    } catch (e) {
      debugPrint("❌ FIRESTORE ERROR: $e");
      rethrow;
    }
  }

  bool isValidEmail(String email) {
    return RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(email);
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: TopWaveClipper(),
              child: Container(
                height: 180,
                color: const Color(0xFFC62828),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: BottomWaveClipper(),
              child: Container(
                height: 180,
                color: const Color(0xFFC62828),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: const Color(0xFF6CA8A2),
                        ),
                      ),
                      child: Text(
                        "Country: ${widget.country}\n"
                        "Region: ${widget.region}\n"
                        "Course: ${widget.course}",
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Please provide an email address:",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Email address",
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CountryPage(
                                  images: widget.images,
                                ),
                              ),
                            );
                          },
                          child: const Text("Edit"),
                        ),
                        const SizedBox(width: 20),
                        OutlinedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  final email = emailController.text.trim();

                                  if (email.isEmpty || !isValidEmail(email)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Enter valid email"),
                                      ),
                                    );
                                    return;
                                  }

                                  setState(() => isLoading = true);

                                  try {
                                    await saveApplication(email);

                                    if (!mounted) return;

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const SubmitPage(),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Error: $e"),
                                      ),
                                    );
                                  } finally {
                                    setState(() => isLoading = false);
                                  }
                                },
                          child: Text(
                            isLoading ? "Saving..." : "Confirm",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// keep your clippers unchanged
class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height + 20,
      size.width * 0.55,
      size.height - 35,
    );
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height - 80,
      size.width,
      size.height,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 60);
    path.quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, 40);
    path.quadraticBezierTo(size.width * 0.8, 100, size.width, 30);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
