// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app_summer_project/providers/pickable_list_provider.dart';
import '../db/pickable_database.dart';
import '../model/pickable.dart';
import 'change_or_create_details.dart';

/*
This class creates a scrollable list view of history events 
of the selected pickable item.
*/

class PickableListViewDetails extends StatelessWidget {
  const PickableListViewDetails({
    Key? key,
    required this.pickable,
    required this.addToHistory,
    required this.deleteHistoryItem,
    required this.updateHistory,
  }) : super(key: key);
  final Pickable pickable;
  final Function addToHistory;
  final Function updateHistory;
  final Function deleteHistoryItem;

  @override
  Widget build(BuildContext context) {
    //Listen to chages in the list of history events from the provider.
    context.watch<PickableListProvider>().pickableList;

    final theme = Theme.of(context);

    String name = pickable.name;
    String unit = pickable.unit;
    double totalAmount = pickable.totalAmount;

    //History list of pickable won't be null, because the first item was
    //added to it when the Pickable was created.
    List<PickableHistory> historyList = pickable.history!;

    return Scaffold(
      appBar: AppBar(
        //Conjugate the name of the unit correctly.
        title: Text(totalAmount == 1
            ? '$name $totalAmount $unit'
            : '$name $totalAmount ${unit}a'),
      ),
      body: Container(
        height: 600,
        child: ListView.builder(
            itemCount: historyList.length,
            itemBuilder: (BuildContext context, int index) {
              return Stack(
                children: [
                  Positioned(
                    child:
                        pickableHistoryCard(historyList[index], context, unit),
                  ),
                  Positioned(
                    right: 16.0,
                    top: 12.0,
                    //Pressing this button opens the CreateOrChangeDetail view
                    //for editing a history event and passes the context, Pickable
                    //object, PickableHistory object to be edited and updateHistory
                    //method defined in home.dart as arguments.
                    child: TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeOrCreateDetails(
                            context: context,
                            item: historyList[index],
                            pickable: pickable,
                            updateHistory: updateHistory,
                          ),
                        ),
                      ),
                      child: Text(
                        'Muokkaa',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10.0,
                    top: 10.0,
                    child: IconButton(
                      color: Colors.orangeAccent.shade700,
                      icon: const Icon(Icons.delete_forever_rounded),
                      onPressed: () async {
                        //Show dialog to confirm deleting item when icon button is pressed.
                        bool? result = await showDialog<bool>(
                          context: context,
                          builder: (context) => showAlertDialog(context, theme),
                        );
                        if (result == true) {
                          await deleteHistoryItemFromDB(historyList[index].id!);
                          pickable.addToTotalAmount(-historyList[index].amount);
                          deleteHistoryItem(pickable, historyList[index]);
                        }
                      },
                    ),
                  ),
                ],
              );
            }),
      ),
      //Pressing this button opens the ChangeOrCreateDetails view for
      //creating a new history event and passes context, the Pickable object
      //and addToHistory method defined in home.dart as arguments.
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeOrCreateDetails(
              context: context,
              addToHistory: addToHistory,
              pickable: pickable,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 5.0,
        child: const Icon(
          Icons.add,
          size: 30.0,
          color: Colors.purple,
        ),
      ),
    );
  }

  AlertDialog showAlertDialog(BuildContext context, ThemeData theme) {
    return AlertDialog(
      title: const Text("Poista tapahtuma"),
      content: const Text("Haluatko poistaa kohteen ja kaikki sen tiedot?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(
            "Poista",
            style: theme.textTheme.bodyText2,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            "Peruuta",
            style: theme.textTheme.bodyText2,
          ),
        ),
      ],
    );
  }

//Create a view with information about a history event inside a card widget.
  Widget pickableHistoryCard(
      PickableHistory historyListItem, BuildContext context, String unit) {
    final textStyle = Theme.of(context).textTheme.bodyText2?.copyWith(
          color: Colors.purple,
          fontSize: 18,
        );
    final titleStyle = Theme.of(context).textTheme.headline1?.copyWith(
          fontSize: 22,
        );

    return Container(
      margin: const EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  historyListItem.date,
                  style: titleStyle,
                ),
              ],
            ),
            Divider(
              thickness: 4.0,
              color: Colors.amber[200],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Määrä: ',
                  style: titleStyle,
                ),
                Text(
                  '${historyListItem.amount} ',
                  style: textStyle?.copyWith(fontSize: 22),
                ),
                Text(
                  historyListItem.amount == 1 ? unit : '${unit}a',
                  style: textStyle,
                ),
              ],
            ),
            //Only show the title "Muistiinpanot" and a box for the notes if
            //notes is not empty.
            historyListItem.notes == ""
                ? const SizedBox(
                    height: 0.0,
                  )
                : const SizedBox(
                    height: 10.0,
                  ),
            historyListItem.notes == ""
                ? const SizedBox(
                    height: 0.0,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Muistiinpanot: ',
                        style: titleStyle,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        padding: const EdgeInsets.all(10.0),
                        height: 90,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                            color: Colors.purple,
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Text(
                                  historyListItem.notes,
                                  style: textStyle?.copyWith(
                                    color: Colors.purple,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
          ]),
        ),
      ),
    );
  }

  Future deleteHistoryItemFromDB(int id) async {
    await PickableDatabase.instance.deleteHistory(id);
  }
}
