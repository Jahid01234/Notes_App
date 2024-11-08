import 'package:flutter/material.dart';
import 'package:notes_app/data/model/notes_model.dart';
import 'package:notes_app/data/services/database_helper.dart';
import 'package:notes_app/presentation/screens/home_screen.dart';
import 'package:notes_app/presentation/widgets/snack_bar_message.dart';

class AddEditNoteScreen extends StatefulWidget {
  final NoteModel? noteModel;

  const AddEditNoteScreen({
    super.key,
    this.noteModel,
  });

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
   final TextEditingController _titleController = TextEditingController();
   final TextEditingController _contentController = TextEditingController();
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   Color _selectedColor = Colors.lightBlueAccent;

   final DatabaseHelper _databaseHelper = DatabaseHelper();
   final List<Color> _color = [
     Colors.blue,
     Colors.pink,
     Colors.deepOrangeAccent,
     Colors.teal,
     Colors.indigoAccent,
     Colors.blueGrey,
     Colors.orangeAccent,
     Colors.pinkAccent,
   ];


  @override
  void initState() {
    super.initState();
    if(widget.noteModel != null){
      _titleController.text = widget.noteModel!.title;
      _contentController.text = widget.noteModel!.content;
      _selectedColor = Color(int.parse(widget.noteModel!.color));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteModel == null? "Add Notes":"Edit Notes"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20,top: 5),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // title text field
                TextFormField(
                  controller: _titleController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    hintText: "Title",
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                        return "Please enter title";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // content text field
                TextFormField(
                  controller: _contentController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    hintText: "Content",
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Please enter content";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Color picker
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _color.map((color) {
                      return GestureDetector(
                        onTap: (){
                          _selectedColor = color;
                          setState(() {});
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedColor == color ? Colors.white:Colors.transparent
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )
                ),
                const SizedBox(height: 30),

                // Elevated Button
                ElevatedButton(
                    onPressed: (){
                      _saveNote();
                    },
                    child: const Text(
                      "Save Note",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                      ),
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // save note button onPress action
  Future<void> _saveNote() async{
    if(_formKey.currentState!.validate()){
      final note = NoteModel(
          id: widget.noteModel?.id ,
          title: _titleController.text,
          content: _contentController.text,
          color: _selectedColor.value.toString(),
          dateTime: DateTime.now().toString(),
      );

      if(widget.noteModel == null){
        await _databaseHelper.insertNote(note);
        if(mounted) {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
          showSnackBarMessage(context, "Note added successfully!");
        }
      }else{
        await _databaseHelper.updateNote(note);
        if(mounted) {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
          showSnackBarMessage(context, "Note updated successfully!");
        }
      }
    }
  }

}
