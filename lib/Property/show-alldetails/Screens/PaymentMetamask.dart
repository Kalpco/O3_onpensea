import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:onpensea/AdityaProperties/aditya_properties.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/Property/show-alldetails/Models/buyermodel.dart';
import '../../../UserManagement/Feature-Dashboard/Widgets/Drawer/DashboardDrawer.dart';
import '../../../config/CustomTheme.dart';
import '../../../config/wallet_connect.dart';
import '../Widgets/Countdown.dart';
import '../Widgets/page_wrapper.dart';
import '../../../widgets/CustomButton.dart';
import 'BoughtProperties.dart';
import 'package:flutter/material.dart';

class PaymentMetamask extends StatefulWidget {
  final Buyer prop;
  final String name;
  final String remarks;
  final String userId;
  final String username;
  final String screenstatus;
  final String tokenPrice;

  const PaymentMetamask(
      {super.key,
      required this.prop,
      required this.name,
      required this.remarks,
      required this.username,
      required this.userId,
      required this.screenstatus,
      required this.tokenPrice});

  @override
  _PaymentMetamaskState createState() => _PaymentMetamaskState();
}

class _PaymentMetamaskState extends State<PaymentMetamask> {
  String? username;
  String? photo;
  String? mobile;
  String? email;
  String? userType;
  String? walletAddress;
  late W3MService _w3mService;
  late var value;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    getUsername();
    initializeState();
  }

  var CONTRACT_ABI = AdityaProperties.ABI_CONTRACT;
  var CONTRACT_ADDRESS = AdityaProperties.contractAddress;
  static const fromAddress = AdityaProperties.fromAddress;
  static const toAddress = AdityaProperties.toAddress;
  static const projectId = WalletConnect.projectId;

  static const _chainId = "11155111";

  final _sepoliaChain = W3MChainInfo(
      chainName: "Sepolia",
      chainId: _chainId,
      namespace: "eip155:$_chainId",
      tokenName: "ETH",
      rpcUrl: "https://rpc.sepolia.org/",
      blockExplorer: W3MBlockExplorer(
          name: 'Sepolia Explorer', url: 'https://sepolia.etherscan.io'));

  void initializeState() async {
    W3MChainPresets.chains.putIfAbsent(_chainId, () => _sepoliaChain);
    _w3mService = W3MService(
      projectId: projectId,
      metadata: const PairingMetadata(
        name: 'O3',
        description: 'Real Estate Tokenization',
        url: 'https://www.walletconnect.com/',
        icons: ['https://walletconnect.com/walletconnect-logo.png'],
        redirect: Redirect(
          native: 'w3m://', // your own custom scheme
          universal: 'https://www.walletconnect.com',
        ),
      ),
    );
    await _w3mService.init();
  }

  void _onPersonalSign() async {
    print("aditya");
    print(_w3mService.session!.getAccounts());

    await _w3mService.launchConnectedWallet();
    var hash = await _w3mService.web3App?.request(
      topic: _w3mService.session!.topic ?? "default_topic",
      chainId: 'eip155:11155111',
      request: const SessionRequestParams(
        method: 'personal_sign',
        params: ['GM from W3M flutter!!', fromAddress],
      ),
    );
  }

  String? getUserWalletAddress() {
    if (_w3mService.isConnected && _w3mService.session != null) {
      var address = _w3mService.session?.address;
      print("My wallet address is : ${address!}");
      return address;
    }
  }

  //read data from smart contract
  Future<void> erc20BalanceOf() async {
    // Create DeployedContract object using contract's ABI and address
    final deployedContract = DeployedContract(
      ContractAbi.fromJson(
        jsonEncode(CONTRACT_ABI), // ABI object
        'ADITYA PROPERTIES',
      ),
      EthereumAddress.fromHex(CONTRACT_ADDRESS),
    );

    // Get balance of wallet
    return await _w3mService.requestReadContract(
      deployedContract: deployedContract,
      functionName: 'balanceOf',
      rpcUrl: 'https://rpc.sepolia.org/',
      parameters: [
        EthereumAddress.fromHex(getUserWalletAddress()!),
      ],
    );
  }

  //read data from smart contract
  Future<void> erc20TotalSupply() async {
    // Create DeployedContract object using contract's ABI and address
    final deployedContract = DeployedContract(
      ContractAbi.fromJson(
        jsonEncode(CONTRACT_ABI), // ABI object
        'ADITYA PROPERTIES',
      ),
      EthereumAddress.fromHex(CONTRACT_ADDRESS),
    );

    // Get token total supply
    return await _w3mService.requestReadContract(
      deployedContract: deployedContract,
      functionName: 'totalSupply',
      rpcUrl: 'https://rpc.sepolia.org/',
    );
  }

  //TRANSFER OR WRITE TO SMART CONTRACT
  Future<dynamic> transferTokens() async {
    // Create DeployedContract object using contract's ABI and address
    final deployedContract = DeployedContract(
      ContractAbi.fromJson(
        jsonEncode(CONTRACT_ABI), // ABI object
        'ADITYA PROPERTIES',
      ),
      EthereumAddress.fromHex(CONTRACT_ADDRESS),
    );

    final response = await _w3mService.requestWriteContract(
      topic: _w3mService.session!.topic ?? "DEFAULT_TOPIC",
      chainId: 'eip155:$_chainId',
      rpcUrl: 'https://rpc.sepolia.org/',
      deployedContract: deployedContract,
      functionName: 'transfer',
      // parameters: [
      //   EthereumAddress.fromHex("0xf06fa50e011d05B16a13092717AeD28b35cC2282"),
      //   BigInt.from(10)
      // ],

      transaction: Transaction(
        from: EthereumAddress.fromHex(getUserWalletAddress()!),
        to: EthereumAddress.fromHex(toAddress),
        value: EtherAmount.fromInt(EtherUnit.finney, 1000),
        // == 0.010
      ),
    );

    print(response.toString());

    // Transfer 0.01 amount of Token using Smart Contract's transfer function
    return response;
  }

  void disconnect() {
    _w3mService.disconnect();
  }

  @override
  void dispose() {
    super.dispose();
    _scaffoldKey.currentState?.dispose();
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  Future<void> getUsername() async {
    final prefs = await SharedPreferences.getInstance();

    print("getrer: ${widget.tokenPrice}");

    setState(() {
      username = prefs.getString('username');
      photo = prefs.getString("photo");
      mobile = prefs.getString("mobile");
      email = prefs.getString("email");
      userType = prefs.getString("userType");
      walletAddress = prefs.getString("walletAddress");
    });
  }

  void doNothing(String value) {
    print("donothing: $value");
    if (!value.isEmpty) {
      EasyLoading.showSuccess("Token Transfer Successfull");
      Future.delayed(const Duration(seconds: 3), () {
        print(value);
        EasyLoading.showSuccess("Token Transfer Successfull");
      });
      Future.delayed(const Duration(seconds: 5), () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const BoughtProperties(
                      screenStatus: '',
                    )));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return MaterialApp(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          height: 50,
          margin: const EdgeInsets.all(10),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      child: CustomButton(
                        text: "Back",
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 8.0),
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          _onPersonalSign();
                          transferTokens().then((value) => doNothing(value));
                          // _onPersonalSign();

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>Countdown(
                          //           tokenPrice: widget.tokenPrice,
                          //           prop: widget.prop,
                          //           name: widget.name,
                          //           remarks: widget.remarks,
                          //           username: widget.username,
                          //           userId: widget.userId,
                          //           screenstatus: widget.screenstatus,
                          //         )));
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          backgroundColor: Colors.purple.shade900,
                          textStyle: GoogleFonts.inter(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: Text(
                          "Send",
                          style: GoogleFonts.inter(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        key: _scaffoldKey,
        drawer: DashboardDrawer(
            walletAddress: walletAddress,
            userType: userType,
            username: username,
            email: email,
            mobile: mobile,
            photo: photo),
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: CustomTheme.customLinearGradient,
            ),
          ),
          title: Text(
            username == "NA" ? "Welcome Dummy" : "Welcome ${username}",
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.displayLarge,
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: _openDrawer,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: photo == null
                    ? const Icon(
                        Icons.person,
                        color: Colors.green,
                      )
                    : Container(
                        padding: const EdgeInsets.all(0), // Border width
                        decoration: const BoxDecoration(
                            color: Colors.transparent, shape: BoxShape.circle),
                        child: ClipOval(
                          child: SizedBox.fromSize(
                              size: const Size.fromRadius(48), // Image radius
                              child: photo == "NA"
                                  ? const CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(
                                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"),
                                    )
                                  : CircleAvatar(
                                      radius: 40,
                                      backgroundImage:
                                          MemoryImage(base64Decode(photo!)),
                                    )),
                        ),
                      ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: PageWrapper(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  const CircleAvatar(
                    radius: 50.0,
                    backgroundImage:
                        AssetImage('assets/images/Bitcoin.svg.png'),
                  ),
                  SizedBox(height: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Token Name: ${widget.prop.tokenName}',
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineMedium,
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Token QTY: ${widget.name}',
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineMedium,
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Self Address:',
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineMedium,
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 250,
                            child: Text(
                              ' $walletAddress.',
                              style: GoogleFonts.poppins(
                                textStyle:
                                    Theme.of(context).textTheme.headlineMedium,
                                fontSize: 14,
                                color: Colors.black38,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          IconButton(
                              onPressed: () async {
                                await Clipboard.setData(
                                    ClipboardData(text: walletAddress!));

                                if (!mounted) return;
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Copied to clipboard'),
                                ));
                              },
                              icon: const Icon(Icons.copy))
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Private Address:',
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineMedium,
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 250,
                            child: Text(
                              ' 0xdDF752ADd34F358C30128dC7afDE0381898640f2',
                              style: GoogleFonts.poppins(
                                textStyle:
                                    Theme.of(context).textTheme.headlineMedium,
                                fontSize: 14,
                                color: Colors.black38,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          IconButton(
                              onPressed: () async {
                                await Clipboard.setData(
                                    ClipboardData(text: walletAddress!));

                                if (!mounted) return;
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Copied to clipboard'),
                                ));
                              },
                              icon: const Icon(Icons.copy))
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: 280,
                        child: Text(
                          "Connect Metamask First",
                          style: GoogleFonts.poppins(
                            textStyle:
                                Theme.of(context).textTheme.headlineMedium,
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      W3MConnectWalletButton(service: _w3mService),
                      W3MNetworkSelectButton(service: _w3mService),
                      W3MAccountButton(service: _w3mService),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
