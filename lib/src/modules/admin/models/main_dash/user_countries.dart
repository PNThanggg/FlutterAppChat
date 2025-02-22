import '../../admin.dart';

class UserCountries {
  final int count;
  final Country country;

  UserCountries({
    required this.count,
    required this.country,
  });

  UserCountries.empty()
      : count = 0,
        country = Country.empty();

  Map<String, dynamic> toMap() {
    return {
      'count': count,
      'country': country.toMap(),
    };
  }

  factory UserCountries.fromMap(Map<String, dynamic> map) {
    return UserCountries(
      count: map['count'],
      country: Country.fromMap(
        map['country'],
      ),
    );
  }
}
