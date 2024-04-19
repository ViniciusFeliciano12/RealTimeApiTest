class Message {
  late String name;
  late String message;
  late bool nameVisible = true;
  late String messageHour;
  late bool isHovered = false;

  Message(
      {required this.name,
      required this.message,
      required this.messageHour,
      required this.nameVisible});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      name: json['name'],
      message: json['message'],
      messageHour: json['messageHour'],
      nameVisible: json['nameVisible'],
    );
  }
}
