enum VMessageItemClickRes { forward, reply, share, info, delete, copy, download, star, unStar, translate }

enum LoadMoreStatus { loading, loaded, error, completed }

enum CallStatus {
  //when init the stream
  connecting,
  busy,
  ring,
  //call started
  accepted,
  roomAlreadyInCall,
  timeout,
  //when any user close the chat
  callEnd,
  rejected;

  bool get isConnecting => this == CallStatus.connecting;

  bool get isBusy => this == CallStatus.busy;

  bool get isRing => this == CallStatus.ring;

  bool get isAccepted => this == CallStatus.accepted;

  bool get isTimeOut => this == CallStatus.timeout;

  bool get isCallEnd => this == CallStatus.callEnd;

  bool get isRejected => this == CallStatus.rejected;

  bool get isRoomAlreadyInCall => this == CallStatus.roomAlreadyInCall;
}
