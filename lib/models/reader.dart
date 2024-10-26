class Reader {
  final String firstname;
  final String lastname;
  final String barcode;

  Reader({
    required this.firstname,
    required this.lastname,
    required this.barcode,
  });

  factory Reader.fromSupabase(Map<String, dynamic> json) {
    return Reader(
      firstname: json['fname'] as String,
      lastname: json['lname'] as String,
      barcode: json['barcode'] as String,
    );
  }

  Map<String, String> toMap() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'barcode': barcode,
    };
  }
}