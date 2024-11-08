import 'package:flutter/material.dart';
import 'package:notes_app/data/model/notes_model.dart';
import 'package:notes_app/data/services/database_helper.dart';
import 'package:notes_app/presentation/screens/add_edit_note_screen.dart';
import 'package:notes_app/presentation/screens/view_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<NoteModel> _notes = [];

  // Format DateTime.....
  String _formatDateTime(String dateTime) {
    final DateTime dt = DateTime.parse(dateTime);
    final now = DateTime.now();

    // Determine if it's AM or PM
    String period = dt.hour >= 12 ? 'PM' : 'AM';
    int hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12; // Convert to 12-hour format

    // Format time with leading zeroes for minutes and the period
    String formattedTime = '${hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} $period';

    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Today  $formattedTime';
    }

    return '${dt.day}/${dt.month}/${dt.year}, $formattedTime';
  }



  // get notes ......
  Future<void> _loadNotes() async{
    _notes.clear();
    final notes= await _databaseHelper.getNote();
    setState(() {
      _notes = notes;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        automaticallyImplyLeading: false,
      ),
      body: GridView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: _notes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
          ),
          itemBuilder: (context, index){
            final note = _notes[index];
            final color = Color(int.parse(note.color));

            return GestureDetector(
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ViewNoteScreen(noteModel: note),
                  ),
                );
                // Refresh notes list after returning.
                _loadNotes();
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0,2),
                    ),
                  ]
                ),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                       note.title,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      note.content,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      _formatDateTime(note.dateTime),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context)=> const AddEditNoteScreen(),
            ),
          );
          // Refresh notes list after returning.
          _loadNotes();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
