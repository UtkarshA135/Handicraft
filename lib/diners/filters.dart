import 'package:flutter/material.dart';
//import 'package:homemade/homemade.dart';

class Filter extends StatefulWidget {
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  String dropdownValue = 'American';
  List<bool> choicesChipsmeal = [
    false,
    false,
    false,
    false,
  ];
  List<bool> choicesChipsfoodtype = [
    false,
    false,
    false,
    
  ];
  List<bool> choicesChipsdistance = [
    false,
    false,
    false,
  ];
  List<bool> choicesChipsratings = [
    false,
    false,
    false,
  ];
  static const meal = ['Breakfast', 'Brunch', 'Lunch', 'Dinner'];
  static const foodtype = ['Veg', 'Non-Veg', 'Vegan'];
  static const distance = ['0-5 kms', '6-10 kms', '10+ kms'];
  static const ratings = ['4+', '3+', '2+'];
  List<String> dropdownItems = <String>[
    'American',
    'Belizean ',
     'Chinese',
     'Canadian',
     'Japaneese',
    'Indian',
    'Italian',
    'Mexican',
    'Texan',
   
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(children: [
          Container(
              height: 30,
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                ),
                iconSize: 30,
                onPressed: () {},
              )),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
          
            
            Container(
               
                child: Text(' Filter ',
                    style: TextStyle(fontSize: 30, color: Colors.redAccent[700]))),
            Container(
              
              child: FlatButton(
                color: Colors.white,
                onPressed: () {},
                child: Text(
                  'Reset',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ]),
          Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Meal",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                )),
          ),
          Wrap(
            children: List.generate(
              choicesChipsmeal.length,
              (i) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: FilterChip(
                  selected: choicesChipsmeal[i],
                  onSelected: (t) {
                    setState(() {
                      choicesChipsmeal[i] = !choicesChipsmeal[i];
                    });
                  },
                  label: Text(meal[i]),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Food type",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                )),
          ),
          Wrap(
            children: List.generate(
              choicesChipsfoodtype.length,
              (i) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: FilterChip(
                  selected: choicesChipsfoodtype[i],
                  onSelected: (t) {
                    setState(() {
                      choicesChipsfoodtype[i] = !choicesChipsfoodtype[i];
                    });
                  },
                  label: Text(foodtype[i]),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Distance",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                )),
          ),
          Wrap(
            children: List.generate(
              choicesChipsdistance.length,
              (i) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: FilterChip(
                  selected: choicesChipsdistance[i],
                  onSelected: (t) {
                    setState(() {
                      choicesChipsdistance[i] = !choicesChipsdistance[i];
                    });
                  },
                  label: Text(distance[i]),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Ratings",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                )),
          ),
          Wrap(
            children: List.generate(
              choicesChipsratings.length,
              (i) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: FilterChip(
                  selected: choicesChipsratings[i],
                  onSelected: (t) {
                    setState(() {
                      choicesChipsratings[i] = !choicesChipsratings[i];
                    });
                  },
                  label: Text(ratings[i]),
                ),
              ),
            ),
          ),
          Row(children: [
            Container(
              width: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Cuisine",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    )),
              ),
            ),
            Container(
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 36,
                style: TextStyle(color: Colors.black, fontSize: 15),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items:
                    dropdownItems.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ]),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ Colors.red[900],
                                Colors.red[500],
                                Colors.red[900]
                               ],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  'Apply',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
        ]),
      ),
    );
  }
}
