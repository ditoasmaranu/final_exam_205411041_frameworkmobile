import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var isLoading = true;
  var metalPrices = {};

  @override
  void initState() {
    super.initState();
    _fetchMetalPrices();
  }

  //melakukan fetch dari api yang saya pakai
  Future<void> _fetchMetalPrices() async {
    //url api , mohon konfirmasinya apabila hanya loading , soalnya api gratisan sehingga requestnya di limit :)
    final url =
        'https://api.metalpriceapi.com/v1/latest?api_key=5835c18795b3d046a377da4667c4d724&base=USD&currencies=XAU,XAG,XPD,XRH,XCU';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        metalPrices = json.decode(response.body)['rates'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load metal prices');
    }
  }

  //berfungsi mengganti nama yang  umum diketahui orang , karena api yg saya pakai menggunakan nama yg tidak lazim

  String _replaceMetalName(String name) {
    switch (name) {
      case 'XAU':
        return 'Gold';
      case 'XAG':
        return 'Silver';
      case 'XPD':
        return 'Palladium';
      default:
        return name;
    }
  }

  //berfungsi untuk mendefinisikan url dari gambar berdasarkan parameter nama
  String _urlMetalName(String name) {
    switch (name) {
      case 'XAU':
        return 'http://ditoasmaranu.tech/GoldImages.jpg';
      case 'XAG':
        return 'http://ditoasmaranu.tech/SilverImages.jpg';
      case 'XPD':
        return 'http://ditoasmaranu.tech/PalladiumImages.jpg';
      default:
        return name;
    }
  }

  //berfungsi untuk memberikan descripsi berdasarkan parameter nama
  String _descMetalName(String name) {
    switch (name) {
      case 'XAU':
        return 'Gold is a chemical element with the symbol Au and atomic number 79. This makes it one of the higher–atomic-number elements that occur naturally. It is a bright, slightly orange-yellow, dense, soft, malleable, and ductile metal in a pure form. Chemically, gold is a transition metal and a group 11 element.';
      case 'XAG':
        return 'Silver is a chemical element with the symbol Ag (from Latin argentum silver, derived from the Proto-Indo-European h₂erǵ shiny, white and atomic number 47. A soft, white, lustrous transition metal, it exhibits the highest electrical conductivity, thermal conductivity, and reflectivity of any metal.';
      case 'XPD':
        return 'Palladium is a chemical element with the symbol Pd and atomic number 46. It is a rare and lustrous silvery-white metal discovered in 1803 by the English chemist William Hyde Wollaston.';
      default:
        return name;
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          //memberikan nama pada appBar ( kebetulan bingung kasih notenya dimana )
          title: Text('Metal Prices In IDR ( click on list )'),
          backgroundColor: Colors.blueGrey,
        ),
        //Tampilan Loading menggunakan tema DoubleBounce
        body: isLoading
            ? Center(
          child: SpinKitDoubleBounce(
            color: Colors.blue,
            size: 50.0,
          ),
        )
            : ListView.builder(
          itemCount: metalPrices.length,
          itemBuilder: (context, index) {
            final key = metalPrices.keys.toList()[index];
            final value = metalPrices.values.toList()[index];
            //deefinisikan bahwa value friendlyName sama dengan _replaceMetalName dengan parameter key
            final friendlyName = _replaceMetalName(key);
            //deefinisikan bahwa value descOfMetal sama dengan _descMetalName dengan parameter key
            final descOfMetal = _descMetalName(key);
            //deefinisikan bahwa value urlOfImageMetal sama dengan _urlMetalName dengan parameter key
            final urlOfImageMetal = _urlMetalName(key);

            return ListTile(
              title: Text(friendlyName),
              trailing: Text(((value * 12000000)*14000).toStringAsFixed(2)),
              tileColor: Colors.blueAccent.withOpacity(0.1),
              //berfungsi untuk mengakses class MetalDetailScreen ketika list di tap/klik
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MetalDetailScreen(metalName: friendlyName, metalValue: value, metalDescription: descOfMetal, imageUrl: urlOfImageMetal ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class MetalDetailScreen extends StatelessWidget {
  final String metalName;
  final double metalValue;
  final String metalDescription;
  final String imageUrl;

  MetalDetailScreen({
    required this.metalName,
    required this.metalValue,
    required this.metalDescription,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //nama app bar di ambil dari variabel metalName
      appBar: AppBar(
        title: Text(metalName),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        color: Colors.blueAccent.withOpacity(0.1),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              Center(
                child: Image.network(
                  imageUrl,
                  height: 150.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Metal: ',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                metalName,
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Current Value: ',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\Rp${((metalValue*1200000)*140000).toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Description: ',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                metalDescription,
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Back'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
