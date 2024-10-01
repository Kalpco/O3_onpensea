import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DigiGoldBuySellScreen extends StatefulWidget {
  const DigiGoldBuySellScreen({Key? key}) : super(key: key);

  @override
  _DigiGoldBuySellScreenState createState() => _DigiGoldBuySellScreenState();
}

class _DigiGoldBuySellScreenState extends State<DigiGoldBuySellScreen> {
  TextEditingController amountController = TextEditingController(text: '1000');

  double _calculateTextWidth(String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.size.width;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background color
          Container(
            color:
                Color(0xFF6A1B9A), // Adjust the color to match the background
          ),
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Icon(Icons.more_vert, color: Colors.white),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFmHHdwWdudHrnE0l0otJtZ1BNBlI1_KyfACB7XIoMUFE8YT0xDSbhvqD9Mn_MHPAMDmQ&usqp=CAU'),
                  // Replace with your logo URL
                  radius: 40,
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(height: 16),
                Text(
                  'Buying from MMTC-PAMP',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '99.99% pure 24K gold',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 16),
                // Editable TextField for amount
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Calculate the width needed for the text
                        final textWidth =
                            _calculateTextWidth(amountController.text);

                        return SizedBox(
                          width: textWidth + 60,
                          // Add padding for the prefix icon and extra spacing
                          child: TextField(
                            controller: amountController,
                            style: TextStyle(
                              fontSize: 48,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            onChanged: (value) {
                              // Trigger a rebuild when the text changes
                              setState(() {});
                            },
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              // Disable border
                              focusedBorder: InputBorder.none,
                              // Disable border when focused
                              enabledBorder: InputBorder.none,
                              // Disable border when not focused
                              errorBorder: InputBorder.none,
                              // Disable border on error
                              disabledBorder: InputBorder.none,
                              // Disable border
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(right: 4.0),
                                // Adjust spacing here
                                child: Text(
                                  '₹',
                                  style: TextStyle(
                                    fontSize: 48,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              prefixIconConstraints: BoxConstraints(
                                minWidth: 0,
                                minHeight: 0,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '136.6 mg',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Price ₹7.11/mg (excl. GST)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  '₹7.32/mg (with 3% GST)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            right: 24,
            child: FloatingActionButton(
              onPressed: () {
                print('Amount: ${amountController.text}');
              },
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.check, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
