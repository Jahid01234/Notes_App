
class NoteModel{
  final int? id;
  final String title;
  final String content;
  final String color;
  final String dateTime;

  NoteModel({
    this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.dateTime,
  });

  // add to data map
  Map<String,dynamic> toMap(){
    return{
      'id': id,
      'title': title,
      'content': content,
      'color': color,
      'dateTime': dateTime,
    };
  }

  // retrieve the data from map
  factory NoteModel.fromMap(Map<String,dynamic> map){
    return NoteModel(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      color: map['color'],
      dateTime: map['dateTime'],
    );
  }

}