import 'package:cloud_firestore/cloud_firestore.dart';

class CountryService {
  static Future<Map<String, dynamic>> getCountryData(String country) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('countries')
          .doc(country)
          .get();

      if (!doc.exists) {
        print("❌ Country not found");
        return {};
      }

      final data = doc.data()!;
      print("✅ DATA: $data");

      return data;
    } catch (e) {
      print("🔥 Error: $e");
      return {};
    }
  }
}
