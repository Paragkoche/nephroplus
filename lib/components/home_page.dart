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
    gender: '',
    ethnicity: '',
    socioeconomicStatus: 0,
    educationLevel: 0,
    bmi: 0.0,
    smoking: 0,
    alcoholConsumption: 0,
    physicalActivity: 0,
    dietQuality: 0,
    sleepQuality: 0,
    familyHistoryKidneyDisease: 0,
    familyHistoryHypertension: 0,
    familyHistoryDiabetes: 0,
    previousAcuteKidneyInjury: 0,
    urinaryTractInfections: 0,
    systolicBP: 0,
    diastolicBP: 0,
    fastingBloodSugar: 0,
    hba1c: 0.0,
    serumCreatinine: 0.0,
    bunLevels: 0,
    gfr: 0,
    proteinInUrine: 0,
    acr: 0,
    serumCalcium: 0,
    serumPhosphorus: 0.0,
    serumPotassium: 0.0,
    serumSodium: 0.0,
    hemoglobinLevels: 0.0,
    cholesterolTotal: 0,
    cholesterolLDL: 0,
    cholesterolHDL: 0,
    cholesterolTriglycerides: 0,
    aceInhibitors: 0,
    diuretics: 0,
    statins: 0,
    heavyMetalsExposure: 0,
    occupationalExposureChemicals: 0,
    waterQuality: 0,
    medicalCheckupsFrequency: 0,
    medicationAdherence: 0,
    healthLiteracy: 0,
    edema: 0,
    fatigueLevels: 0,
    nauseaVomiting: 0,
    muscleCramps: 0,
    itching: 0,
    qualityOfLifeScore: 0,
    nsaisUse: 0,
    antidiabeticMedications: 0,
  );
  String _logRegPrediction = '';
  String _randForestPrediction = '';
  String _gradBoostPrediction = '';

  Future<void> _predict() async {
    final url = Uri.parse('https://backend-cdk.onrender.com/predict');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: _data.toJson(),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "Smoking (cigarettes/day)",
                    icons: const Icon(Icons.smoke_free),
                    validator:
                        RequiredValidator(errorText: "invalid smoking count"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.smoking = int.parse(value);
                    },
                    disable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "Alcohol Consumption (units/week)",
                    icons: const Icon(Icons.local_bar),
                    validator: RequiredValidator(
                        errorText: "invalid alcohol consumption"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.alcoholConsumption = int.parse(value);
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
                      }),
                )
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
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: DropdownMenu<int>(
                      width: 300,
                      label: const Text("Urinary Tract Infections "),
                      dropdownMenuEntries: const [
                        DropdownMenuEntry<int>(value: 1, label: "Yes"),
                        DropdownMenuEntry<int>(value: 0, label: "No"),
                      ],
                      onSelected: (int? value) {
                        //     validator: RequiredValidator(
                        //         errorText: "invalid medical history input"),
                        //     keyboardType: TextInputType.number,
                        //     onChange: (value) {
                        //       _data.urinaryTractInfections = int.parse(value);
                        //     },
                        //     disable: false,
                        //   ),
                        _data.urinaryTractInfections = value!;
                      }),
                ),
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
                      }),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: DropdownMenu<int>(
                      width: 300,
                      label: const Text("Heavy Metals Exposure"),
                      dropdownMenuEntries: const [
                        DropdownMenuEntry<int>(value: 1, label: "Yes"),
                        DropdownMenuEntry<int>(value: 0, label: "No"),
                      ],
                      onSelected: (int? value) {
                        _data.heavyMetalsExposure = value!;
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: DropdownMenu<int>(
                      width: 300,
                      label: const Text("Occupational Exposure to Chemicals"),
                      dropdownMenuEntries: const [
                        DropdownMenuEntry<int>(value: 1, label: "Yes"),
                        DropdownMenuEntry<int>(value: 0, label: "No"),
                      ],
                      onSelected: (int? value) {
                        _data.occupationalExposureChemicals = value!;
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: DropdownMenu<int>(
                      width: 300,
                      label: const Text("Water Quality"),
                      dropdownMenuEntries: const [
                        DropdownMenuEntry<int>(value: 1, label: "Yes"),
                        DropdownMenuEntry<int>(value: 0, label: "No"),
                      ],
                      onSelected: (int? value) {
                        _data.waterQuality = value!;
                      }),
                ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "Medical Checkups Frequency",
                    icons: const Icon(Icons.access_time),
                    validator: RequiredValidator(
                        errorText: "invalid checkups frequency"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.medicalCheckupsFrequency = int.parse(value);
                    },
                    disable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: DropdownMenu<int>(
                      width: 300,
                      label: const Text("Medication Adherence "),
                      dropdownMenuEntries: const [
                        DropdownMenuEntry<int>(value: 1, label: "Yes"),
                        DropdownMenuEntry<int>(value: 0, label: "No"),
                      ],
                      onSelected: (int? value) {
                        _data.medicationAdherence = value!;
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: DropdownMenu<int>(
                      width: 300,
                      label: const Text("Health Literacy"),
                      dropdownMenuEntries: const [
                        DropdownMenuEntry<int>(value: 1, label: "Yes"),
                        DropdownMenuEntry<int>(value: 0, label: "No"),
                      ],
                      onSelected: (int? value) {
                        _data.healthLiteracy = value!;
                      }),
                ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: DropdownMenu<int>(
                      width: 300,
                      label: const Text("Nausea/Vomiting"),
                      dropdownMenuEntries: const [
                        DropdownMenuEntry<int>(value: 1, label: "Yes"),
                        DropdownMenuEntry<int>(value: 0, label: "No"),
                      ],
                      onSelected: (int? value) {
                        _data.nauseaVomiting = value!;
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: DropdownMenu<int>(
                      width: 300,
                      label: const Text("Muscle Cramps"),
                      dropdownMenuEntries: const [
                        DropdownMenuEntry<int>(value: 1, label: "Yes"),
                        DropdownMenuEntry<int>(value: 0, label: "No"),
                      ],
                      onSelected: (int? value) {
                        _data.muscleCramps = value!;
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: DropdownMenu<int>(
                      width: 300,
                      label: const Text("Itching"),
                      dropdownMenuEntries: const [
                        DropdownMenuEntry<int>(value: 1, label: "Yes"),
                        DropdownMenuEntry<int>(value: 0, label: "No"),
                      ],
                      onSelected: (int? value) {
                        _data.itching = value!;
                      }),
                ),
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
                      label: const Text("NSAIDs Use"),
                      dropdownMenuEntries: const [
                        DropdownMenuEntry<int>(value: 1, label: "Yes"),
                        DropdownMenuEntry<int>(value: 0, label: "No"),
                      ],
                      onSelected: (int? value) {
                        _data.nsaisUse = value!;
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: DropdownMenu<int>(
                      width: 300,
                      label: const Text("Antidiabetic Medications"),
                      dropdownMenuEntries: const [
                        DropdownMenuEntry<int>(value: 1, label: "Yes"),
                        DropdownMenuEntry<int>(value: 0, label: "No"),
                      ],
                      onSelected: (int? value) {
                        _data.antidiabeticMedications = value!;
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }
}
