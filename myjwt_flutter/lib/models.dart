class UserModel {
  late String id = '';
  late String email = '';
  late String username = '';
}

class HistoryWeight {
  final int id;
  final DateTime saved_at;
  final double weight;

  HistoryWeight(
      {required this.saved_at, required this.weight, required this.id});

  // List<String> toCsv() => [saved_at.toString(), weight.toString()];
}
