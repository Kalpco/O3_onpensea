import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/constants/colors.dart';
import '../Home/widgets/DividerWithAvatar.dart';
import '../product/screen/productHome/products_home_screen.dart';
import '../product/screen/productHomeAppBar/common_top_bar.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int selectedCategoryIndex = 0;

  final categories = [
    'Ring',
    'Pendant',
    'Bracelet',
    'Earing',
    'Necklace',
    'Bangles',
  ];

  // Updated subcategories with product images
  final Map<String, Map<String, List<Map<String, String>>>> subCategoriesMap = {
    'Ring': {
      'Recently Added': [
        {
          'productName': 'Gold 01',
          'imagePath': 'assets/ring/ring_one.jpg',
        },
        {
          'productName': 'Silver 01',
          'imagePath': 'assets/ring/ring_two.jpg',
        },
        {
          'productName': 'Diamond 01',
          'imagePath': 'assets/gold/category_ring.png',
        },
        {
          'productName': 'View All',
          'imagePath': '', // No image for "View All"
        },
      ],
      'Gold Collection': [
        {
          'productName': 'Gold 01',
          'imagePath': 'assets/ring/ring_two.jpg',
        },
        {
          'productName': 'Silver 01',
          'imagePath': 'assets/ring/ring_one.jpg',
        },
        {
          'productName': 'Diamond 01',
          'imagePath': 'assets/gold/category_ring.png',
        },
        {
          'productName': 'View All',
          'imagePath': '', // No image for "View All"
        },
      ],
    },
    'Pendant': {
      'Recently Added': [
        {
          'productName': 'Gold 01',
          'imagePath': 'assets/pendant/pedanant_one.jpg',
        },
        {
          'productName': 'Silver 01',
          'imagePath': 'assets/pendant/pedanant_two.jpg',
        },
        {
          'productName': 'Diamond 01',
          'imagePath': 'assets/pendant/pedanant_three.jpg',
        },
        {
          'productName': 'View All',
          'imagePath': '', // No image for "View All"
        },
      ],
      'Gold Collection': [
        {
          'productName': 'Gold 05',
          'imagePath': 'assets/pendant/pedanant_three.jpg',
        },
        {
          'productName': 'Gold 06',
          'imagePath': 'assets/pendant/pedanant_one.jpg',
        },
        {
          'productName': 'View All',
          'imagePath': '', // No image for "View All"
        },
      ],
      'Silver Collection': [
        {
          'productName': 'Silver 04',
          'imagePath': 'assets/pendant/pedanant_two.jpg',
        },
        {
          'productName': 'Silver 05',
          'imagePath': 'assets/pendant/pedanant_three.jpg',
        },
        {
          'productName': 'View All',
          'imagePath': '', // No image for "View All"
        },
      ],
    },
    'Bracelet': {
      'Recently Added': [
        {
          'productName': 'Diamond 01',
          'imagePath': 'assets/pendant/pedanant_one.jpg',
        },
        {
          'productName': 'Diamond 02',
          'imagePath': 'assets/pendant/pedanant_one.jpg',
        },
        {
          'productName': 'View All',
          'imagePath': '', // No image for "View All"
        },
      ],
      'Gold Collection': [
        {
          'productName': 'Gold 07',
          'imagePath': 'assets/pendant/pedanant_one.jpg',
        },
        {
          'productName': 'Gold 08',
          'imagePath': 'assets/pendant/pedanant_one.jpg',
        },
        {
          'productName': 'View All',
          'imagePath': '', // No image for "View All"
        },
      ],
    },
    'Necklace': {
      'Recently Added': [

      ],
      'Gold Collection': [

      ],
    },
    'Earing': {
      'Recently Added': [

      ],
      'Gold Collection': [

      ],
    },
    'Bangles': {
      'Recently Added': [

      ],
      'Gold Collection': [

      ],
    },
    // Add more categories and their subcategories as needed
  };

  // Get the current subcategories based on the selected category
  Map<String, List<Map<String, String>>> get subCategories =>
      subCategoriesMap[categories[selectedCategoryIndex]] ?? {};

  @override
  Widget build(BuildContext context) {
    return CommonTopAppBar(
      body: Padding(
        padding: const EdgeInsets.only(top: 0.0), // Margin from the top
        child: Row(
          children: [
            // Category List
            // Expanded(
            //   flex: 6,
            //   child: ListView.builder(
            //     itemCount: categories.length,
            //     itemBuilder: (context, index) {
            //       bool isSelected = selectedCategoryIndex == index;
            //       return GestureDetector(
            //         onTap: () {
            //           setState(() {
            //             selectedCategoryIndex = index;
            //           });
            //         },
            //         child: Container(
            //           color: isSelected
            //               ? U_Colors.yaleBlue.withOpacity(0.1)
            //               : Colors.white,
            //           padding: EdgeInsets.symmetric(vertical: 8.0),
            //           child: ListTile(
            //             title: Stack(
            //               children: [
            //                 Text(
            //                   categories[index],
            //                   style: GoogleFonts.poppins(
            //                     fontSize: isSelected ? 14 : 12,
            //                     fontWeight: isSelected
            //                         ? FontWeight.w600
            //                         : FontWeight.w500,
            //                     color: isSelected
            //                         ? U_Colors.yaleBlue
            //                         : Colors.black,
            //                   ),
            //                 ),
            //                 if (isSelected)
            //                   Positioned(
            //                     bottom: -2,
            //                     left: 0,
            //                     right: 0,
            //                     child: Container(
            //                       height: 4,
            //                       color: U_Colors.yaleBlue,
            //                     ),
            //                   ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            Expanded(
              flex: 6,
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedCategoryIndex == index;

                  // Define image paths for the categories
                  String imagePath;
                  switch (categories[index]) {
                    case 'Ring':
                      imagePath = 'assets/gold/category_ring.png';
                      break;
                    case 'Pendant':
                      imagePath = 'assets/gold/category_pendant.png';
                      break;
                    case 'Bracelet':
                      imagePath = 'assets/gold/category_bracelet.png';
                      break;
                    case 'Earing':
                      imagePath = 'assets/gold/category_earings.png';
                      break;
                    case 'Necklace':
                      imagePath = 'assets/gold/category_necklace.png';
                      break;
                    case 'Bangles':
                      imagePath = 'assets/gold/category_bangles.png';
                      break;
                    default:
                      imagePath = 'assets/gold/rings.png'; // Default image
                  }

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategoryIndex = index;
                      });
                    },
                    child: Container(
                      color: isSelected
                          ? U_Colors.yaleBlue.withOpacity(0.1)
                          : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Circular image using CircleAvatar
                          CircleAvatar(
                            backgroundColor: Colors.grey.shade300,
                            radius: 25, // Adjust the radius to fit your design
                            backgroundImage: AssetImage(imagePath), // Circular image
                          ),

                          const SizedBox(height: 8), // Space between image and text

                          // Category name text below the image
                          Text(
                            categories[index],
                            style: GoogleFonts.poppins(
                              fontSize: isSelected ? 14 : 12,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected
                                  ? U_Colors.yaleBlue
                                  : Colors.black,
                            ),
                          ),

                          if (isSelected)
                            Container(
                              height: 4,
                              width: 20, // Make the underline shorter
                              margin: const EdgeInsets.only(top: 4),
                              color: U_Colors.yaleBlue, // Underline for selected category
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),



            //test
            // Subcategory Sections
            Expanded(
              flex: 14,
              child: ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: subCategories.length,
                itemBuilder: (context, sectionIndex) {
                  String sectionTitle =
                  subCategories.keys.elementAt(sectionIndex);
                  List<Map<String, String>> items = subCategories[sectionTitle]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            sectionTitle,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: U_Colors.yaleBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 5, bottom: 5),
                        child: DividerWithAvatar(
                            dividerThickness: 0.5,
                            dividerColor: U_Colors.yaleBlue,
                            imagePath: 'assets/logos/KALPCO_splash.png'),
                      ),
                      const SizedBox(height: 20),

                      // Check if items are available
                      items.isEmpty
                          ? Center(
                        child: Text(
                          'New design coming soon!',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      )
                          : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 3 / 4,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          var item = items[index];
                          bool isViewAll = item['productName'] == 'View All';
                          return GestureDetector(
                            onTap: () {
                              if (isViewAll) {
                                // Navigate to a specific screen or perform an action
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const ProductHomeScreen(
                                          category: "custom",
                                          subCategory: "*")),
                                );
                              } else {
                                // Handle other item clicks
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const ProductHomeScreen(
                                          category: "custom",
                                          subCategory: "*")),
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  isViewAll
                                      ? Icon(Icons.view_list, size: 30, color: U_Colors.yaleBlue) // Display an icon for "View All"
                                      : Image.asset(
                                    item['imagePath'] ?? '',
                                    height: 70,
                                    width: 70,
                                    fit: BoxFit.cover,
                                  ),
                                  if (isViewAll)
                                    Text(
                                      'View All',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: U_Colors.yaleBlue,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 25),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
