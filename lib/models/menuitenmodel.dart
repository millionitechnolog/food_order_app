class MenuItemStatusModel {
  final String name;
  final String rowGuid;
  bool isSoldOut;

  MenuItemStatusModel({
    required this.name,
    required this.rowGuid,
    required this.isSoldOut,
  });

  factory MenuItemStatusModel.fromJson(Map<String, dynamic> json) {
    return MenuItemStatusModel(
      name: json['name']?.toString() ?? '',
      rowGuid: json['rowGuid']?.toString() ?? '',
      isSoldOut: json['isSoldOut'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'rowGuid': rowGuid, 'isSoldOut': isSoldOut};
  }
}
