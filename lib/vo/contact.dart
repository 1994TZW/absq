import 'setting.dart';

class Contact {
  String? contactNumber;
  String? address;
  String? website;
  String? emailAddress;
  String? facebookLink;

  Contact({
    this.contactNumber,
    this.address,
    this.website,
    this.emailAddress,
    this.facebookLink,
  });

  factory Contact.fromSetting(Setting setting) {
    return Contact(
        contactNumber: setting.contactNumber,
        address: setting.address,
        website: setting.website,
        emailAddress: setting.email,
        facebookLink: setting.facebookLink);
  }

  Map<String, dynamic> toMap() {
    return {
      'phone_number': contactNumber,
      'address': address,
      'website': website,
      'email_address': emailAddress,
      'facebook_link': facebookLink,
    };
  }

  @override
  String toString() {
    return 'Contact{contact_number:$contactNumber,address:$address}';
  }
}
