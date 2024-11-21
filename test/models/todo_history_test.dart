class ToDoHistory {
  int id;
  String changeDate;

  ToDoHistory({
    required this.id,
    required this.changeDate,
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
      changeDate: map['changeDate'],
    );
  }
}
