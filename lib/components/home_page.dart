// Suggested code may be subject to a license. Learn more: ~LicenseLog:1695780299.
import 'dart:convert';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'drawer.dart';
import 'package:nephropulse/components/input_text.dart';
import 'package:nephropulse/components/form_type.dart';
import 'package:nephropulse/components/datalist.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _noteController = TextEditingController();
  late AnimationController _animationController;

  int _currentStep = 0;
  final HealthData _data = HealthData(
    age: 0,
    ethnicity: "",
    gender: '',
    bmi: 0.0,
    familyHistoryKidneyDisease: 0,
    familyHistoryHypertension: 0,
    familyHistoryDiabetes: 0,
    previousAcuteKidneyInjury: 0,
    systolicBP: 0,
    diastolicBP: 0,
    fastingBloodSugar: 0,
    hba1c: 0.0,
    serumCreatinine: 0.0,
    gfr: 0,
    proteinInUrine: 0,
    hemoglobinLevels: 0.0,
    cholesterolLDL: 0,
    cholesterolHDL: 0,
    aceInhibitors: 0,
    diuretics: 0,
    statins: 0,
    edema: 0,
    fatigueLevels: 0,
    qualityOfLifeScore: 0,
  );
  String _logRegPrediction = '';
  String _randForestPrediction = '';
  String _gradBoostPrediction = '';

  Future<void> _predict() async {
    final url = Uri.parse('https://backend-cdk.onrender.com/predict');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "age": _data.age,
        "gender": _data.gender,
        "BMI": _data.bmi,
        "familyHistoryKidneyDisease": _data.familyHistoryKidneyDisease,
        "familyHistoryHypertension": _data.familyHistoryHypertension,
        "familyHistoryDiabetes": _data.familyHistoryDiabetes,
        "previousAcuteKidneyInjury": _data.previousAcuteKidneyInjury,
        "SystolicBP": _data.systolicBP,
        "DiastolicBP": _data.diastolicBP,
        "FastingBloodSugar": _data.fastingBloodSugar,
        "Hba1c": _data.hba1c,
        "SerumCreatinine": _data.serumCreatinine,
        "GFR": _data.gfr,
        "ProteinInUrine": _data.proteinInUrine,
        "HemoglobinLevels": _data.hemoglobinLevels,
        "CholesterolLDL": _data.cholesterolLDL,
        "CholesterolHDL": _data.cholesterolHDL,
        "aceInhibitors": _data.aceInhibitors,
        "diuretics": _data.diuretics,
        "statins": _data.statins,
        "Edema": _data.edema,
        "FatigueLevels": _data.fatigueLevels,
        "QualityOfLifeScore": _data.qualityOfLifeScore,
      }),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      _logRegPrediction = result['Logistic Regression Prediction'].toString();
      _randForestPrediction = result['Random Forest Prediction'].toString();
      _gradBoostPrediction = result['Gradient Boosting Prediction'].toString();
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Prediction Result'),
          content: Text(
              'The predicted: in Log Reg Prediction algo $_logRegPrediction , in rand-forest algo $_randForestPrediction, in grad boost algo $_gradBoostPrediction '),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      debugPrint(response.body);
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to get prediction. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  List<String> gender = ["Male", "Female"];

  late String userId;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
    } else {
      userId = '';
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFBB86FC), Color(0xFF3700B3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: AppBar(
              title: const Text(
                'Nephro Pulse',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
        ),
        drawer: const CustomDrawer(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Stepper(
              physics: const ScrollPhysics(),
              currentStep: _currentStep,
              onStepCancel: () => _currentStep == 0
                  ? null
                  : setState(() {
                      _currentStep -= 1;
                    }),
              onStepContinue: () {
                bool isLastStep = (_currentStep == _getSteps().length - 1);
                if (isLastStep) {
                  _predict();
                } else {
                  setState(() {
                    _currentStep += 1;
                  });
                }
              },
              onStepTapped: (step) => setState(() {
                _currentStep = step;
              }),
              steps: _getSteps(),
            ),
          ),
        ));
  }

  List<Step> _getSteps() {
    return [
      Step(
        title: const Text("Basic Information"),
        content: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "Age",
                    icons: const Icon(Icons.calculate),
                    validator: RequiredValidator(errorText: "invalid age"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.age = int.parse(value);
                    },
                    disable: false,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: DropdownMenu<String>(
                      width: 300,
                      initialSelection: _data.gender,
                      label: const Text("Gender"),
                      dropdownMenuEntries: gender.map((g) {
                        return DropdownMenuEntry<String>(value: g, label: g);
                      }).toList(),
                      onSelected: (value) {
                        _data.gender = value!;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: DropdownMenu<String>(
                      width: 300,
                      initialSelection: _data.ethnicity,
                      label: const Text('Select a country'),
                      dropdownMenuEntries: dataList.map((country) {
                        return DropdownMenuEntry<String>(
                          value: country['alpha_2_code']!,
                          label: country['en_short_name']!,
                        );
                      }).toList(),
                      onSelected: (String? newValue) {
                        setState(() {
                          _data.ethnicity = newValue!;
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      Step(
        title: const Text("Lifestyle and Habits"),
        content: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "BMI",
                    icons: const Icon(Icons.calculate),
                    validator: RequiredValidator(errorText: "invalid BMI"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.bmi = double.parse(value);
                    },
                    disable: false,
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 20),
                //   child: InputText(
                //     label: "Smoking (cigarettes/day)",
                //     icons: const Icon(Icons.smoke_free),
                //     validator:
                //         RequiredValidator(errorText: "invalid smoking count"),
                //     keyboardType: TextInputType.number,
                //     onChange: (value) {
                //       _data.smoking = int.parse(value);
                //     },
                //     disable: false,
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 20),
                //   child: InputText(
                //     label: "Alcohol Consumption (units/week)",
                //     icons: const Icon(Icons.local_bar),
                //     validator: RequiredValidator(
                //         errorText: "invalid alcohol consumption"),
                //     keyboardType: TextInputType.number,
                //     onChange: (value) {
                //       _data.alcoholConsumption = int.parse(value);
                //     },
                //     disable: false,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
      Step(
        title: const Text("Family History"),
        content: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: DropdownMenu<int>(
                    width: 300,
                    label: const Text("Family History of Kidney Disease"),
                    dropdownMenuEntries: const [
                      DropdownMenuEntry<int>(value: 1, label: "Yes"),
                      DropdownMenuEntry<int>(value: 0, label: "No"),
                    ],
                    onSelected: (int? value) {
                      _data.familyHistoryKidneyDisease = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: DropdownMenu<int>(
                    width: 300,
                    label: const Text("Family History of Hypertension"),
                    dropdownMenuEntries: const [
                      DropdownMenuEntry<int>(value: 1, label: "Yes"),
                      DropdownMenuEntry<int>(value: 0, label: "No"),
                    ],
                    onSelected: (int? value) {
                      _data.familyHistoryHypertension = value!;
                    },
                    // icons: const Icon(Icons.family_restroom),
                    // validator: RequiredValidator(
                    //     errorText: "invalid family history input"),
                    // keyboardType: TextInputType.number,
                    // onChange: (value) {
                    //   _data.familyHistoryHypertension = int.parse(value);
                    // },
                    // disable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: DropdownMenu<int>(
                      width: 300,
                      label: const Text("Family History of Diabetes"),
                      dropdownMenuEntries: const [
                        DropdownMenuEntry<int>(value: 1, label: "Yes"),
                        DropdownMenuEntry<int>(value: 0, label: "No"),
                      ],
                      onSelected: (int? value) {
                        _data.familyHistoryDiabetes = value!;
                      }
                      // validator: RequiredValidator(
                      //     errorText: "invalid family history input"),
                      // keyboardType: TextInputType.number,
                      // onChange: (value) {
                      //   _data.familyHistoryDiabetes = int.parse(value);
                      // },
                      // disable: false,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
      Step(
        title: const Text("Medical History"),
        content: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: DropdownMenu<int>(
                      width: 300,
                      label: const Text("Previous Acute Kidney Injury"),
                      dropdownMenuEntries: const [
                        DropdownMenuEntry<int>(value: 1, label: "Yes"),
                        DropdownMenuEntry<int>(value: 0, label: "No"),
                      ],
                      onSelected: (int? value) {
                        _data.previousAcuteKidneyInjury = value!;
                      }
                      // validator: RequiredValidator(
                      //     errorText: "invalid medical history input"),
                      // keyboardType: TextInputType.number,
                      // onChange: (value) {
                      //   _data.previousAcuteKidneyInjury = int.parse(value);
                      // },
                      // disable: false,
                      ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 20),
                //   child: InputText(
                //     label: "Urinary Tract Infections (0/1)",
                //     icons: const Icon(Icons.medical_services),
                //     validator: RequiredValidator(
                //         errorText: "invalid medical history input"),
                //     keyboardType: TextInputType.number,
                //     onChange: (value) {
                //       _data.urinaryTractInfections = int.parse(value);
                //     },
                //     disable: false,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
      Step(
        title: const Text("Lab Results"),
        content: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "Systolic Blood Pressure (mmHg)",
                    icons: const Icon(Icons.monitor_heart),
                    validator: RequiredValidator(
                        errorText: "invalid systolic blood pressure"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.systolicBP = int.parse(value);
                    },
                    disable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "Diastolic Blood Pressure (mmHg)",
                    icons: const Icon(Icons.monitor_heart),
                    validator: RequiredValidator(
                        errorText: "invalid diastolic blood pressure"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.diastolicBP = int.parse(value);
                    },
                    disable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "Fasting Blood Sugar (mg/dL)",
                    icons: const Icon(Icons.bloodtype),
                    validator: RequiredValidator(
                        errorText: "invalid fasting blood sugar"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.fastingBloodSugar = int.parse(value);
                    },
                    disable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "HbA1c (%)",
                    icons: const Icon(Icons.bloodtype),
                    validator:
                        RequiredValidator(errorText: "invalid HbA1c value"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.hba1c = double.parse(value);
                    },
                    disable: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Step(
        title: const Text("Medications"),
        content: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: DropdownMenu<int>(
                      width: 300,
                      label: const Text("ACE Inhibitors"),
                      dropdownMenuEntries: const [
                        DropdownMenuEntry<int>(value: 1, label: "Yes"),
                        DropdownMenuEntry<int>(value: 0, label: "No"),
                      ],
                      onSelected: (int? value) {
                        _data.aceInhibitors = value!;
                      }
                      // validator: RequiredValidator(
                      //     errorText: "invalid ACE inhibitors input"),
                      // keyboardType: TextInputType.number,
                      // onChange: (value) {
                      //   _data.aceInhibitors = int.parse(value);
                      // },
                      // disable: false,
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: DropdownMenu<int>(
                    width: 300,
                    label: const Text("Diuretics"),
                    dropdownMenuEntries: const [
                      DropdownMenuEntry<int>(value: 1, label: "Yes"),
                      DropdownMenuEntry<int>(value: 0, label: "No"),
                    ],
                    onSelected: (int? value) {
                      _data.diuretics = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: DropdownMenu<int>(
                    width: 300,
                    label: const Text("Statins"),
                    dropdownMenuEntries: const [
                      DropdownMenuEntry<int>(value: 1, label: "Yes"),
                      DropdownMenuEntry<int>(value: 0, label: "No"),
                    ],
                    onSelected: (int? value) {
                      _data.statins = value!;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Step(
        title: const Text("Environmental Factors"),
        content: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 20),
                //   child: InputText(
                //     label: "Heavy Metals Exposure (0/1)",
                //     icons: const Icon(Icons.exposure),
                //     validator: RequiredValidator(
                //         errorText: "invalid heavy metals exposure input"),
                //     keyboardType: TextInputType.number,
                //     onChange: (value) {
                //       _data.heavyMetalsExposure = int.parse(value);
                //     },
                //     disable: false,
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 20),
                //   child: InputText(
                //     label: "Occupational Exposure to Chemicals (0/1)",
                //     icons: const Icon(Icons.work),
                //     validator: RequiredValidator(
                //         errorText: "invalid occupational exposure input"),
                //     keyboardType: TextInputType.number,
                //     onChange: (value) {
                //       _data.occupationalExposureChemicals = int.parse(value);
                //     },
                //     disable: false,
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 20),
                //   child: InputText(
                //     label: "Water Quality (0/1)",
                //     icons: const Icon(Icons.water),
                //     validator: RequiredValidator(
                //         errorText: "invalid water quality input"),
                //     keyboardType: TextInputType.number,
                //     onChange: (value) {
                //       _data.waterQuality = int.parse(value);
                //     },
                //     disable: false,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
      Step(
        title: const Text("Checkups and Medication Adherence"),
        content: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 20),
                //   child: InputText(
                //     label: "Medical Checkups Frequency",
                //     icons: const Icon(Icons.access_time),
                //     validator: RequiredValidator(
                //         errorText: "invalid checkups frequency"),
                //     keyboardType: TextInputType.number,
                //     onChange: (value) {
                //       _data.medicalCheckupsFrequency = int.parse(value);
                //     },
                //     disable: false,
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 20),
                //   child: InputText(
                //     label: "Medication Adherence (0/1)",
                //     icons: const Icon(Icons.medication),
                //     validator: RequiredValidator(
                //         errorText: "invalid medication adherence input"),
                //     keyboardType: TextInputType.number,
                //     onChange: (value) {
                //       _data.medicationAdherence = int.parse(value);
                //     },
                //     disable: false,
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 20),
                //   child: InputText(
                //     label: "Health Literacy (0/1)",
                //     icons: const Icon(Icons.school),
                //     validator: RequiredValidator(
                //         errorText: "invalid health literacy input"),
                //     keyboardType: TextInputType.number,
                //     onChange: (value) {
                //       _data.healthLiteracy = int.parse(value);
                //     },
                //     disable: false,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
      Step(
        title: const Text("Symptoms and Quality of Life"),
        content: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: DropdownMenu<int>(
                    width: 300,
                    label: const Text("Edema"),
                    dropdownMenuEntries: const [
                      DropdownMenuEntry<int>(value: 1, label: "Yes"),
                      DropdownMenuEntry<int>(value: 0, label: "No"),
                    ],
                    onSelected: (int? value) {
                      _data.edema = value!;
                    },
                    // validator:
                    //     RequiredValidator(errorText: "invalid edema input"),
                    // keyboardType: TextInputType.number,
                    // onChange: (value) {
                    //   _data.edema = int.parse(value);
                    // },
                    // disable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: DropdownMenu<int>(
                    width: 300,
                    label: const Text("Fatigue Levels"),
                    dropdownMenuEntries: const [
                      DropdownMenuEntry<int>(value: 1, label: "Yes"),
                      DropdownMenuEntry<int>(value: 0, label: "No"),
                    ],
                    onSelected: (int? value) {
                      _data.fatigueLevels = value!;
                    },
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 20),
                //   child: InputText(
                //     label: "Nausea/Vomiting (0/1)",
                //     icons: const Icon(Icons.sick),
                //     validator: RequiredValidator(
                //         errorText: "invalid nausea/vomiting input"),
                //     keyboardType: TextInputType.number,
                //     onChange: (value) {
                //       _data.nauseaVomiting = int.parse(value);
                //     },
                //     disable: false,
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 20),
                //   child: InputText(
                //     label: "Muscle Cramps (0/1)",
                //     icons: const Icon(Icons.pregnant_woman),
                //     validator: RequiredValidator(
                //         errorText: "invalid muscle cramps input"),
                //     keyboardType: TextInputType.number,
                //     onChange: (value) {
                //       _data.muscleCramps = int.parse(value);
                //     },
                //     disable: false,
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 20),
                //   child: InputText(
                //     label: "Itching (0/1)",
                //     icons: const Icon(Icons.dry),
                //     validator:
                //         RequiredValidator(errorText: "invalid itching input"),
                //     keyboardType: TextInputType.number,
                //     onChange: (value) {
                //       _data.itching = int.parse(value);
                //     },
                //     disable: false,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "Quality of Life Score",
                    icons: const Icon(Icons.star),
                    validator: RequiredValidator(
                        errorText: "invalid quality of life score"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.qualityOfLifeScore = int.parse(value);
                    },
                    disable: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Step(
      //   title: const Text("Medications"),
      //   content: Card(
      //     child: Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.stretch,
      //         children: [
      //           Padding(
      //             padding: const EdgeInsets.symmetric(vertical: 20),
      //             child: InputText(
      //               label: "NSAIDs Use (0/1)",
      //               icons: const Icon(Icons.medication),
      //               validator: RequiredValidator(
      //                   errorText: "invalid NSAIDs use input"),
      //               keyboardType: TextInputType.number,
      //               onChange: (value) {
      //                 _data.nsaisUse = int.parse(value);
      //               },
      //               disable: false,
      //             ),
      //           ),
      //           Padding(
      //             padding: const EdgeInsets.symmetric(vertical: 20),
      //             child: InputText(
      //               label: "Antidiabetic Medications (0/1)",
      //               icons: const Icon(Icons.medication),
      //               validator: RequiredValidator(
      //                   errorText: "invalid antidiabetic medications input"),
      //               keyboardType: TextInputType.number,
      //               onChange: (value) {
      //                 _data.antidiabeticMedications = int.parse(value);
      //               },
      //               disable: false,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    ];
  }
}
