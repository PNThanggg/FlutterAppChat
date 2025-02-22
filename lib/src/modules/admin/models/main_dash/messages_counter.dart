class MessagesCounter {
  final int messages;
  final int textMessages;
  final int imageMessages;
  final int videoMessages;
  final int voiceMessages;
  final int fileMessages;
  final int infoMessages;
  final int callMessages;
  final int voiceCallMessages;
  final int videoCallMessages;
  final int locationMessages;
  final int allDeletedMessages;

  MessagesCounter({
    required this.messages,
    required this.textMessages,
    required this.imageMessages,
    required this.voiceCallMessages,
    required this.videoCallMessages,
    required this.videoMessages,
    required this.voiceMessages,
    required this.fileMessages,
    required this.infoMessages,
    required this.callMessages,
    required this.locationMessages,
    required this.allDeletedMessages,
  });

  MessagesCounter.empty()
      : messages = 0,
        textMessages = 0,
        imageMessages = 0,
        videoMessages = 0,
        voiceMessages = 0,
        fileMessages = 0,
        infoMessages = 0,
        videoCallMessages = 0,
        voiceCallMessages = 0,
        callMessages = 0,
        locationMessages = 0,
        allDeletedMessages = 0;

  Map<String, dynamic> toMap() {
    return {
      'messages': messages,
      'textMessages': textMessages,
      'imageMessages': imageMessages,
      'videoMessages': videoMessages,
      'voiceMessages': voiceMessages,
      'fileMessages': fileMessages,
      'videoCallMessages': videoCallMessages,
      'voiceCallMessages': voiceCallMessages,
      'infoMessages': infoMessages,
      'callMessages': callMessages,
      'locationMessages': locationMessages,
      'allDeletedMessages': allDeletedMessages,
    };
  }

  factory MessagesCounter.fromMap(Map<String, dynamic> map) {
    return MessagesCounter(
      messages: map['messages'],
      textMessages: map['textMessages'],
      imageMessages: map['imageMessages'],
      videoMessages: map['videoMessages'],
      voiceMessages: map['voiceMessages'],
      voiceCallMessages: map['voiceCallMessages'],
      videoCallMessages: map['videoCallMessages'],
      fileMessages: map['fileMessages'],
      infoMessages: map['infoMessages'],
      callMessages: map['callMessages'],
      locationMessages: map['locationMessages'],
      allDeletedMessages: map['allDeletedMessages'],
    );
  }
}
