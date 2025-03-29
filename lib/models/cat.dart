enum Moods { dead, happy, sad, sleeping }

class Cat {
  String name;
  late Moods mood;

  int health = 100;
  int happiness = 50;
  int thirst = 100;
  int hunger = 100;
  int birth = DateTime.now().millisecondsSinceEpoch;

  late DateTime lastHappinessUpdate;

  int deathTime = 0;
  bool dead = false;

  final List<String> images = [
    'assets/cat/dead.png',
    'assets/cat/happy.png',
    'assets/cat/sad.png',
    'assets/cat/sleeping.png',
  ];

  Cat({
    required this.name,
    this.health = 100,
    this.happiness = 50,
    this.thirst = 100,
    this.hunger = 100,
  }) {
    this.lastHappinessUpdate = DateTime.now();
    UpdateMood();
  }

  factory Cat.FromJson(Map<String, dynamic> json) {
    Cat cat = Cat(name: json["name"]);

    cat.health = json["health"];
    cat.happiness = json["happiness"];
    cat.thirst = json["thirst"];
    cat.hunger = json["hunger"];
    cat.birth = json['birth'];
    cat.lastHappinessUpdate = DateTime.parse(json['lastHappinessUpdate']);

    cat.UpdateMood();

    return cat;
  }

  Map<String, dynamic> ToJson() {
    return {
      'name': name,
      'health': health,
      'happiness': happiness,
      'thirst': thirst,
      'hunger': hunger,
      'birth': birth,
      'lastHappinessUpdate': lastHappinessUpdate.toIso8601String(),
    };
  }

  void Kill() {
    deathTime = DateTime.now().millisecondsSinceEpoch;
    dead = true;
    happiness = 0;
    thirst = 0;
    UpdateMood();
  }

  void UpdateMood() {
    if (thirst < 20) {
      mood = Moods.dead;
    } else if (happiness < 50 || thirst < 50) {
      mood = Moods.sad;
    } else if (happiness < 100 || thirst < 90) {
      mood = Moods.happy;
    } else {
      mood = Moods.sleeping;
    }
  }

  String get currentImage => images[mood.index];
  double get aliveFor =>
      ((dead ? deathTime : DateTime.now().millisecondsSinceEpoch) - birth) /
      86400000;
}
