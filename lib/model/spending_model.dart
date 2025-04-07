class SpendingModel {
  int id;
  num amount;
  String date;
  String descripsion;
  String mode;
  int categoryId;

  SpendingModel(
      {required this.id,
        required this.amount,
        required this.date,
        required this.descripsion,
        required this.mode,
        required this.categoryId});

  factory SpendingModel.mapToModel({required Map<String, dynamic> m1}) {
    return SpendingModel(
      id: m1['spending_id'],
      amount: m1['spending_amount'],
      date: m1['spending_date'],
      descripsion: m1['spending_desc'],
      mode: m1['spending_mode'],
      categoryId: m1['spending_category_id'],
    );
  }
}