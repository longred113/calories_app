class ActivityCalorieIndexModel {
  final String title;
  final String description;
  final double value;

  ActivityCalorieIndexModel(
      {required this.title, required this.description, required this.value});
}

List<ActivityCalorieIndexModel> activityCalorieIndexList = [
  ActivityCalorieIndexModel(
    title: 'Ít vận động',
    description: 'thường chỉ ăn, ngủ và làm việc văn phòng',
    value: 1.2,
  ),
  ActivityCalorieIndexModel(
    title: 'Vận động nhẹ',
    description: "luyện tập thể dục từ 1 – 3 lần/tuần",
    value: 1.375,
  ),
  ActivityCalorieIndexModel(
    title: 'Vận động vừa',
    description: 'luyện tập thể dựng 3 – 5 lần/tuần',
    value: 1.55,
  ),
  ActivityCalorieIndexModel(
    title: 'Vận động nặng',
    description: 'luyện tập thể dục từ 6 – 7 lần/tuần',
    value: 1.725,
  ),
  ActivityCalorieIndexModel(
    title: 'Vận động rất nặng',
    description: 'luyện tập thể 2 lần/ngày',
    value: 1.9,
  ),
];
