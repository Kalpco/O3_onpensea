import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onpensea/features/product/screen/productHomeAppBar/common_top_bar.dart';
import 'package:onpensea/features/scheme/models/investment_response_model.dart';
import 'package:onpensea/features/scheme/service/investment_service.dart';
import 'package:onpensea/features/scheme/Models/transaction_request_dto.dart';
import 'package:shimmer/shimmer.dart';
import '../Models/ResponseDTO.dart';
import '../Widgets/Skeleton.dart';
import '../Widgets/SchemeGridView.dart';
import '../service/scheme_service.dart';

enum AppbarActionType { leading, trailing }

class AllSchemeScreen extends StatefulWidget {
  const AllSchemeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AllSchemeScreenState();
  }
}

class _AllSchemeScreenState extends State<AllSchemeScreen> {

  List<Scheme>? allSchemes;
  ResponseDTO? responseDTO;
  TransactionResponseDTO? transactionResponseDTO;
  int? transactionId;
  bool isLoaded = false;

  InvestmentResponseModel? investmentResponseModel;
  List<Investments>? allInvestments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // loadSchemes();
    loadAllInvestments();
  }

  Future<void> loadAllInvestments() async {
    final investmentService = InvestmentService();
    investmentResponseModel = await investmentService.getAllInvestments();
    setState(() {
      isLoaded = true;
      allInvestments = investmentResponseModel!.payload;
    });
  }

  Future<void> loadSchemes() async {
    final schemeService = SchemeService();
    responseDTO = await schemeService.getAllSchemes();
    setState(() {
      isLoaded = true;
      allSchemes = responseDTO?.schemeList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonTopAppBar(
      // extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                if (!isLoaded)
                  Shimmer.fromColors(
                    enabled: true,
                    baseColor: Colors.black87,
                    highlightColor: Colors.black12,
                    child: const Column(
                      children: [
                        SkeletonCards(),
                        SizedBox(height: 20),
                        SkeletonCards(),
                        SizedBox(height: 20),
                        SkeletonCards(),
                        SizedBox(height: 20),
                        SkeletonCards(),
                        SizedBox(height: 20),
                      ],
                    ),
                  )
                else if (allInvestments == null || allInvestments!.isEmpty)
                  const Center(
                    child: Text(
                      "No data available",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  )
                else
                  SchemeGridView(
                    allInvestments: allInvestments!,
                  ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
