class Statistics {
  final int visits;
  final int iosVisits;
  final int androidVisits;
  final int webVisits;
  final int otherVisits;

  Statistics({
    required this.visits,
    required this.iosVisits,
    required this.androidVisits,
    required this.webVisits,
    required this.otherVisits,
  });

  Statistics.empty()
      : visits = 0,
        iosVisits = 0,
        androidVisits = 0,
        webVisits = 0,
        otherVisits = 0;

  Map<String, dynamic> toMap() {
    return {
      'visits': visits,
      'iosVisits': iosVisits,
      'androidVisits': androidVisits,
      'webVisits': webVisits,
      'otherVisits': otherVisits,
    };
  }

  factory Statistics.fromMap(Map<String, dynamic> map) {
    return Statistics(
      visits: map['visits'],
      iosVisits: map['iosVisits'],
      androidVisits: map['androidVisits'],
      webVisits: map['webVisits'],
      otherVisits: map['otherVisits'],
    );
  }
}
