class BackgroundMsg {
  String? id;
  String? itemId;
  String? itemType;

  BackgroundMsg({
    this.id,
    this.itemId,
    this.itemType,
  });

  factory BackgroundMsg.fromJson(Map<String, dynamic> json) {
    return BackgroundMsg(
      id: json['id'],
      itemId: json['item_id'],
      itemType: json['item_type'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'item_id': itemId,
        'item_type': itemType,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
