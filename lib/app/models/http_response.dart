class HttpResponsse {
  bool _isRequest = false;
  bool _isSuccess = false;
  bool _isMessageError = false;
  dynamic _message;
  dynamic _messageError;
  dynamic _data;
  int _statusCode = 200;

  HttpResponsse(this._isRequest, this._isSuccess, this._isMessageError, this._message, this._messageError, this._data,
      this._statusCode);

  factory HttpResponsse.fromJson(Map<String, dynamic> json) {
    HttpResponsse httpResponsse = HttpResponsse(json["isRequest"], json["isSuccess"], json["isMessageError"],
        json["message"], json["messageError"], json["data"], json["statusCode"]);
    return httpResponsse;
  }

  Map<String, dynamic> toJson() => {
        "isRequest": isRequest,
        "isSuccess": isSuccess,
        "isMessageError": isMessageError,
        "message": message,
        "messageError": messageError,
        "data": data,
        "statusCode": statusCode
      };

  @override
  String toString() {
    return toJson().toString();
  }

  dynamic get message => _message;

  set message(dynamic value) {
    _message = value;
  }

  dynamic get data => _data;

  set data(dynamic value) {
    _data = value;
  }

  bool get isRequest => _isRequest;

  set isRequest(bool value) {
    _isRequest = value;
  }

  int get statusCode => _statusCode;

  set statusCode(int value) {
    _statusCode = value;
  }

  dynamic get messageError => _messageError;

  set messageError(dynamic value) {
    _messageError = value;
  }

  bool get isMessageError => _isMessageError;

  set isMessageError(bool value) {
    _isMessageError = value;
  }

  bool get isSuccess => _isSuccess;

  set isSuccess(bool value) {
    _isSuccess = value;
  }
}
