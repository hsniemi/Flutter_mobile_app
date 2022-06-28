import 'package:flutter/material.dart';
import 'package:flutter_app_summer_project/model/pickable.dart';
import 'package:intl/intl.dart';
import '../db/pickable_database.dart';
import '../themes/custom_theme.dart';

/*
This class creates a view either for creating a new item or editing an existing one
based on which button was pressed in PickableListDetails view.
*/

class ChangeOrCreateDetails extends StatefulWidget {
  const ChangeOrCreateDetails({
    Key? key,
    required this.context,
    this.item,
    required this.pickable,
    this.addToHistory,
    this.updateHistory,
  }) : super(key: key);
  final BuildContext context;
  final PickableHistory?
      item; //If this view is entered to create a new item, then item is null.
  final Pickable pickable;
  final Function? addToHistory;
  final Function? updateHistory;

  @override
  State<ChangeOrCreateDetails> createState() => _ChangeOrCreateDetailsState();
}

class _ChangeOrCreateDetailsState extends State<ChangeOrCreateDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _date;
  late String _notes;
  late double _amount;
  // double _newAmount = 0.0;

  @override
  void initState() {
    //Initialize values for Pickable fields. Initial values depend on whether
    //item is null and we're creating a new one or item exists and we're editing.
    _date = widget.item?.date ?? DateFormat('dd.MM.yy').format(DateTime.now());
    _notes = widget.item?.notes ?? "";
    _amount = widget.item?.amount ?? 0.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Select title based on whether item is null or not.
        title: Text(widget.item == null ? 'Uusi tapahtuma' : 'Muokkaa'),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Container(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            widget.pickable.name,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        Form(
          key: _formKey,
          child: Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height,
                    maxWidth: MediaQuery.of(context).size.width),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 40.0),
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
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            margin: const EdgeInsets.only(right: 40.0),
                            child: inputTextField(
                              'Määrä',
                              true,
                              'amount',
                              TextInputType.number,
                              '0.0',
                              1,
                              _amount.toString(),
                            ),
                          ),
                          Text(
                            '${widget.pickable.unit}a',
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                ?.copyWith(fontSize: 22),
                          )
                        ],
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(top: 20),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height,
                              maxWidth: MediaQuery.of(context).size.width),
                          child: inputTextField(
                            'Muistiinpanoja',
                            false,
                            'notes',
                            TextInputType.text,
                            '',
                            3,
                            _notes,
                          ),
                        ),
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
                  final isValid = _formKey.currentState?.validate();

                  if (isValid!) {
                    //Determine if we're updating or creating an item and select
                    //the method to call on button press based on that.
                    final isUpdating = widget.item != null;

                    if (isUpdating) {
                      await updateItem();
                    } else {
                      await addItem();
                    }
                    addOrUpdateDone();
                  }
                },
                child: const Text('Tallenna'),
              ),
              ElevatedButton(
                onPressed: () {
                  //isOldValue = true;
                  Navigator.pop(context);
                },
                child: const Text('Peruuta'),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget inputTextField(
    String labeltext,
    bool useValidate,
    String variable,
    TextInputType type,
    String hintText,
    int maxLines,
    String initialValue,
  ) {
    return TextFormField(
      autofocus: false,
      initialValue: widget.item == null ? null : initialValue,
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
        hintStyle: CustomInputTheme.inputTextStyle(),
        focusedErrorBorder:
            CustomInputTheme.border(color: Colors.red, width: 2.0),
        errorBorder: CustomInputTheme.border(color: Colors.red),
      ),
      validator: (String? value) {
        if (useValidate) {
          if (value == null || value.isEmpty) {
            return "Määrä puuttuu!";
          } else if (value.contains(',')) {
            return "Desimaalierotin on piste!";
          }
        }
        return null;
      },
      onChanged: (value) {
        switch (variable) {
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
      },
    );
  }

  Future updateItem() async {
    PickableHistory historyItem = PickableHistory(
      id: widget.item!.id,
      pickableId: widget.item!.pickableId,
      date: _date,
      amount: _amount,
      notes: _notes,
    );

//Update historyItem to database.
    final result = await PickableDatabase.instance.updateHistory(historyItem);
    debugPrint('update item: $result');

//Update totalAmount property in Pickable.
    if (_amount < widget.item!.amount) {
      double diff = widget.item!.amount - _amount;
      await updateTotalAmount(-diff);
      widget.pickable.addToTotalAmount(-diff);
    } else if (_amount > widget.item!.amount) {
      double diff = _amount - widget.item!.amount;
      await updateTotalAmount(diff);
      widget.pickable.addToTotalAmount(diff);
    }

//Get index of this PickableHistory object and update it to provider list.
    int index = widget.pickable.history!.indexOf(widget.item!);

    widget.updateHistory!(widget.pickable, historyItem, index);
  }

  Future addItem() async {
    PickableHistory historyItem = PickableHistory(
        pickableId: widget.pickable.id,
        date: _date,
        amount: _amount,
        notes: _notes);

    //Add historyItem to database,
    //result will be the new PickableHistory object with id.
    final result = await PickableDatabase.instance.createHistory(historyItem);
    debugPrint('create item: $result');

    updateTotalAmount(_amount); //Update total amount to database.

//Update totalAmount property in Pickable and add this item to provider list.
    widget.pickable.addToTotalAmount(_amount);
    widget.addToHistory!(widget.pickable, result);
  }

  void addOrUpdateDone() {
    Navigator.pop(context);
  }

  Future updateTotalAmount(double diff) async {
    double amount = widget.pickable.totalAmount + diff;
    await PickableDatabase.instance
        .updateTotalAmount(widget.pickable.id!, amount);
  }
}
