class Setting {
  final int supportBuildNum;
  int latestBuildNum;
  String latestBuildUrl;
  final String aboutEng;
  final String aboutMm;
  String contactNumber;
  String address;
  String facebookLink;
  String website;
  String email;
  bool inviteRequired;
  List<String> priorities;
  int filterChangeLimit;
  int calibrationVolume;
  int customerWarrantyPeriod;
  int vendorWarrantyPeriod;
  final String termsEng;
  final String termsMm;
  List<String> frequentIssues;
  String currencySymbol;

  Setting(
      {required this.supportBuildNum,
      required this.latestBuildNum,
      required this.latestBuildUrl,
      required this.facebookLink,
      required this.aboutEng,
      required this.aboutMm,
      required this.address,
      required this.website,
      required this.contactNumber,
      required this.email,
      required this.inviteRequired,
      required this.priorities,
      required this.filterChangeLimit,
      required this.calibrationVolume,
      required this.customerWarrantyPeriod,
      required this.vendorWarrantyPeriod,
      required this.termsEng,
      required this.termsMm,
      required this.frequentIssues,
      this.currencySymbol="₭"});

  factory Setting.fromMap(Map<String, dynamic> map) {
    return Setting(
        inviteRequired: map['invite_required'],
        supportBuildNum: map['support_build_number'],
        latestBuildNum: map['latest_build_number'] ?? 1,
        latestBuildUrl: map['latest_build_url'] ?? "",
        address: map['address'],
        facebookLink: map['facebook_link'],
        aboutEng: map['about_eng'],
        aboutMm: map['about_mm'],
        website: map['website'],
        contactNumber: map['contact_number'],
        email: map['email_address'],
        termsEng: map['terms_eng'],
        termsMm: map['terms_mm'],
        filterChangeLimit: map['filter_change_limit'],
        calibrationVolume: map['calibration_volume'],
        customerWarrantyPeriod: map['customer_warranty_period_month'],
        vendorWarrantyPeriod: map['vendor_warranty_period_month'],
        priorities: List.from(
          map['priorities'],
        ),
        frequentIssues: List.from(map['frequent_issues']));
  }

  Map<String, dynamic> toMap() {
    return {
      'invite_required': inviteRequired,
      'support_build_number': supportBuildNum,
      'latest_build_number': latestBuildNum,
      'latest_build_url': latestBuildUrl,
      'address': address,
      'facebook_link': facebookLink,
      'website': website,
      'contact_number': contactNumber,
      'email_address': email,
      'terms_eng': termsEng,
      'terms_mm': termsMm,
      'filter_change_limit': filterChangeLimit,
      'calibration_volume': calibrationVolume,
      'customer_warranty_period_month': customerWarrantyPeriod,
      'vendor_warranty_period_month': vendorWarrantyPeriod,
      'priorities': priorities,
      'frequent_issues': frequentIssues,
      'about_eng': aboutEng,
      'about_mm': aboutMm,
    };
  }

  Setting clone() {
    return Setting.fromMap(toMap());
  }

  @override
  String toString() {
    return 'Setting{supportBuildNum:$supportBuildNum,aboutEng:$aboutEng}';
  }
}
