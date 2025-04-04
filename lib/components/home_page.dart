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
