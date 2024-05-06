class CharacterStats {
  late int? statsID;
  late int characterLevel;
  late int experience;
  late int points;
  late int strength;
  late int resistance;
  late int agility;
  late int inteligence;

  CharacterStats({
    this.statsID,
    required this.characterLevel,
    required this.experience,
    required this.points,
    required this.strength,
    required this.resistance,
    required this.agility,
    required this.inteligence,
  });

  factory CharacterStats.fromJson(Map<String, dynamic> json) {
    return CharacterStats(
      statsID: json['statsID'],
      characterLevel: json['characterLevel'],
      experience: json['experience'],
      points: json['points'],
      strength: json['strength'],
      resistance: json['resistence'],
      agility: json['agility'],
      inteligence: json['inteligence'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CharacterLevel': characterLevel,
      'Experience': experience,
      'Points': points,
      'Strength': strength,
      'Resistence': resistance,
      'Agility': agility,
      'Inteligence': inteligence,
    };
  }
}
