import 'identity.dart';

class Role implements Identity {
  @override
  final String id;
  final String name;
  final String permissions;

  Role({
    required this.id,
    required this.name,
    required this.permissions,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "permissions": permissions,
  };

  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
      id: map["id"] as String,
      name: map["name"] as String,
      permissions: map["permissions"] as String,
    );
  }

  @override
  String toString() => name;
}