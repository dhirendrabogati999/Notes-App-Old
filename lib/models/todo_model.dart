
class Todo {
  final int id;
  final String title;
  final String note;
  final String time;
  final bool isDeleted;
  final bool isFavourite;

  Todo({
    required this.id,
    required this.title,
    required this.note, 
    required this.time,
    this.isDeleted = false, 
    this.isFavourite = false,
  });
}