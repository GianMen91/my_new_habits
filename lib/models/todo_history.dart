// The ToDoHistory class represents a record of changes made to a ToDo item
class ToDoHistory {
  int id; // Unique identifier for each history record
  String changeDate; // The date and time when the change occurred

  // Constructor for creating a new ToDoHistory object
  ToDoHistory({
    required this.id, // id is required and passed in the constructor
    required this.changeDate, // changeDate is required and passed in the constructor
  });

  // Convert the ToDoHistory object to a Map (for database insertion or updating)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Convert 'id' to map entry
      'changeDate': changeDate, // Convert 'changeDate' to map entry
    };
  }

  // Create a ToDoHistory object from a Map (used for converting database query results into a ToDoHistory object)
  static ToDoHistory fromMap(Map<String, dynamic> map) {
    return ToDoHistory(
      id: map['id'], // Retrieve the 'id' from the map
      changeDate: map['changeDate'], // Retrieve the 'changeDate' from the map
    );
  }
}
