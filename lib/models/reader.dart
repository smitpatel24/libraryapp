class Reader {
  final String firstname;
  final String lastname;
  final String barcode;
  final int id;

  Reader({
    required this.firstname,
    required this.lastname,
    required this.barcode,
    required this.id,
  });

  factory Reader.fromSupabase(Map<String, dynamic> json) {
    return Reader(
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      barcode: json['barcode'] as String,
      id: json['id'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'barcode': barcode,
      'id': id,
    };
  }
}
