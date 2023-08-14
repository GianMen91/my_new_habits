class ToDoHistory {
  int id;
  String changeDate;
  // Add this field
  ToDoHistory({
    required this.id,
    required this.changeDate, // Initialize this field
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'changeDate': changeDate,
    };
  }

  static ToDoHistory fromMap(Map<String, dynamic> map) {
    return ToDoHistory(
      id: map['id'],
      changeDate: map['recordDate'],
    );
  }
}
