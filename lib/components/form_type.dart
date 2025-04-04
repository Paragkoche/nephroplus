
class HealthData {
  // Basic Information
  int age;
  String gender;
  String ethnicity;
  int socioeconomicStatus;
  int educationLevel;
  
  // Lifestyle Factors
  double bmi;
  int smoking;
  int alcoholConsumption;
  int physicalActivity;
  int dietQuality;
  int sleepQuality;

  // Family History
  int familyHistoryKidneyDisease;
  int familyHistoryHypertension;
  int familyHistoryDiabetes;

  // Medical History
  int previousAcuteKidneyInjury;
  int urinaryTractInfections;

  // Vital Signs & Lab Tests
  int systolicBP;
  int diastolicBP;
  int fastingBloodSugar;
  double hba1c;
  double serumCreatinine;
  int bunLevels;
  int gfr;
  double proteinInUrine;
  double acr;

  // Electrolytes
  double serumSodium;
  double serumPotassium;
  double serumCalcium;
  double serumPhosphorus;

  // Blood and Lipid Profile
  double hemoglobinLevels;
  int cholesterolTotal;
  int cholesterolLDL;
  int cholesterolHDL;
  int cholesterolTriglycerides;

  // Medications
  int aceInhibitors;
  int diuretics;
  int statins;
  int antidiabeticMedications;
  int nsaisUse;

  // Environmental Factors
  int heavyMetalsExposure;
  int occupationalExposureChemicals;
  int waterQuality;

  // Healthcare & Lifestyle
  int medicalCheckupsFrequency;
  int medicationAdherence;
  int healthLiteracy;

  // Symptoms
  int edema;
  int fatigueLevels;
  int nauseaVomiting;
  int muscleCramps;
  int itching;

  // Quality of Life
  int qualityOfLifeScore;

  HealthData({
    required this.age,
    required this.gender,
    required this.ethnicity,
    required this.socioeconomicStatus,
    required this.educationLevel,
    required this.bmi,
    required this.smoking,
    required this.alcoholConsumption,
    required this.physicalActivity,
    required this.dietQuality,
    required this.sleepQuality,
    required this.familyHistoryKidneyDisease,
    required this.familyHistoryHypertension,
    required this.familyHistoryDiabetes,
    required this.previousAcuteKidneyInjury,
    required this.urinaryTractInfections,
    required this.systolicBP,
    required this.diastolicBP,
    required this.fastingBloodSugar,
    required this.hba1c,
    required this.serumCreatinine,
    required this.bunLevels,
    required this.gfr,
    required this.proteinInUrine,
    required this.acr,
    required this.serumSodium,
    required this.serumPotassium,
    required this.serumCalcium,
    required this.serumPhosphorus,
    required this.hemoglobinLevels,
    required this.cholesterolTotal,
    required this.cholesterolLDL,
    required this.cholesterolHDL,
    required this.cholesterolTriglycerides,
    required this.aceInhibitors,
    required this.diuretics,
    required this.statins,
    required this.antidiabeticMedications,
    required this.nsaisUse,
    required this.heavyMetalsExposure,
    required this.occupationalExposureChemicals,
    required this.waterQuality,
    required this.medicalCheckupsFrequency,
    required this.medicationAdherence,
    required this.healthLiteracy,
    required this.edema,
    required this.fatigueLevels,
    required this.nauseaVomiting,
    required this.muscleCramps,
    required this.itching,
    required this.qualityOfLifeScore,
  });

  // Convert Dart object to JSON
  Map<String, dynamic> toJson() {
    return {
      "age": age,
      "gender": gender,
      "ethnicity": ethnicity,
      "socioeconomicStatus": socioeconomicStatus,
      "educationLevel": educationLevel,
      "bmi": bmi,
      "smoking": smoking,
      "alcoholConsumption": alcoholConsumption,
      "physicalActivity": physicalActivity,
      "dietQuality": dietQuality,
      "sleepQuality": sleepQuality,
      "familyHistoryKidneyDisease": familyHistoryKidneyDisease,
      "familyHistoryHypertension": familyHistoryHypertension,
      "familyHistoryDiabetes": familyHistoryDiabetes,
      "previousAcuteKidneyInjury": previousAcuteKidneyInjury,
      "urinaryTractInfections": urinaryTractInfections,
      "systolicBP": systolicBP,
      "diastolicBP": diastolicBP,
      "fastingBloodSugar": fastingBloodSugar,
      "hba1c": hba1c,
      "serumCreatinine": serumCreatinine,
      "bunLevels": bunLevels,
      "gfr": gfr,
      "proteinInUrine": proteinInUrine,
      "acr": acr,
      "serumSodium": serumSodium,
      "serumPotassium": serumPotassium,
      "serumCalcium": serumCalcium,
      "serumPhosphorus": serumPhosphorus,
      "hemoglobinLevels": hemoglobinLevels,
      "cholesterolTotal": cholesterolTotal,
      "cholesterolLDL": cholesterolLDL,
      "cholesterolHDL": cholesterolHDL,
      "cholesterolTriglycerides": cholesterolTriglycerides,
      "aceInhibitors": aceInhibitors,
      "diuretics": diuretics,
      "statins": statins,
      "antidiabeticMedications": antidiabeticMedications,
      "nsaisUse": nsaisUse,
      "heavyMetalsExposure": heavyMetalsExposure,
      "occupationalExposureChemicals": occupationalExposureChemicals,
      "waterQuality": waterQuality,
      "medicalCheckupsFrequency": medicalCheckupsFrequency,
      "medicationAdherence": medicationAdherence,
      "healthLiteracy": healthLiteracy,
      "edema": edema,
      "fatigueLevels": fatigueLevels,
      "nauseaVomiting": nauseaVomiting,
      "muscleCramps": muscleCramps,
      "itching": itching,
      "qualityOfLifeScore": qualityOfLifeScore,
    };
  }

  // Convert JSON to Dart object
  factory HealthData.fromJson(Map<String, dynamic> json) {
    return HealthData(
      age: json["age"],
      gender: json["gender"],
      ethnicity: json["ethnicity"],
      socioeconomicStatus: json["socioeconomicStatus"],
      educationLevel: json["educationLevel"],
      bmi: json["bmi"],
      smoking: json["smoking"],
      alcoholConsumption: json["alcoholConsumption"],
      physicalActivity: json["physicalActivity"],
      dietQuality: json["dietQuality"],
      sleepQuality: json["sleepQuality"],
      familyHistoryKidneyDisease: json["familyHistoryKidneyDisease"],
      familyHistoryHypertension: json["familyHistoryHypertension"],
      familyHistoryDiabetes: json["familyHistoryDiabetes"],
      previousAcuteKidneyInjury: json["previousAcuteKidneyInjury"],
      urinaryTractInfections: json["urinaryTractInfections"],
      systolicBP: json["systolicBP"],
      diastolicBP: json["diastolicBP"],
      fastingBloodSugar: json["fastingBloodSugar"],
      hba1c: json["hba1c"],
      serumCreatinine: json["serumCreatinine"],
      bunLevels: json["bunLevels"],
      gfr: json["gfr"],
      proteinInUrine: json["proteinInUrine"],
      acr: json["acr"],
      serumSodium: json["serumSodium"],
      serumPotassium: json["serumPotassium"],
      serumCalcium: json["serumCalcium"],
      serumPhosphorus: json["serumPhosphorus"],
      hemoglobinLevels: json["hemoglobinLevels"],
      cholesterolTotal: json["cholesterolTotal"],
      cholesterolLDL: json["cholesterolLDL"],
      cholesterolHDL: json["cholesterolHDL"],
      cholesterolTriglycerides: json["cholesterolTriglycerides"],
      aceInhibitors: json["aceInhibitors"],
      diuretics: json["diuretics"],
      statins: json["statins"],
      antidiabeticMedications: json["antidiabeticMedications"],
      nsaisUse: json["nsaisUse"],
      heavyMetalsExposure: json["heavyMetalsExposure"],
      occupationalExposureChemicals: json["occupationalExposureChemicals"],
      waterQuality: json["waterQuality"],
      medicalCheckupsFrequency: json["medicalCheckupsFrequency"],
      medicationAdherence: json["medicationAdherence"],
      healthLiteracy: json["healthLiteracy"],
      edema: json["edema"],
      fatigueLevels: json["fatigueLevels"],
      nauseaVomiting: json["nauseaVomiting"],
      muscleCramps: json["muscleCramps"],
      itching: json["itching"],
      qualityOfLifeScore: json["qualityOfLifeScore"],
    );
  }
}
