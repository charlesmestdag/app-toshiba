class DeviceModel {
  final String id;
  final String name;
  final bool isOnline;
  final bool isOn;

  DeviceModel({
    required this.id,
    required this.name,
    required this.isOnline,
    required this.isOn,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'],
      name: json['name'] ?? 'Unknown Device',
      isOnline: json['online'] ?? false,
      isOn: json['on'] ?? false,
    );
  }
}
