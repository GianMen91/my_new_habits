class ToDo {
  int id;
  String todoText;
  bool isDone;
  String recordDate; // Add this field

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
    required this.recordDate, // Initialize this field
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todoText': todoText,
      'isDone': isDone ? 1 : 0,
      'recordDate': recordDate,
    };
  }

  static ToDo fromMap(Map<String, dynamic> map) {
    return ToDo(
      id: map['id'],
      todoText: map['todoText'],
      isDone: map['isDone'] == 1, // Convert the int value to bool
      recordDate: map['recordDate'],
    );
  }
}
