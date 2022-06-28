// ignore_for_file: dead_code
import 'package:flutter/material.dart';
import 'package:flutter_app_summer_project/db/pickable_database.dart';
import 'package:flutter_app_summer_project/themes/custom_theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app_summer_project/providers/pickable_list_provider.dart';

import '../model/pickable.dart';

/*
This class creates a view for creating a new Pickable item by defining the
name, unit, date, amount and notes. Name field can not be left empty, by default
the unit is set as litre, amount as 0, date as current date and notes as
an empty string if no other value is chosen.
*/

class CreatePickableView extends StatefulWidget {
  const CreatePickableView(
      {Key? key,
      required this.context,
      required this.createPickable,
      required this.addToHistory})
      : super(key: key);

  final BuildContext context;
  final Function createPickable;
  final Function addToHistory;

  @override
  State<CreatePickableView> createState() => _CreatePickableViewState();
}

enum Units { litra, kilo }

class _CreatePickableViewState extends State<CreatePickableView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Units? _unit = Units.litra;
  String _name = '';
  double _amount = 0;
  String _notes = '';
  String _date = DateFormat('dd.MM.yy').format(DateTime.now());
  String _selectedUnit = '';
  bool _nameValid = true;

  @override
  Widget build(BuildContext context) {
    List<Pickable> pickableItemsList =
        context.watch<PickableListProvider>().pickableList;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Luo uusi keräilykohde"),
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height,
                  ),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 90,
                        padding: const EdgeInsets.only(top: 20.0),
                        child: inputTextField("Keräilykohde", true, "name",
                            TextInputType.text, "", 1),
                      ),
                      Container(
                        height: 90,
                        padding: const EdgeInsets.only(top: 20.0),
                        child: inputTextField("Kerätty määrä", true, "amount",
                            TextInputType.number, "0.0", 1),
                      ),
                      Container(
                        height: 120,
                        padding: const EdgeInsets.only(top: 20.0),
                        child: SizedBox(
                          height: 120,
                          width: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Valitse yksikkö",
                                style: Theme.of(context).textTheme.headline2,
                              ),
                              //Creating two radio buttons for selecting unit.
                              Container(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: ListTile(
                                        title: const Text(
                                          'Litra',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        leading: Radio<Units>(
                                          activeColor:
                                              Colors.lightGreenAccent.shade700,
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
                                          activeColor:
                                              Colors.lightGreenAccent.shade700,
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
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(color: Colors.purple),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Text(
                                _date,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    ?.copyWith(fontSize: 22),
                              ),
                            ),
                            //Show a date picker when button is pressed.
                            ElevatedButton(
                              onPressed: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2022),
                                  lastDate: DateTime.now(),
                                ).then(
                                  (date) {
                                    setState(() {
                                      _date =
                                          DateFormat('dd.MM.yy').format(date!);
                                      debugPrint('date: _date');
                                    });
                                  },
                                );
                              },
                              child: Text(
                                "Vaihda päivä",
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: SingleChildScrollView(
                          child: inputTextField("Muistiinpanoja", false,
                              "notes", TextInputType.text, "", 3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    //Check that no other Pickable has the same name.
                    _validateName(pickableItemsList);

                    //Check that name and amount are valid.
                    final isValid = _formKey.currentState?.validate();
                    debugPrint("$isValid");

                    if (isValid!) {
                      //Set the unit based on selected radio button.
                      if (_unit == Units.litra) {
                        _selectedUnit = 'Litra';
                      } else {
                        _selectedUnit = 'Kilo';
                      }

                      //Create a new PickableHistory object with given values.
                      //and set it in historyList variable.

                      PickableHistory newPickableHistory = PickableHistory(
                        date: _date,
                        amount: _amount,
                        notes: _notes,
                      );

                      //Create a new Pickable object with given values.
                      Pickable newPickable = Pickable(
                        name: _name,
                        totalAmount: _amount,
                        unit: _selectedUnit,
                        history: [],
                      );

                      try {
                        //Pass items created above to method createPickableToDB.
                        await createPickableToDB(
                            newPickableHistory, newPickable);
                      } catch (e) {
                        debugPrint('$e');
                      }
                    }
                  },
                  child: Text(
                    "Tallenna",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Peruuta",
                      style: Theme.of(context).textTheme.headline2),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget inputTextField(
    String labeltext,
    bool useValidate,
    String variable,
    TextInputType type,
    String hintText,
    int maxLines,
  ) {
    return TextFormField(
        autofocus: false,
        style: CustomInputTheme.inputTextStyle(),
        cursorColor: Colors.purple,
        keyboardType: type,
        maxLines: maxLines,
        decoration: InputDecoration(
          enabledBorder: CustomInputTheme.border(),
          focusedBorder: CustomInputTheme.border(width: 2.0),
          border: InputBorder.none,
          labelStyle: const TextStyle(color: Colors.purple),
          labelText: labeltext,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.purple,
            fontSize: 18.0,
          ),
          focusedErrorBorder:
              CustomInputTheme.border(color: Colors.red, width: 2.0),
          errorBorder: CustomInputTheme.border(color: Colors.red),
        ),
        validator: (String? value) {
          if (useValidate) {
            if (value == null || value.isEmpty) {
              return "Keräiltävä kohde puuttuu!";
            } else if (!_nameValid) {
              _nameValid = true;
              return "Nimi on jo käytössä!";
            } else if (value.contains(',')) {
              return "Desimaalierotin on piste!";
            }
          }
          return null;
        },
        onChanged: (value) {
          switch (variable) {
            case "name":
              setState(() {
                _name = value;
              });
              break;

            case "amount":
              if (value.contains(',')) {
                break;
              }
              setState(() {
                value.isEmpty
                    ? _amount = double.parse('0.0')
                    : _amount =
                        double.parse(double.parse(value).toStringAsFixed(2));
              });
              break;
            case "notes":
              setState(() {
                _notes = value;
              });
              break;
          }
        });
  }

  //Check that an item by this name doesn't already exist. If there is already an
  //item by the same name, the user get's an error text.
  void _validateName(List<Pickable> pickableItemsList) {
    for (var element in pickableItemsList) {
      if (_name.toLowerCase() == element.name.toLowerCase()) {
        setState(() {
          _nameValid = false;
        });
      }
    }
  }

  Future createPickableToDB(
      PickableHistory history, Pickable newPickable) async {
    //Insert the Pickable into database and store the returned object with
    //id into variable createdItem.
    final createdItem =
        await PickableDatabase.instance.createPickable(newPickable);

    //Set the PickableId field of history item to createdItem.id.
    PickableHistory historyItemWithId = PickableHistory(
      pickableId: createdItem.id,
      date: history.date,
      amount: history.amount,
      notes: history.notes,
    );

    //Insert the history item into database and store the returned item with id
    //into variable createdHistoryItem.
    final createdHistoryItem =
        await PickableDatabase.instance.createHistory(historyItemWithId);
    debugPrint('create Pickable history to db: $createdHistoryItem');

    //Call methods in PickableListView class to add items into provider list.
    widget.addToHistory(createdItem, createdHistoryItem);
    widget.createPickable(createdItem);
  }
}
