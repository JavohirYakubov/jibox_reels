

class CurrencyModel {
  final int id;
  final String name;

  CurrencyModel(this.id, this.name);

  factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
        json["id"],
        json["name"],
      );
}
