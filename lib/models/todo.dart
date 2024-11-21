// The ToDo class represents a to-do item with all its attributes and behavior
class ToDo {
  int id; // Unique identifier for each ToDo
  String todoText; // The text describing the task
  bool isDone; // Whether the task is completed (done) or not
  bool isFavourite; // Whether the task is marked as a favourite
  String recordDate; // The date when the to-do item was created or last updated

  // Constructor for creating a new ToDo object
  ToDo({
    required this.id, // id is required and passed in the constructor
    required this.todoText, // todoText is required and passed in the constructor
    this.isDone = false, // Default value is false (not done)
    this.isFavourite = false, // Default value is false (not favourite)
    required this.recordDate, // recordDate is required and passed in the constructor
  });

  // Convert the ToDo object to a Map (for database insertion or updating)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      // Convert 'id' to map entry
      'todoText': todoText,
      // Convert 'todoText' to map entry
      'isDone': isDone ? 1 : 0,
      // Convert 'isDone' to 1 for true and 0 for false
      'isFavourite': isFavourite ? 1 : 0,
      // Convert 'isFavourite' to 1 for true and 0 for false
      'recordDate': recordDate,
      // Convert 'recordDate' to map entry
    };
  }

  // Create a ToDo object from a Map (used for converting database query results into a ToDo object)
  static ToDo fromMap(Map<String, dynamic> map) {
    return ToDo(
      id: map['id'],
      // Retrieve the 'id' from the map
      todoText: map['todoText'],
      // Retrieve the 'todoText' from the map
      isDone: map['isDone'] == 1,
      // Convert the 'isDone' value from 1 (true) or 0 (false) to a boolean
      isFavourite: map['isFavourite'] == 1,
      // Convert the 'isFavourite' value from 1 (true) or 0 (false) to a boolean
      recordDate: map['recordDate'], // Retrieve the 'recordDate' from the map
    );
  }
}
