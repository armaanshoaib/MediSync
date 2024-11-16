import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:medicines/components/medcard2.dart';

class DisplayMedInfo extends StatefulWidget {
  final String medicine;

  DisplayMedInfo({required this.medicine});

  @override
  _DisplayMedInfoState createState() => _DisplayMedInfoState();
}

class _DisplayMedInfoState extends State<DisplayMedInfo> {
  String additionalInfo = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchMedicineInfo(widget.medicine);
  }

  List<TextSpan> formatResponse(String response) {
    List<TextSpan> spans = [];
    bool isAsterisk = false;

    for (String part in response.split('*')) {
      if (isAsterisk) {
        // If this part was after an asterisk, style it specially
        spans.add(TextSpan(
            text: '',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)));
      }
      spans.add(TextSpan(text: part));
      isAsterisk = true; // Alternate between plain and styled text
    }

    return spans;
  }

  Future<void> fetchMedicineInfo(String medicine) async {
    // Update this URL to match your Flask server's address
    final url = Uri.parse(
        'http://43.204.82.67:6210/get_med_info'); // Use this for Android emulator
    // final url = Uri.parse('http://localhost:6210/get_med_info');  // Use this for iOS simulator

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "medicine_name": widget.medicine,
        }),
      );
      print(widget.medicine);
      print(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          additionalInfo =
              data["medicine_info"] ?? "No additional information found.";
        });
      } else {
        final errorData = json.decode(response.body);
        setState(() {
          additionalInfo =
              "Failed to load information: ${errorData['error'] ?? 'Unknown error'}";
        });
      }
    } catch (error) {
      setState(() {
        additionalInfo = "Error connecting to server: $error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MediSync"),
        backgroundColor: Color.fromARGB(255, 195, 193, 232),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Medicine Name: ",
              style: GoogleFonts.quicksand(
                textStyle: Theme.of(context).textTheme.displayLarge,
                color: Color.fromARGB(255, 18, 2, 62),
                fontSize: 25,
                // fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              widget.medicine,
              style: GoogleFonts.quicksand(
                textStyle: Theme.of(context).textTheme.displayLarge,
                color: const Color.fromARGB(255, 37, 198, 45),
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: RichText(
                      text: TextSpan(
                        children: formatResponse(additionalInfo),
                        style: GoogleFonts.quicksand(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          color: const Color.fromARGB(255, 45, 7, 7),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Go Back"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 236, 236, 240),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
