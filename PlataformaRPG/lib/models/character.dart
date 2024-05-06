import 'character_stats.dart';

class Character {
  late int? characterID;
  late int? userID;
  late CharacterStats characterStats;
  late String characterName;
  late int age;
  late double height;
  late String superPower;
  late String appearanceImage;
  late String weaponImage;

  Character({
    this.characterID,
    this.userID,
    required this.characterStats,
    required this.characterName,
    required this.age,
    required this.height,
    required this.superPower,
    required this.appearanceImage,
    required this.weaponImage,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      characterID: json['characterID'],
      characterStats: CharacterStats.fromJson(json['characterStats']),
      characterName: json['characterName'],
      age: json['age'],
      height: json['height'],
      superPower: json['superpower'],
      appearanceImage: json['appearanceImage'],
      weaponImage: json['weaponImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'CharacterName': characterName,
      'Age': age,
      'Height': height,
      'Superpower': superPower,
      'AppearanceImage': appearanceImage,
      'WeaponImage': weaponImage,
      'Stats': characterStats.toJson(),
    };
  }
}
