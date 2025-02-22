import '../models.dart';

class MainDashBoardModel {
  final UserData usersData;
  final UserDevices usersDevices;
  final Statistics statistics;
  final List<UserCountries> usersCountries;
  final MessagesCounter messagesCounter;
  final RoomCounter roomCounter;

  MainDashBoardModel({
    required this.usersData,
    required this.usersDevices,
    required this.statistics,
    required this.usersCountries,
    required this.messagesCounter,
    required this.roomCounter,
  });

  MainDashBoardModel.empty()
      : usersData = UserData.empty(),
        usersDevices = UserDevices.empty(),
        statistics = Statistics.empty(),
        usersCountries = [],
        messagesCounter = MessagesCounter.empty(),
        roomCounter = RoomCounter.empty();

  Map<String, dynamic> toMap() {
    return {
      'usersData': usersData.toMap(),
      'usersDevices': usersDevices.toMap(),
      'statistics': statistics.toMap(),
      'usersCountries': usersCountries.map((uc) => uc.toMap()).toList(),
      'messagesCounter': messagesCounter.toMap(),
      'roomCounter': roomCounter.toMap(),
    };
  }

  factory MainDashBoardModel.fromMap(Map<String, dynamic> map) {
    return MainDashBoardModel(
      usersData: UserData.fromMap(map['usersData']),
      usersDevices: UserDevices.fromMap(map['usersDevices']),
      statistics: Statistics.fromMap(map['statistics']),
      usersCountries: List<UserCountries>.from(map['usersCountries'].map((uc) => UserCountries.fromMap(uc))),
      messagesCounter: MessagesCounter.fromMap(map['messagesCounter']),
      roomCounter: RoomCounter.fromMap(map['roomCounter']),
    );
  }
}
