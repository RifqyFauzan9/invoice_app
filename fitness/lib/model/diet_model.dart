class DietModel {
  String name, iconPath, level, duration, calories;
  bool viewIsSelected;

  DietModel({
    required this.name,
    required this.iconPath,
    required this.level,
    required this.duration,
    required this.calories,
    required this.viewIsSelected,
  });

  static List<DietModel> getDiets() {
    List<DietModel> diets = [];

    diets.add(
      DietModel(
        name: 'Honey Pancake',
        iconPath: 'assets/svgs/honey-pancakes.svg',
        level: 'Easy',
        duration: '30mins',
        calories: '180kCal',
        viewIsSelected: true,
      ),
    );

    diets.add(
      DietModel(
        name: 'Canai Bread',
        iconPath: 'assets/svgs/canai-bread.svg',
        level: 'Easy',
        duration: '20mins',
        calories: '230kCal',
        viewIsSelected: false,
      ),
    );

    return diets;
  }
}
