// reader.dart
class Reader {
  String firstName;
  String lastName;
  String readerID;
  String name;
  String details;
  Reader(this.firstName, this.lastName, this.readerID,
      {this.name = '', this.details = ''});
  // Reader(this.name, this.details);

  // If you plan to find or compare readers, you might need to override == and hashCode.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Reader && other.name == name && other.details == details;
  }

  @override
  int get hashCode => name.hashCode ^ details.hashCode;
}
