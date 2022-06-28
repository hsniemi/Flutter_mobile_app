// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_app_summer_project/db/pickable_database.dart';
import 'package:flutter_app_summer_project/model/pickable.dart';
import 'package:provider/provider.dart';

import '../providers/pickable_list_provider.dart';
import '../themes/custom_theme.dart';

/*
This class creates a view for editing name and unit of an item.
*/

class ChangeName extends StatefulWidget {
  const ChangeName({Key? key, required this.list, required this.index})
      : super(key: key);

  final List<Pickable> list;
  final int index;

  @override
  State<ChangeName> createState() => _ChangeNameState();
}

enum Units { litra, kilo }

class _ChangeNameState extends State<ChangeName> {
  final _inputController = TextEditingController();

  bool _nameValid = true;
  Units? _unit = Units.litra;

  void _submitName() async {
    //Collect the new name entered.
    final enteredName = _inputController.text;

    //Set _nameValid to true before comparing the new name
    //to the other ones in the list.
    setState(() {
      _nameValid = true;
    });

    //Go through the list to make sure new name isn't already given to another item.
    _validateName(enteredName, widget.list, widget.index);

    //If the new name is valid, update it to database,
    //save it to the list of Pickables and notify listeners.
    if (_nameValid) {
      Pickable pickable = widget.list[widget.index];
      pickable.name = enteredName;
      if (_unit == Units.litra) {
        pickable.unit = "Litra";
      } else {
        pickable.unit = "Kilo";
      }

      await PickableDatabase.instance.updatePickable(pickable);

      changeName(pickable);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          TextField(
            decoration: InputDecoration(
              hintText: widget.list[widget.index].name,
              enabledBorder: CustomInputTheme.border(),
              focusedBorder: CustomInputTheme.border(width: 2.0),
              errorBorder: CustomInputTheme.border(color: Colors.red),
              focusedErrorBorder:
                  CustomInputTheme.border(color: Colors.red, width: 2.0),
              errorText: !_nameValid ? 'Nimi on jo käytössä!' : null,
              labelText: 'Uusi nimi',
              labelStyle: TextStyle(
                color: Colors.purple,
              ),
            ),
            style: CustomInputTheme.inputTextStyle(),
            controller: _inputController,
            onSubmitted: (_) => _submitName(),
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              children: [
                Flexible(
                  child: ListTile(
                    title: const Text(
                      'Litra',
                      style: TextStyle(fontSize: 18),
                    ),
                    leading: Radio<Units>(
                      activeColor: Colors.lightGreenAccent.shade700,
                      splashRadius: 40.0,
                      value: Units.litra,
                      groupValue: _unit,
                      onChanged: (Units? value) {
                        setState(() {
                          _unit = value;
                        });
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: ListTile(
                    title: const Text(
                      'Kilo',
                      style: TextStyle(fontSize: 18),
                    ),
                    leading: Radio<Units>(
                      activeColor: Colors.lightGreenAccent.shade700,
                      splashRadius: 40.0,
                      value: Units.kilo,
                      groupValue: _unit,
                      onChanged: (Units? value) {
                        setState(() {
                          _unit = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          ElevatedButton(
            onPressed: _submitName,
            child: Text('Tallenna'),
          ),
        ]),
      ),
    );
  }

//Check that the new name isn't already in the list of Pickables.
  void _validateName(String enteredName, List<Pickable> list, int index) {
    Pickable item = list[index];
    //Create a local list variable that contains the contents of the original list.
    List<Pickable> listWithoutThis = List.from(list);
    //Remove this item from the copy list,
    //because there is no need to compare the new name to the old name of this item.
    listWithoutThis.remove(item);

    //If this item is the only one in the list, no check is necessary.
    if (listWithoutThis.isNotEmpty || listWithoutThis != []) {
      for (var element in listWithoutThis) {
        if (enteredName.toLowerCase() == element.name.toLowerCase()) {
          setState(() {
            _nameValid = false;
          });
        }
      }
    }
  }

//Change the name of the Pickable in provider list.
  void changeName(Pickable item) {
    context.read<PickableListProvider>().changeName(item);

    //Close ModalBottomSheet.
    Navigator.of(context).pop();
  }
}
