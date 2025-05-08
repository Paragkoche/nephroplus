class HealthData {
  int Age;
  String Gender; // 'Male', 'Female', 'Other'
  String Ethnicity;
  int SocioeconomicStatus;
  int EducationLevel;
  double BMI;
  int Smoking;
  int AlcoholConsumption;
  int PhysicalActivity;
  int DietQuality;
  int SleepQuality;
  int FamilyHistoryKidneyDisease;
  int FamilyHistoryHypertension;
  int FamilyHistoryDiabetes;
  int PreviousAcuteKidneyInjury;
  int UrinaryTractInfections;
  int SystolicBP;
  int DiastolicBP;
  int FastingBloodSugar;
  double HbA1c;
  double SerumCreatinine;
  int BUNLevels;
  int GFR;
  int ProteinInUrine;
  int ACR;
  double SerumElectrolytesSodium;
  double SerumElectrolytesPotassium;
  double SerumElectrolytesCalcium;
  double SerumElectrolytesPhosphorus;
  double HemoglobinLevels;
  int CholesterolTotal;
  int CholesterolLDL;
  int CholesterolHDL;
  int CholesterolTriglycerides;
  int ACEInhibitors;
  int Diuretics;
  int Statins;
  int HeavyMetalsExposure;
  int OccupationalExposureChemicals;
  int WaterQuality;
  int MedicalCheckupsFrequency;
  int MedicationAdherence;
  int HealthLiteracy;
  int Edema;
  int FatigueLevels;
  int NauseaVomiting;
  int MuscleCramps;
  int Itching;
  int QualityOfLifeScore;
  int NSAIDsUse;
  int AntidiabeticMedications;

  HealthData({
    required this.Age,
    required this.Gender,
    required this.Ethnicity,
    required this.SocioeconomicStatus,
    required this.EducationLevel,
    required this.BMI,
    required this.Smoking,
    required this.AlcoholConsumption,
    required this.PhysicalActivity,
    required this.DietQuality,
    required this.SleepQuality,
    required this.FamilyHistoryKidneyDisease,
    required this.FamilyHistoryHypertension,
    required this.FamilyHistoryDiabetes,
    required this.PreviousAcuteKidneyInjury,
    required this.UrinaryTractInfections,
    required this.SystolicBP,
    required this.DiastolicBP,
    required this.FastingBloodSugar,
    required this.HbA1c,
    required this.SerumCreatinine,
    required this.BUNLevels,
    required this.GFR,
    required this.ProteinInUrine,
    required this.ACR,
    required this.SerumElectrolytesSodium,
    required this.SerumElectrolytesPotassium,
    required this.SerumElectrolytesCalcium,
    required this.SerumElectrolytesPhosphorus,
    required this.HemoglobinLevels,
    required this.CholesterolTotal,
    required this.CholesterolLDL,
    required this.CholesterolHDL,
    required this.CholesterolTriglycerides,
    required this.ACEInhibitors,
    required this.Diuretics,
    required this.Statins,
    required this.HeavyMetalsExposure,
    required this.OccupationalExposureChemicals,
    required this.WaterQuality,
    required this.MedicalCheckupsFrequency,
    required this.MedicationAdherence,
    required this.HealthLiteracy,
    required this.Edema,
    required this.FatigueLevels,
    required this.NauseaVomiting,
    required this.MuscleCramps,
    required this.Itching,
    required this.QualityOfLifeScore,
    required this.NSAIDsUse,
    required this.AntidiabeticMedications,
  });
  void validate() {
    if (Age < 0) throw ArgumentError("Age must be ≥ 0");
    if (SocioeconomicStatus < 1 || SocioeconomicStatus > 5) {
      throw ArgumentError("SocioeconomicStatus must be between 1 and 5");
    }
    if (EducationLevel < 1 || EducationLevel > 5) {
      throw ArgumentError("EducationLevel must be between 1 and 5");
    }
    if (BMI < 0) throw ArgumentError("BMI must be ≥ 0");
    if (!_binary(Smoking)) throw ArgumentError("Smoking must be 0 or 1");
    if (!_inRange(AlcoholConsumption, 0, 5)) {
      throw ArgumentError("AlcoholConsumption must be between 0 and 5");
    }
    if (!_inRange(PhysicalActivity, 1, 5)) {
      throw ArgumentError("PhysicalActivity must be between 1 and 5");
    }
    if (!_inRange(DietQuality, 1, 5)) {
      throw ArgumentError("DietQuality must be between 1 and 5");
    }
    if (!_inRange(SleepQuality, 1, 5)) {
      throw ArgumentError("SleepQuality must be between 1 and 5");
    }
    _validateBinary(FamilyHistoryKidneyDisease, 'FamilyHistoryKidneyDisease');
    _validateBinary(FamilyHistoryHypertension, 'FamilyHistoryHypertension');
    _validateBinary(FamilyHistoryDiabetes, 'FamilyHistoryDiabetes');
    _validateBinary(PreviousAcuteKidneyInjury, 'PreviousAcuteKidneyInjury');
    _validateBinary(UrinaryTractInfections, 'UrinaryTractInfections');
    if (SystolicBP < 0) throw ArgumentError("SystolicBP must be ≥ 0");
    if (DiastolicBP < 0) throw ArgumentError("DiastolicBP must be ≥ 0");
    if (FastingBloodSugar < 0)
      throw ArgumentError("FastingBloodSugar must be ≥ 0");
    if (HbA1c < 0) throw ArgumentError("HbA1c must be ≥ 0");
    if (SerumCreatinine < 0) throw ArgumentError("SerumCreatinine must be ≥ 0");
    if (BUNLevels < 0) throw ArgumentError("BUNLevels must be ≥ 0");
    if (GFR < 0) throw ArgumentError("GFR must be ≥ 0");
    _validateBinary(ProteinInUrine, 'ProteinInUrine');
    if (ACR < 0) throw ArgumentError("ACR must be ≥ 0");
    _validateBinary(ACEInhibitors, 'ACEInhibitors');
    _validateBinary(Diuretics, 'Diuretics');
    _validateBinary(Statins, 'Statins');
    _validateBinary(HeavyMetalsExposure, 'HeavyMetalsExposure');
    _validateBinary(
        OccupationalExposureChemicals, 'OccupationalExposureChemicals');
    if (!_inRange(WaterQuality, 1, 5))
      throw ArgumentError("WaterQuality must be 1–5");
    if (!_inRange(MedicalCheckupsFrequency, 1, 5))
      throw ArgumentError("MedicalCheckupsFrequency must be 1–5");
    if (!_inRange(MedicationAdherence, 1, 5))
      throw ArgumentError("MedicationAdherence must be 1–5");
    if (!_inRange(HealthLiteracy, 1, 5))
      throw ArgumentError("HealthLiteracy must be 1–5");
    _validateBinary(Edema, 'Edema');
    if (!_inRange(FatigueLevels, 0, 5))
      throw ArgumentError("FatigueLevels must be 0–5");
    _validateBinary(NauseaVomiting, 'NauseaVomiting');
    _validateBinary(MuscleCramps, 'MuscleCramps');
    _validateBinary(Itching, 'Itching');
    if (!_inRange(QualityOfLifeScore, 0, 10))
      throw ArgumentError("QualityOfLifeScore must be 0–10");
    _validateBinary(NSAIDsUse, 'NSAIDsUse');
    _validateBinary(AntidiabeticMedications, 'AntidiabeticMedications');
  }

  void _validateBinary(int value, String field) {
    if (!_binary(value)) throw ArgumentError("$field must be 0 or 1");
  }

  bool _binary(int x) => x == 0 || x == 1;

  bool _inRange(int x, int min, int max) => x >= min && x <= max;

  Map<String, dynamic> toJson() {
    return {
      'Age': Age,
      'Gender': Gender,
      'Ethnicity': Ethnicity,
      'SocioeconomicStatus': SocioeconomicStatus,
      'EducationLevel': EducationLevel,
      'BMI': BMI,
      'Smoking': Smoking,
      'AlcoholConsumption': AlcoholConsumption,
      'PhysicalActivity': PhysicalActivity,
      'DietQuality': DietQuality,
      'SleepQuality': SleepQuality,
      'FamilyHistoryKidneyDisease': FamilyHistoryKidneyDisease,
      'FamilyHistoryHypertension': FamilyHistoryHypertension,
      'FamilyHistoryDiabetes': FamilyHistoryDiabetes,
      'PreviousAcuteKidneyInjury': PreviousAcuteKidneyInjury,
      'UrinaryTractInfections': UrinaryTractInfections,
      'SystolicBP': SystolicBP,
      'DiastolicBP': DiastolicBP,
      'FastingBloodSugar': FastingBloodSugar,
      'HbA1c': HbA1c,
      'SerumCreatinine': SerumCreatinine,
      'BUNLevels': BUNLevels,
      'GFR': GFR,
      'ProteinInUrine': ProteinInUrine,
      'ACR': ACR,
      'SerumElectrolytesSodium': SerumElectrolytesSodium,
      'SerumElectrolytesPotassium': SerumElectrolytesPotassium,
      'SerumElectrolytesCalcium': SerumElectrolytesCalcium,
      'SerumElectrolytesPhosphorus': SerumElectrolytesPhosphorus,
      'HemoglobinLevels': HemoglobinLevels,
      'CholesterolTotal': CholesterolTotal,
      'CholesterolLDL': CholesterolLDL,
      'CholesterolHDL': CholesterolHDL,
      'CholesterolTriglycerides': CholesterolTriglycerides,
      'ACEInhibitors': ACEInhibitors,
      'Diuretics': Diuretics,
      'Statins': Statins,
      'HeavyMetalsExposure': HeavyMetalsExposure,
      'OccupationalExposureChemicals': OccupationalExposureChemicals,
      'WaterQuality': WaterQuality,
      'MedicalCheckupsFrequency': MedicalCheckupsFrequency,
      'MedicationAdherence': MedicationAdherence,
      'HealthLiteracy': HealthLiteracy,
      'Edema': Edema,
      'FatigueLevels': FatigueLevels,
      'NauseaVomiting': NauseaVomiting,
      'MuscleCramps': MuscleCramps,
      'Itching': Itching,
      'QualityOfLifeScore': QualityOfLifeScore,
      'NSAIDsUse': NSAIDsUse,
      'AntidiabeticMedications': AntidiabeticMedications,
    };
  }

  // Convert JSON to Dart object
  factory HealthData.fromJson(Map<String, dynamic> json) {
    return HealthData(
      Age: json['Age'],
      Gender: json['Gender'],
      Ethnicity: json['Ethnicity'],
      SocioeconomicStatus: json['SocioeconomicStatus'],
      EducationLevel: json['EducationLevel'],
      BMI: json['BMI'],
      Smoking: json['Smoking'],
      AlcoholConsumption: json['AlcoholConsumption'],
      PhysicalActivity: json['PhysicalActivity'],
      DietQuality: json['DietQuality'],
      SleepQuality: json['SleepQuality'],
      FamilyHistoryKidneyDisease: json['FamilyHistoryKidneyDisease'],
      FamilyHistoryHypertension: json['FamilyHistoryHypertension'],
      FamilyHistoryDiabetes: json['FamilyHistoryDiabetes'],
      PreviousAcuteKidneyInjury: json['PreviousAcuteKidneyInjury'],
      UrinaryTractInfections: json['UrinaryTractInfections'],
      SystolicBP: json['SystolicBP'],
      DiastolicBP: json['DiastolicBP'],
      FastingBloodSugar: json['FastingBloodSugar'],
      HbA1c: json['HbA1c'],
      SerumCreatinine: json['SerumCreatinine'],
      BUNLevels: json['BUNLevels'],
      GFR: json['GFR'],
      ProteinInUrine: json['ProteinInUrine'],
      ACR: json['ACR'],
      SerumElectrolytesSodium: json['SerumElectrolytesSodium'],
      SerumElectrolytesPotassium: json['SerumElectrolytesPotassium'],
      SerumElectrolytesCalcium: json['SerumElectrolytesCalcium'],
      SerumElectrolytesPhosphorus: json['SerumElectrolytesPhosphorus'],
      HemoglobinLevels: json['HemoglobinLevels'],
      CholesterolTotal: json['CholesterolTotal'],
      CholesterolLDL: json['CholesterolLDL'],
      CholesterolHDL: json['CholesterolHDL'],
      CholesterolTriglycerides: json['CholesterolTriglycerides'],
      ACEInhibitors: json['ACEInhibitors'],
      Diuretics: json['Diuretics'],
      Statins: json['Statins'],
      HeavyMetalsExposure: json['HeavyMetalsExposure'],
      OccupationalExposureChemicals: json['OccupationalExposureChemicals'],
      WaterQuality: json['WaterQuality'],
      MedicalCheckupsFrequency: json['MedicalCheckupsFrequency'],
      MedicationAdherence: json['MedicationAdherence'],
      HealthLiteracy: json['HealthLiteracy'],
      Edema: json['Edema'],
      FatigueLevels: json['FatigueLevels'],
      NauseaVomiting: json['NauseaVomiting'],
      MuscleCramps: json['MuscleCramps'],
      Itching: json['Itching'],
      QualityOfLifeScore: json['QualityOfLifeScore'],
      NSAIDsUse: json['NSAIDsUse'],
      AntidiabeticMedications: json['AntidiabeticMedications'],
    );
  }
}
