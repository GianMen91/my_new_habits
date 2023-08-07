class ToDo {
  int id;
  String todoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todoText': todoText,
      'isDone': isDone ? 1 : 0,
    };
  }

  static ToDo fromMap(Map<String, dynamic> map) {
    return ToDo(
      id: map['id'],
      todoText: map['todoText'],
      isDone: map['isDone'] == 1, // Convert the int value to bool
    );
  }

}
