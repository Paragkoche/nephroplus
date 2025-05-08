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
    Age: 0,
    Gender: '',
    Ethnicity: '',
    BMI: 0.0,
    Smoking: 0,
    AlcoholConsumption: 0,
    FamilyHistoryKidneyDisease: 0,
    FamilyHistoryHypertension: 0,
    FamilyHistoryDiabetes: 0,
    PreviousAcuteKidneyInjury: 0,
    UrinaryTractInfections: 0,
    SystolicBP: 0,
    DiastolicBP: 0,
    FastingBloodSugar: 0,
    HbA1c: 0.0,
    ACEInhibitors: 0,
    Diuretics: 0,
    Statins: 0,
    HeavyMetalsExposure: 0,
    OccupationalExposureChemicals: 0,
    WaterQuality: 0,
    MedicalCheckupsFrequency: 0,
    MedicationAdherence: 0,
    HealthLiteracy: 0,
    Edema: 0,
    FatigueLevels: 0,
    NauseaVomiting: 0,
    MuscleCramps: 0,
    Itching: 0,
    QualityOfLifeScore: 0,
    NSAIDsUse: 0,
    AntidiabeticMedications: 0,
    SocioeconomicStatus: 0,
    SleepQuality: 0,
    PhysicalActivity: 0,
    DietQuality: 0,
    SerumCreatinine: 0.0,
    EducationLevel: 0,
    SerumElectrolytesSodium: 0.0,
    SerumElectrolytesPotassium: 0.0,
    SerumElectrolytesCalcium: 0.0,
    SerumElectrolytesPhosphorus: 0.0,
    HemoglobinLevels: 0.0,
    CholesterolTotal: 0,
    CholesterolLDL: 0,
    CholesterolHDL: 0,
    CholesterolTriglycerides: 0,
    ACR: 0,
    BUNLevels: 0,
    GFR: 0,
    ProteinInUrine: 0,
  );
  String _logRegPrediction = '';
  String _randForestPrediction = '';
  String _gradBoostPrediction = '';
  void validate(int step) {
    bool _binary(int x) => x == 0 || x == 1;

    bool _inRange(int x, int min, int max) => x >= min && x <= max;

    void _validateBinary(int value, String field) {
      if (!_binary(value)) throw ArgumentError("$field must be 0 or 1");
    }

    // Case-by-case validation
    switch (step) {
      case 0:
        if (_data.Age < 0) throw ArgumentError("Age must be ≥ 0");
        // if (_data.SocioeconomicStatus < 1 || _data.SocioeconomicStatus > 5) {
        //   throw ArgumentError("SocioeconomicStatus must be between 1 and 5");
        // }
        // if (_data.EducationLevel < 1 || _data.EducationLevel > 5) {
        //   throw ArgumentError("EducationLevel must be between 1 and 5");
        // }

        break;

      case 1:
        // Validate BMI (should be a positive double, e.g., 10–60 as a reasonable human range)
        if (_data.BMI == null || _data.BMI <= 0 || _data.BMI > 100) {
          throw ArgumentError(
              "BMI must be a positive number within a realistic range (e.g., 10–100)");
        }

        // Validate Smoking (can be 0 or more cigarettes per day)
        if (_data.Smoking == null || _data.Smoking < 0) {
          throw ArgumentError("Smoking must be 0 or a positive integer");
        }

        // Validate Alcohol Consumption (can be 0 or more units per week)
        if (_data.AlcoholConsumption == null || _data.AlcoholConsumption < 0) {
          throw ArgumentError(
              "Alcohol Consumption must be 0 or a positive integer");
        }
        break;

      case 2:
        _validateBinary(
            _data.FamilyHistoryKidneyDisease, 'FamilyHistoryKidneyDisease');
        _validateBinary(
            _data.FamilyHistoryHypertension, 'FamilyHistoryHypertension');
        _validateBinary(_data.FamilyHistoryDiabetes, 'FamilyHistoryDiabetes');
        break;

      case 3:
        _validateBinary(
            _data.PreviousAcuteKidneyInjury, 'PreviousAcuteKidneyInjury');
        _validateBinary(_data.UrinaryTractInfections, 'UrinaryTractInfections');
        break;

      case 4:
        if (_data.SystolicBP < 0) throw ArgumentError("SystolicBP must be ≥ 0");
        if (_data.DiastolicBP < 0)
          throw ArgumentError("DiastolicBP must be ≥ 0");
        if (_data.FastingBloodSugar < 0)
          throw ArgumentError("FastingBloodSugar must be ≥ 0");
        if (_data.HbA1c < 0) throw ArgumentError("HbA1c must be ≥ 0");
        // if (_data.SerumCreatinine < 0)
        //   throw ArgumentError("SerumCreatinine must be ≥ 0");
        // if (_data.BUNLevels < 0) throw ArgumentError("BUNLevels must be ≥ 0");
        // if (_data.GFR < 0) throw ArgumentError("GFR must be ≥ 0");
        // _validateBinary(_data.ProteinInUrine, 'ProteinInUrine');
        // if (_data.ACR < 0) throw ArgumentError("ACR must be ≥ 0");
        break;

      case 5:
        _validateBinary(_data.ACEInhibitors, 'ACEInhibitors');
        _validateBinary(_data.Diuretics, 'Diuretics');
        _validateBinary(_data.Statins, 'Statins');
        break;

      case 6:
        _validateBinary(_data.HeavyMetalsExposure, 'HeavyMetalsExposure');
        _validateBinary(_data.OccupationalExposureChemicals,
            'OccupationalExposureChemicals');
        if (!_inRange(_data.WaterQuality, 1, 5))
          throw ArgumentError("WaterQuality must be 1–5");
        // if (!_inRange(_data.MedicalCheckupsFrequency, 1, 5))
        //   throw ArgumentError("MedicalCheckupsFrequency must be 1–5");
        // if (!_inRange(_data.MedicationAdherence, 1, 5))
        //   throw ArgumentError("MedicationAdherence must be 1–5");
        // if (!_inRange(_data.HealthLiteracy, 1, 5))
        //   throw ArgumentError("HealthLiteracy must be 1–5");
        break;

      case 7:
        // Step 7: Checkups and Medication Adherence
        // Validate Medical Checkups Frequency
        if (_data.MedicalCheckupsFrequency <= 0) {
          throw ArgumentError(
              "Medical Checkups Frequency must be a positive number");
        }

        // Validate Medication Adherence (binary: 0 or 1)
        _validateBinary(_data.MedicationAdherence, "Medication Adherence");

        // Validate Health Literacy (binary: 0 or 1)
        _validateBinary(_data.HealthLiteracy, "Health Literacy");
        break;

      case 8:
        // Step 8: Symptoms and Quality of Life
        // Validate Symptoms (binary: 0 or 1 for each symptom)
        _validateBinary(_data.Edema, "Edema");
        _validateBinary(_data.FatigueLevels, "Fatigue Levels");
        _validateBinary(_data.NauseaVomiting, "Nausea/Vomiting");
        _validateBinary(_data.MuscleCramps, "Muscle Cramps");
        _validateBinary(_data.Itching, "Itching");

        // Validate Quality of Life Score (numeric: within a reasonable range, e.g., 0 to 10)
        if (!_inRange(_data.QualityOfLifeScore, 0, 10)) {
          throw ArgumentError("Quality of Life Score must be between 0 and 10");
        }
        break;

      case 9:
        // Step 9: Medications
        // Validate NSAIDs Use (binary: 0 or 1)
        _validateBinary(_data.NSAIDsUse, "NSAIDs Use");

        // Validate Antidiabetic Medications (binary: 0 or 1)
        _validateBinary(
            _data.AntidiabeticMedications, "Antidiabetic Medications");
        break;

      case 10:
        // Step 10: Additional Health Metrics
        // Validate Socioeconomic Status (numeric)
        if (_data.SocioeconomicStatus <= 0) {
          throw ArgumentError("Socioeconomic Status must be a positive number");
        }

        // Validate Sleep Quality (numeric: within a reasonable range, e.g., 0 to 10)
        if (!_inRange(_data.SleepQuality, 0, 10)) {
          throw ArgumentError("Sleep Quality must be between 0 and 10");
        }

        // Validate Physical Activity (numeric: within a reasonable range, e.g., 0 to 10)
        if (!_inRange(_data.PhysicalActivity, 0, 10)) {
          throw ArgumentError("Physical Activity must be between 0 and 10");
        }

        // Validate Diet Quality (numeric: within a reasonable range, e.g., 0 to 10)
        if (!_inRange(_data.DietQuality, 0, 10)) {
          throw ArgumentError("Diet Quality must be between 0 and 10");
        }

        // Validate Serum Creatinine (numeric: positive)
        if (_data.SerumCreatinine <= 0) {
          throw ArgumentError("Serum Creatinine must be a positive number");
        }

        // Validate Education Level (numeric: e.g., 0 to 20 for education years)
        if (_data.EducationLevel < 0 || _data.EducationLevel > 20) {
          throw ArgumentError("Education Level must be between 0 and 20");
        }

        // Validate Serum Electrolytes Sodium, Potassium, Calcium, Phosphorus (positive numeric values)
        if (_data.SerumElectrolytesSodium <= 0) {
          throw ArgumentError(
              "Serum Electrolytes Sodium must be a positive number");
        }
        if (_data.SerumElectrolytesPotassium <= 0) {
          throw ArgumentError(
              "Serum Electrolytes Potassium must be a positive number");
        }
        if (_data.SerumElectrolytesCalcium <= 0) {
          throw ArgumentError(
              "Serum Electrolytes Calcium must be a positive number");
        }
        if (_data.SerumElectrolytesPhosphorus <= 0) {
          throw ArgumentError(
              "Serum Electrolytes Phosphorus must be a positive number");
        }

        // Validate Hemoglobin Levels (positive numeric value)
        if (_data.HemoglobinLevels <= 0) {
          throw ArgumentError("Hemoglobin Levels must be a positive number");
        }

        // Validate Cholesterol Levels (positive numeric values)
        if (_data.CholesterolTotal <= 0) {
          throw ArgumentError("Total Cholesterol must be a positive number");
        }
        if (_data.CholesterolLDL <= 0) {
          throw ArgumentError("LDL Cholesterol must be a positive number");
        }
        if (_data.CholesterolHDL <= 0) {
          throw ArgumentError("HDL Cholesterol must be a positive number");
        }
        if (_data.CholesterolTriglycerides <= 0) {
          throw ArgumentError("Triglycerides must be a positive number");
        }

        // Validate ACR (Albumin-to-Creatinine Ratio), BUN, GFR, Protein in Urine (positive numeric values)
        if (_data.ACR <= 0) {
          throw ArgumentError(
              "Albumin-to-Creatinine Ratio must be a positive number");
        }
        if (_data.BUNLevels <= 0) {
          throw ArgumentError("BUN Levels must be a positive number");
        }
        if (_data.GFR <= 0) {
          throw ArgumentError(
              "Glomerular Filtration Rate must be a positive number");
        }
        if (_data.ProteinInUrine <= 0) {
          throw ArgumentError("Protein in Urine must be a positive number");
        }
        break;

      default:
        throw ArgumentError("Invalid step number: $step");
    }
  }

  Future<void> _predict() async {
    try {
      // Validate the input before sending
      _data.validate();
    } catch (e) {
      // Show validation error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Validation Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return; // Stop prediction if validation fails
    }

    debugPrint("server...");
    final url = Uri.parse('https://backend-cdk.onrender.com/predict');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(_data.toJson()),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      final message = result['Prediction Message'];
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Prediction Result'),
          content: Text(message),
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
                  debugPrint(_currentStep.toString());
                  try {
                    // Validate the input before sending
                    validate(_currentStep);
                  } catch (e) {
                    debugPrint(e.toString());
                    // Show validation error message
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Validation Error'),
                        content: Text(e.toString()),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                    return; // Stop prediction if validation fails
                  }

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
                      _data.Age = int.parse(value);
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
                      initialSelection: _data.Gender,
                      label: const Text("Gender"),
                      dropdownMenuEntries: gender.map((g) {
                        return DropdownMenuEntry<String>(value: g, label: g);
                      }).toList(),
                      onSelected: (value) {
                        _data.Gender = value!;
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
                      initialSelection: _data.Ethnicity,
                      label: const Text('Select a country'),
                      dropdownMenuEntries: dataList.map((country) {
                        return DropdownMenuEntry<String>(
                          value: country['alpha_2_code']!,
                          label: country['en_short_name']!,
                        );
                      }).toList(),
                      onSelected: (String? newValue) {
                        setState(() {
                          _data.Ethnicity = newValue!;
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
                      _data.BMI = double.parse(value);
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
                      _data.Smoking = int.parse(value);
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
                      _data.AlcoholConsumption = int.parse(value);
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
                      _data.FamilyHistoryKidneyDisease = value!;
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
                      _data.FamilyHistoryHypertension = value!;
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
                        _data.FamilyHistoryDiabetes = value!;
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
                        _data.PreviousAcuteKidneyInjury = value!;
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
                        _data.UrinaryTractInfections = value!;
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
                      _data.SystolicBP = int.parse(value);
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
                      _data.DiastolicBP = int.parse(value);
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
                      _data.FastingBloodSugar = int.parse(value);
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
                      _data.HbA1c = double.parse(value);
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
                        _data.ACEInhibitors = value!;
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
                      _data.Diuretics = value!;
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
                      _data.Statins = value!;
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
                        _data.HeavyMetalsExposure = value!;
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
                        _data.OccupationalExposureChemicals = value!;
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
                        _data.WaterQuality = value!;
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
                      _data.MedicalCheckupsFrequency = int.parse(value);
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
                        _data.MedicationAdherence = value!;
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
                        _data.HealthLiteracy = value!;
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
                      _data.Edema = value!;
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
                      _data.FatigueLevels = value!;
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
                        _data.NauseaVomiting = value!;
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
                        _data.MuscleCramps = value!;
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
                        _data.Itching = value!;
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
                      _data.QualityOfLifeScore = int.parse(value);
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
                        _data.NSAIDsUse = value!;
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
                        _data.AntidiabeticMedications = value!;
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
      Step(
        title: const Text("Additional Health Metrics"),
        content: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "Socioeconomic Status",
                    icons: const Icon(Icons.people),
                    validator: RequiredValidator(
                        errorText: "invalid socioeconomic status"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.SocioeconomicStatus = int.parse(value);
                    },
                    disable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "Sleep Quality",
                    icons: const Icon(Icons.bed),
                    validator:
                        RequiredValidator(errorText: "invalid sleep quality"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.SleepQuality = int.parse(value);
                    },
                    disable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "Physical Activity",
                    icons: const Icon(Icons.fitness_center),
                    validator: RequiredValidator(
                        errorText: "invalid physical activity"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.PhysicalActivity = int.parse(value);
                    },
                    disable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "Diet Quality",
                    icons: const Icon(Icons.restaurant),
                    validator:
                        RequiredValidator(errorText: "invalid diet quality"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.DietQuality = int.parse(value);
                    },
                    disable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "Serum Creatinine (mg/dL)",
                    icons: const Icon(Icons.science),
                    validator: RequiredValidator(
                        errorText: "invalid serum creatinine"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.SerumCreatinine = double.parse(value);
                    },
                    disable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "Education Level",
                    icons: const Icon(Icons.school),
                    validator:
                        RequiredValidator(errorText: "invalid education level"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.EducationLevel = int.parse(value);
                    },
                    disable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "Serum Electrolytes Sodium (mEq/L)",
                    icons: const Icon(Icons.science),
                    validator:
                        RequiredValidator(errorText: "invalid sodium level"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.SerumElectrolytesSodium = double.parse(value);
                    },
                    disable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "Serum Electrolytes Potassium (mEq/L)",
                    icons: const Icon(Icons.science),
                    validator:
                        RequiredValidator(errorText: "invalid potassium level"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.SerumElectrolytesPotassium = double.parse(value);
                    },
                    disable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "Serum Electrolytes Calcium (mg/dL)",
                    icons: const Icon(Icons.science),
                    validator:
                        RequiredValidator(errorText: "invalid calcium level"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.SerumElectrolytesCalcium = double.parse(value);
                    },
                    disable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "Serum Electrolytes Phosphorus (mg/dL)",
                    icons: const Icon(Icons.science),
                    validator: RequiredValidator(
                        errorText: "invalid phosphorus level"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.SerumElectrolytesPhosphorus = double.parse(value);
                    },
                    disable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "Hemoglobin Levels (g/dL)",
                    icons: const Icon(Icons.bloodtype),
                    validator: RequiredValidator(
                        errorText: "invalid hemoglobin level"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.HemoglobinLevels = double.parse(value);
                    },
                    disable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "Total Cholesterol (mg/dL)",
                    icons: const Icon(Icons.monitor_heart),
                    validator: RequiredValidator(
                        errorText: "invalid total cholesterol"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.CholesterolTotal = int.parse(value);
                    },
                    disable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "LDL Cholesterol (mg/dL)",
                    icons: const Icon(Icons.monitor_heart),
                    validator:
                        RequiredValidator(errorText: "invalid LDL cholesterol"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.CholesterolLDL = int.parse(value);
                    },
                    disable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "HDL Cholesterol (mg/dL)",
                    icons: const Icon(Icons.monitor_heart),
                    validator:
                        RequiredValidator(errorText: "invalid HDL cholesterol"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.CholesterolHDL = int.parse(value);
                    },
                    disable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "Triglycerides (mg/dL)",
                    icons: const Icon(Icons.monitor_heart),
                    validator: RequiredValidator(
                        errorText: "invalid triglycerides level"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.CholesterolTriglycerides = int.parse(value);
                    },
                    disable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "Albumin-to-Creatinine Ratio (mg/g)",
                    icons: const Icon(Icons.science),
                    validator:
                        RequiredValidator(errorText: "invalid ACR value"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.ACR = int.parse(value);
                    },
                    disable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "BUN Levels (mg/dL)",
                    icons: const Icon(Icons.science),
                    validator:
                        RequiredValidator(errorText: "invalid BUN levels"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.BUNLevels = int.parse(value);
                    },
                    disable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "Glomerular Filtration Rate (mL/min/1.73m²)",
                    icons: const Icon(Icons.science),
                    validator:
                        RequiredValidator(errorText: "invalid GFR value"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.GFR = int.parse(value);
                    },
                    disable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputText(
                    label: "Protein in Urine (mg/dL)",
                    icons: const Icon(Icons.science),
                    validator: RequiredValidator(
                        errorText: "invalid protein in urine"),
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      _data.ProteinInUrine = int.parse(value);
                    },
                    disable: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }
}
