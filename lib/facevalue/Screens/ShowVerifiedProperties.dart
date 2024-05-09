import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onpensea/Property/Feature-ShowAllDetails/Controller/PropertyController.dart';
import 'package:onpensea/Property/Feature-ShowAllDetails/Models/Properties.dart';

class ShowVerifiedProperties extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShowVerifiedPropertiesViewState();
  }
}

class _ShowVerifiedPropertiesViewState extends State<ShowVerifiedProperties> {
  late Future<List<Properties>> prop;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prop = PropertyController.fetchProperties();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('O3 Properties'),
      ),
      body: FutureBuilder<List<Properties>>(
        future: prop,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final propList = snapshot.data!;
            
            print(propList);
            
            return ListView.builder(
              itemCount: propList.length,
              itemBuilder: (context, index) {
                final property = propList[index];
                return ListTile(
                  leading: Image.network(
                      'http://45.118.162.234/home/ubuntu/ERC20/propertyManagement/images/Policies.png',

                    cacheHeight: 50,
                    cacheWidth: 50,
                  ),
                  title: Text(property.propName),
                  subtitle: Text(property.address),
                  onTap: () {},
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error} '));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
