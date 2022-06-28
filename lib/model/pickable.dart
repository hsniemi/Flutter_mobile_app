//Pickable objects contain information about items,
//such as berries and mushrooms, that the user is gathering.
class Pickable {
  int? id;
  String name;
  double totalAmount;
  String unit;
  List<PickableHistory>? history = [];

  Pickable({
    this.id,
    required this.name,
    required this.totalAmount,
    required this.unit,
    this.history,
  });

  @override
  String toString() {
    return '$id, $name, $totalAmount, $unit';
  }

  addToTotalAmount(double amount) {
    totalAmount += amount;
  }

  Pickable copy({
    int? id,
    String? name,
    double? totalAmount,
    String? unit,
    List<PickableHistory>? history,
  }) =>
      Pickable(
        id: id ?? this.id,
        name: name ?? this.name,
        totalAmount: totalAmount ?? this.totalAmount,
        unit: unit ?? this.unit,
        history: history ?? this.history,
      );

  static Pickable fromMap(Map<String, Object?> map) => Pickable(
        id: map[PickableFields.id] as int?,
        name: map[PickableFields.name] as String,
        totalAmount: map[PickableFields.totalAmount] as double,
        unit: map[PickableFields.unit] as String,
      );

  Map<String, Object?> toMap() => {
        PickableFields.id: id,
        PickableFields.name: name,
        PickableFields.totalAmount: totalAmount,
        PickableFields.unit: unit,
      };
}

//PickableHistory objects contain information about individual picking events.
class PickableHistory {
  int? id;
  int? pickableId;

  String date;
  double amount;
  String notes;

  PickableHistory({
    this.id,
    this.pickableId,
    required this.date,
    required this.amount,
    required this.notes,
  });

  @override
  String toString() {
    return 'id: $id, foreign key: $pickableId, amount: $amount, date: $date, notes: $notes';
  }

  PickableHistory copy({
    int? id,
    int? pickableId,
    String? date,
    double? amount,
    String? notes,
  }) =>
      PickableHistory(
        id: id ?? this.id,
        pickableId: pickableId ?? this.pickableId,
        date: date ?? this.date,
        amount: amount ?? this.amount,
        notes: notes ?? this.notes,
      );

  static PickableHistory fromMap(Map<String, Object?> map) => PickableHistory(
        id: map[HistoryFields.id] as int?,
        pickableId: map[HistoryFields.pickable_id] as int?,
        date: map[HistoryFields.date] as String,
        amount: map[HistoryFields.amount] as double,
        notes: map[HistoryFields.notes] as String,
      );

  Map<String, Object?> toMap() => {
        HistoryFields.id: id,
        HistoryFields.pickable_id: pickableId,
        HistoryFields.date: date,
        HistoryFields.amount: amount,
        HistoryFields.notes: notes,
      };
}

const String pickables = 'pickables';
const String history = 'history';

class PickableFields {
  static final List<String> values = [
    id,
    name,
    totalAmount,
    unit,
    history,
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String totalAmount = 'total_amount';
  static const String unit = 'unit';
  static const String history = 'history';
}

class HistoryFields {
  static final List<String> values = [
    id,
    pickable_id,
    date,
    amount,
    notes,
  ];
  static const String id = '_id';
  static const String pickable_id = 'pickable_id';
  static const String date = 'date';
  static const String amount = 'amount';
  static const String notes = 'notes';
}
