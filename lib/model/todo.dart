class ToDo {
  String? id;
  String? todoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(
        id: '01',
        todoText: 'Waking up early',
      ),
      ToDo(
        id: '02',
        todoText: 'Journaling before bed',
      ),
      ToDo(
        id: '03',
        todoText: 'Learning an online skill',
      ),
      ToDo(
        id: '04',
        todoText: 'Exercising',
      ),
      ToDo(
        id: '05',
        todoText: 'Creating a proper sleep schedule',
      ),
      ToDo(
        id: '06',
        todoText: 'Taking a 30-minute walk in nature',
      ),
      ToDo(
        id: '07',
        todoText: 'Reading 10 pages a day',
      ),
      ToDo(
        id: '08',
        todoText: 'Limiting screen time',
      ),
    ];
  }
}
