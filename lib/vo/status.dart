class Status {
  String status;
  String message;
  String errorCode;
  Status(
      {required this.status, required this.message, required this.errorCode});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
        status: json['status'],
        message: json['message'],
        errorCode: json['error_code']);
  }
}
