import 'package:eccommerces_app/screens/subcategories_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categories_provider.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<CategoeriesProvider>(context, listen: false).loadCategoeriess();
    // _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Categories',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.blueAccent[700],
        ),

        // Add your screen content here
        body: Consumer<CategoeriesProvider>(
            builder: (context, categoeriesProvider, _) {
          final categoeries = categoeriesProvider.categoeriess;
          print('productsproducts of ....categoeries: ${categoeries}');
          return ListView.builder(
            itemCount: categoeries.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            'assets/images/${categoeries[index].imageUrl}',
                            // Path to image
                            height: 100,
                            alignment: Alignment.center,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )),
                    SizedBox(width: 10,),
                    Expanded(
                      flex: 5,
                      child: Text(
                        "${categoeries[index].title}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to subcategory screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubCategoriesScreen(
                              subCategories: categoeries[index].subCategories,
                            ),
                          ),
                        );
                      },
                      child: Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              );
            },
          );
        }));

/*

*/
  }
}

class Category {
  final String title;
  final List<SubCategory> subCategories;

  Category({required this.title, required this.subCategories});
}

class SubCategory {
  final String subTitle;

  SubCategory({required this.subTitle});
}
