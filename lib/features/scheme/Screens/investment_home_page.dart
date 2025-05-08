import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:get/get.dart";
import "package:get/get_core/src/get_main.dart";
import "package:google_fonts/google_fonts.dart";
import "package:onpensea/features/authentication/screens/login/login.dart";
import "package:onpensea/features/authentication/screens/signUp/signup.dart";
import "package:onpensea/features/scheme/Screens/widgets/custom_appbar.dart";
import "package:onpensea/features/scheme/Screens/widgets/faqs_widget.dart";
import "package:onpensea/features/scheme/Screens/widgets/feature_widget.dart";
import "package:onpensea/features/scheme/Screens/widgets/footer_image_widget.dart";
import "package:onpensea/features/scheme/Screens/widgets/get_in_touch.dart";
import "package:onpensea/features/scheme/Screens/widgets/image_banner_widget.dart";
import "package:onpensea/features/scheme/Screens/widgets/scheme_calculator.dart";
import "package:onpensea/features/scheme/Screens/widgets/scheme_explanation_widget.dart";
import "package:onpensea/features/scheme/Screens/widgets/terms_and_condition.dart";
import "package:onpensea/features/scheme/screens/widgets/about_widget.dart";
import "package:video_player/video_player.dart";

import "../../../utils/constants/colors.dart";
import "../../Portfolio/description.dart";
import "../../authentication/screens/login/Controller/LoginController.dart";
import "../../authentication/screens/signUp/signupWidgets/FlipSignUp.dart";
import "../models/investment_response_model.dart";
import "ProductOrderFailSummaryPage.dart";
import "ProductOrderSuccessSummaryPage.dart";
import "bottom_sheet_modal.dart";

class InvestmentHomePage extends StatefulWidget {
  const InvestmentHomePage({super.key, required this.singleInvestment});

  final Datum singleInvestment;

  @override
  State<InvestmentHomePage> createState() => _InvestmentHomePageState();
}

class _InvestmentHomePageState extends State<InvestmentHomePage>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late TabController _tabController;
  late PageController _pageController;
  late ScrollController _scrollController;
  bool _showButton = true;

  bool toggleIcon = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final loginController = Get.find<LoginController>();

  toggleIconState(bool value) {
    setState(() {
      toggleIcon = value;
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.singleInvestment.investmentAboutVideoLink))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 50 && !_showButton) {
        setState(() {
          _showButton = true;
        });
      } else if (_scrollController.position.pixels <= 50 && _showButton) {
        setState(() {
          _showButton = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    _pageController.dispose();
    _scrollController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  void _openModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => BottomSheetModal(
          toggleIcon: toggleIcon,
          valueChanged: toggleIconState,
          investment: widget.singleInvestment),
    );
  }

  List<IconData> icons = [
    Icons.account_circle,
    Icons.ac_unit,
    Icons.access_alarm_rounded,
    Icons.accessibility_sharp
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _formKey,
      bottomNavigationBar: Visibility(
        visible: _showButton,
        child: BottomAppBar(
          height: 70,
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: U_Colors.chatprimaryColor,
                    side: const BorderSide(width: 0, color: Colors.white),
                  ),
                  onPressed: () {
                    if (loginController.userData["userId"] == 0) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(
                            "Alert",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          content: Text(
                            "Please Register to purchase",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  FlipSignupScreen()),
                                );
                              },
                              child: Container(
                                color: const Color(0xffB80000),
                                padding: const EdgeInsets.all(14),
                                child: Text(
                                  "Go to Register",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop(); // Close the dialog
                              },
                              child: Container(
                                color: Colors.grey.shade300,
                                padding: const EdgeInsets.all(14),
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );

                    } else {
                      if (widget.singleInvestment.investmentType == "schemes") {
                        _openModal();
                      } else {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(
                              "Contact us",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            content: Text(
                              "9987734001",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Container(
                                  color: const Color(0xffB80000),
                                  padding: const EdgeInsets.all(14),
                                  child: Text(
                                    "okay",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                  child: Text(
                    (widget.singleInvestment.investmentType == "schemes".toLowerCase())
                        ? "Purchase Scheme"
                        : "Contact us",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Scheme Details ",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: U_Colors.yaleBlue,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ImageBannerWidget(
                        image: widget.singleInvestment.investmentImage01,
                      ),
                      const SizedBox(height: 20),
                      SummaryPage(
                          logo: widget.singleInvestment.investmentCompanyImage,
                          headline:
                              widget.singleInvestment.investmentHeadlineSummary,
                          investmentName:
                              widget.singleInvestment.investmentName,
                          returns: widget.singleInvestment.investmentReturns,
                          maturity: widget.singleInvestment.investmentMaturity),
                      const SizedBox(height: 40),
                      widget.singleInvestment.investmentType == "property"
                          ? const SizedBox(
                              height: 0.00125,
                            )
                          : SchemeExplanationWidget(
                              examples:
                                  widget.singleInvestment.investmentExample,
                              instructions:
                                  widget.singleInvestment.investmentInstruction,
                            ),
                      const SizedBox(height: 30),
                      widget.singleInvestment.investmentType == "property"
                          ? SizedBox(height: 0.00125)
                          : SchemeCalculator(),
                      const SizedBox(height: 30),
                      widget.singleInvestment.investmentType == "property"
                          ? SizedBox(
                              height: 0.00125,
                            )
                          : GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 4,
                              children: widget
                                  .singleInvestment.investmentBenefits
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                int index = entry.key;
                                return FeatureCard(
                                  icon: icons[index],
                                  text: entry.value,
                                );
                              }).toList(),
                            ),
                      const SizedBox(height: 40),
                      const Divider(height: 20, color: Color(0xffEEEEEE)),
                      const SizedBox(height: 20),
                      const GetInTouch(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                widget.singleInvestment.investmentType == "property"
                    ? SizedBox(height: 0.00125)
                    : const FooterImageWidget(),
              ],
            )),
      ),
    );
  }
}
