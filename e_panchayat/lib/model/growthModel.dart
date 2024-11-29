class Growthmodel {
  String? title;
  String? id;
  String? date;
  String? scheme;
  String? activityType;
  String? expenditure;
  String? estimatedCost;
  String? startDate;
  String? endDate;
  double? progress;
  String? status;

  Growthmodel(
      {this.title,
      required this.id,
      required this.date,
      required this.scheme,
      required this.activityType,
      required this.expenditure,
      required this.estimatedCost,
      required this.startDate,
      required this.endDate,
      required this.progress,
      required this.status});
}

List<Growthmodel> ongoingProjects = [];
List<Growthmodel> completedProjects = [];
