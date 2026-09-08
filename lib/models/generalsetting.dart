class GeneralSettingsModel {
  final int id;
  final String name;
  final String value;

  const GeneralSettingsModel({
    required this.id,
    required this.name,
    required this.value,
  });

  factory GeneralSettingsModel.fromJson(Map<String, dynamic> json) {
    return GeneralSettingsModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'value': value};
  }
}
