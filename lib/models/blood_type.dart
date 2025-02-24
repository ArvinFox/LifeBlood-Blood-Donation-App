class BloodType {
  String bloodType;
  bool isSelected;

  BloodType({
    required this.bloodType,
    required this.isSelected,
  });
}

List<BloodType> bloodTypes = [
  BloodType(bloodType: 'A+', isSelected: false),
  BloodType(bloodType: 'B+', isSelected: false),
  BloodType(bloodType: 'O+', isSelected: false),
  BloodType(bloodType: 'AB+', isSelected: false),
  BloodType(bloodType: 'A-', isSelected: false),
  BloodType(bloodType: 'B-', isSelected: false),
  BloodType(bloodType: 'O-', isSelected: false),
  BloodType(bloodType: 'AB-', isSelected: false),
];
