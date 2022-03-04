class Registration {
  String? id;
  String? centerName;
  String? centerNumber;
  DateTime? date;
  String? name;
  DateTime? dateOfBirth;
  String? gender;
  String? idNumber;
  String? address;
  String? email;
  String? phone;
  String? schoolName;
  String formType ;
  String? level;

  Registration(
      {this.id,
      this.centerName,
      this.centerNumber,
      this.name,
      this.date,
      this.idNumber,
      this.address,
      this.email,
      this.phone,
      this.schoolName,
      this.gender,
      this.dateOfBirth,
      required this.formType,
      this.level});
}
