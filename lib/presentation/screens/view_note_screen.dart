import 'package:flutter/material.dart';
import 'package:notes_app/data/model/notes_model.dart';
import 'package:notes_app/data/services/database_helper.dart';
import 'package:notes_app/presentation/screens/add_edit_note_screen.dart';
import '../widgets/snack_bar_message.dart';

class ViewNoteScreen extends StatefulWidget {
  final NoteModel noteModel;

  const ViewNoteScreen({
    super.key,
    required this.noteModel,
  });

  @override
  State<ViewNoteScreen> createState() => _ViewNoteScreenState();
}

class _ViewNoteScreenState extends State<ViewNoteScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(int.parse(widget.noteModel.color)),
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AddEditNoteScreen(noteModel: widget.noteModel),
                  ),
                );
              },
              icon: const Icon(Icons.edit,color: Colors.white,),
          ),
          IconButton(
            onPressed: ()=> _showDeletedDialog(context),
            icon: const Icon(Icons.delete,color: Colors.white,),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1st column (title/Time)............
            Padding(
                padding: const EdgeInsets.only(top: 15,left: 15,bottom: 10,right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title.......
                  Text(
                    widget.noteModel.title,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      const Icon(Icons.access_time,color: Colors.white,),
                      const SizedBox(width: 5,),
                      // time.........
                      Text(
                        _formatDateTime(widget.noteModel.dateTime),
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    widget.noteModel.content,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                    ),
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeletedDialog(BuildContext context) async{
    final confirm = await showDialog(
        context: context,
        builder:(context){
          return AlertDialog(
            title: const Text("Deleted Note"),
            content: const Text("Are you sure you want deleted this note?"),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context,false);
                  },
                  child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: ()async{
                  Navigator.pop(context,true);
                  if(mounted) {
                    showSnackBarMessage(context, "Note deleted successfully!");
                  }
               },
                child: const Text("Delete"),
              ),
            ],
          );
        },
     );
    if(confirm == true){
      await _databaseHelper.deletedNote(widget.noteModel.id!);
      Navigator.pop(context);
    }
  }
}
