import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicines/components/language_constants.dart';

class BMI extends StatefulWidget {
  const BMI({super.key});

  @override
  State<BMI> createState() => _BMIState();
}

class _BMIState extends State<BMI> {
  final _formKey = GlobalKey<FormState>();

  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  final List<String> weightUnits = ['kg', 'lbs'];
  final List<String> heightUnits = ['cm', 'ft'];

  String selectedWeightUnit = 'kg';
  String selectedHeightUnit = 'cm';

  String yourBMITxt = '';
  double bmiValue = 0;
  String BMI_Value = '';
  String postComment = '';
  IconData? commentIcon;
  Color? bgColor;
  String idealWeightMessage = '';

  void calculateBMI() {
    try {
      final double weight = double.parse(_weightController.text.trim());
      final double height = double.parse(_heightController.text.trim());

      if (weight <= 0 || height <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(translation(context).bmiText6),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Convert units
      double weightInKg =
          selectedWeightUnit == 'lbs' ? weight * 0.453592 : weight;
      double heightInCm = selectedHeightUnit == 'ft' ? height * 30.48 : height;
      setState(() {
        bmiValue = weightInKg / ((heightInCm / 100) * (heightInCm / 100));
        bmiValue =
            double.parse(bmiValue.toStringAsFixed(1)); // Round to 1 decimal
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(translation(context).bmiText6),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void displayComment() {
    setState(() {
      yourBMITxt = translation(context).bmiText1;
      BMI_Value = bmiValue.toStringAsFixed(1);

      if (bmiValue < 18.5) {
        bgColor = Colors.orange[300];
        commentIcon = Icons.sentiment_dissatisfied;
        postComment = translation(context).bmiText2;
      } else if (bmiValue < 24.9) {
        bgColor = Colors.green[300];
        commentIcon = Icons.sentiment_very_satisfied;
        postComment = translation(context).bmiText3;
      } else {
        bgColor = Colors.red[300];
        commentIcon = Icons.sentiment_very_dissatisfied;
        postComment = translation(context).bmiText4;
      }

      // Ideal weight calculation
      double height = double.parse(_heightController.text);
      double heightInCm = selectedHeightUnit == 'ft' ? height * 30.48 : height;

// Robinson formula for men (for women, use slightly different calculation)
      double idealWeight = 52 + (1.9 * ((heightInCm / 2.54) - 60));
      idealWeightMessage =
          '${translation(context).bmiText5}${idealWeight.toStringAsFixed(2)} kg';
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          translation(context).bmiCal,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 5.0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Center(
          child: ListView(
            children: [
              const SizedBox(
                height: 15.0,
              ),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.asset(
                            'lib/assets/icons/weight-scale.gif',
                            color: const Color.fromARGB(255, 241, 250, 251),
                            colorBlendMode: BlendMode.darken,
                            height: 80.0,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.asset(
                            'lib/assets/icons/height.gif',
                            color: const Color.fromARGB(255, 241, 250, 251),
                            colorBlendMode: BlendMode.darken,
                            height: 80.0,
                          ),
                        ),
                      ]),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      translation(context).bmiText,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // TextField(
                        //   controller: _weightController,

                        //   title: 'Weight (kg)',
                        //   icon: Icons.scale,

                        // ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _weightController,
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.roboto(
                                  height: 2,
                                  color: const Color.fromARGB(255, 16, 15, 15),
                                ),
                                cursorColor:
                                    const Color.fromARGB(255, 7, 82, 96),
                                decoration: InputDecoration(
                                  filled: true,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        20,
                                      ),
                                    ),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 7, 82, 96),
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        20,
                                      ),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  labelText: translation(context).bmiform1,
                                  labelStyle: GoogleFonts.roboto(
                                    color:
                                        const Color.fromARGB(255, 16, 15, 15),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            DropdownButton<String>(
                              borderRadius: BorderRadius.circular(10),
                              dropdownColor:
                                  const Color.fromARGB(255, 220, 228, 232),
                              value: selectedWeightUnit,
                              items: weightUnits.map((String unit) {
                                return DropdownMenuItem<String>(
                                  value: unit,
                                  child: Text(unit),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedWeightUnit = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // TextField(
                        //   defaultController: _heightController,
                        //   title: 'Height (cm)',
                        //   icon: Icons.height,
                        // ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _heightController,
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.roboto(
                                  height: 2,
                                  color: const Color.fromARGB(255, 16, 15, 15),
                                ),
                                cursorColor:
                                    const Color.fromARGB(255, 7, 82, 96),
                                decoration: InputDecoration(
                                  filled: true,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  // fillColor: Colors.white,
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        20,
                                      ),
                                    ),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 7, 82, 96),
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        20,
                                      ),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  labelText: translation(context).bmiform2,
                                  labelStyle: GoogleFonts.roboto(
                                    color:
                                        const Color.fromARGB(255, 16, 15, 15),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            DropdownButton<String>(
                              value: selectedHeightUnit,
                              borderRadius: BorderRadius.circular(10),
                              dropdownColor:
                                  const Color.fromARGB(255, 220, 228, 232),
                              items: heightUnits.map((String? unit) {
                                return DropdownMenuItem<String>(
                                  value: unit,
                                  child: Text(
                                      unit ?? ''), // Ensure unit is non-null
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedHeightUnit = newValue ?? '';
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //calculate button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: FilledButton(
                      onPressed: () {
                        if (_weightController.text == '') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  const Color.fromARGB(255, 7, 83, 96),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                              content: Text(
                                translation(context).bmiText6,
                              ),
                            ),
                          );
                        } else if (_heightController.text == '') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  const Color.fromARGB(255, 7, 83, 96),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                              content: Text(
                                translation(context).bmiText7,
                              ),
                            ),
                          );
                        } else {
                          if (_formKey.currentState!.validate()) {
                            calculateBMI();
                            displayComment();
                          } else {
                            // Do nothing
                          }
                        }
                      },
                      style: const ButtonStyle(
                        elevation: MaterialStatePropertyAll(2),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      child: Text(
                        translation(context).bmiButton,
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: bgColor,
                    ),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          yourBMITxt,
                          style: const TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Text(
                        // bmiValue.toStringAsFixed(3),
                        BMI_Value,
                        style: const TextStyle(
                            fontSize: 35.0, fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              commentIcon,
                              size: 35.0,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              postComment,
                              style: const TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          idealWeightMessage,
                          style: const TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
