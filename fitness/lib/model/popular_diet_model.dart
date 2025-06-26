class PopularDietModel {
  String name, iconPath, level, duration, calories;
  bool boxIsSelected;

  PopularDietModel({
    required this.name,
    required this.iconPath,
    required this.level,
    required this.duration,
    required this.calories,
    required this.boxIsSelected,
  });

  static List<PopularDietModel> getPopularDiets() {
    List<PopularDietModel> popularDiets = [];

    popularDiets.add(
      PopularDietModel(
        name: 'Blueberry Pancake',
        iconPath: 'assets/svgs/blueberry-pancake.svg',
        level: 'Medium',
        duration: '30mins',
        calories: '230kCal',
        boxIsSelected: true,
      ),
    );

    popularDiets.add(
      PopularDietModel(
        name: 'Salmon Nigiri',
        iconPath: 'assets/svgs/salmon-nigiri.svg',
        level: 'Easy',
        duration: '20mins',
        calories: '120kCal',
        boxIsSelected: false,
      ),
    );

    return popularDiets;
  }
}
