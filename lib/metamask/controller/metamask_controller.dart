import 'dart:convert';
import 'dart:math';

import 'package:web3modal_flutter/web3modal_flutter.dart';

class MetamaskController {

  static var  CONTRACT_ABI = [
    {
      "inputs": [
        {"internalType": "address", "name": "spender", "type": "address"},
        {"internalType": "uint256", "name": "allowance", "type": "uint256"},
        {"internalType": "uint256", "name": "needed", "type": "uint256"}
      ],
      "name": "ERC20InsufficientAllowance",
      "type": "error"
    },
    {
      "inputs": [
        {"internalType": "address", "name": "sender", "type": "address"},
        {"internalType": "uint256", "name": "balance", "type": "uint256"},
        {"internalType": "uint256", "name": "needed", "type": "uint256"}
      ],
      "name": "ERC20InsufficientBalance",
      "type": "error"
    },
    {
      "inputs": [
        {"internalType": "address", "name": "approver", "type": "address"}
      ],
      "name": "ERC20InvalidApprover",
      "type": "error"
    },
    {
      "inputs": [
        {"internalType": "address", "name": "receiver", "type": "address"}
      ],
      "name": "ERC20InvalidReceiver",
      "type": "error"
    },
    {
      "inputs": [
        {"internalType": "address", "name": "sender", "type": "address"}
      ],
      "name": "ERC20InvalidSender",
      "type": "error"
    },
    {
      "inputs": [
        {"internalType": "address", "name": "spender", "type": "address"}
      ],
      "name": "ERC20InvalidSpender",
      "type": "error"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "owner",
          "type": "address"
        },
        {
          "indexed": true,
          "internalType": "address",
          "name": "spender",
          "type": "address"
        },
        {
          "indexed": false,
          "internalType": "uint256",
          "name": "value",
          "type": "uint256"
        }
      ],
      "name": "Approval",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "from",
          "type": "address"
        },
        {
          "indexed": true,
          "internalType": "address",
          "name": "to",
          "type": "address"
        },
        {
          "indexed": false,
          "internalType": "uint256",
          "name": "value",
          "type": "uint256"
        }
      ],
      "name": "Transfer",
      "type": "event"
    },
    {
      "inputs": [
        {"internalType": "address", "name": "spender", "type": "address"},
        {"internalType": "uint256", "name": "value", "type": "uint256"}
      ],
      "name": "approve",
      "outputs": [
        {"internalType": "bool", "name": "", "type": "bool"}
      ],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {"internalType": "address", "name": "to", "type": "address"},
        {"internalType": "uint256", "name": "value", "type": "uint256"}
      ],
      "name": "transfer",
      "outputs": [
        {"internalType": "bool", "name": "", "type": "bool"}
      ],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {"internalType": "address", "name": "from", "type": "address"},
        {"internalType": "address", "name": "to", "type": "address"},
        {"internalType": "uint256", "name": "value", "type": "uint256"}
      ],
      "name": "transferFrom",
      "outputs": [
        {"internalType": "bool", "name": "", "type": "bool"}
      ],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {"inputs": [], "stateMutability": "nonpayable", "type": "constructor"},
    {
      "inputs": [
        {"internalType": "address", "name": "owner", "type": "address"},
        {"internalType": "address", "name": "spender", "type": "address"}
      ],
      "name": "allowance",
      "outputs": [
        {"internalType": "uint256", "name": "", "type": "uint256"}
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {"internalType": "address", "name": "account", "type": "address"}
      ],
      "name": "balanceOf",
      "outputs": [
        {"internalType": "uint256", "name": "", "type": "uint256"}
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "decimals",
      "outputs": [
        {"internalType": "uint8", "name": "", "type": "uint8"}
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "name",
      "outputs": [
        {"internalType": "string", "name": "", "type": "string"}
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "symbol",
      "outputs": [
        {"internalType": "string", "name": "", "type": "string"}
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "totalSupply",
      "outputs": [
        {"internalType": "uint256", "name": "", "type": "uint256"}
      ],
      "stateMutability": "view",
      "type": "function"
    }
  ];
  static var  CONTRACT_ADDRESS = "0x3019ce05d5c17dec9293ee17ecc8719c95342984";

  static late W3MService _w3mService;

  static const _chainId = "11155111";

  static final _sepoliaChain = W3MChainInfo(
      chainName: "Sepolia",
      chainId: _chainId,
      namespace: "eip155:$_chainId",
      tokenName: "ETH",
      rpcUrl: "https://rpc.sepolia.org/",
      blockExplorer: W3MBlockExplorer(
          name: 'Sepolia Explorer', url: 'https://sepolia.etherscan.io'));

  static void  _onPersonalSign() async {
    print("aditya");
    print(_w3mService.session!.getAccounts());

    await _w3mService.launchConnectedWallet();
    var hash = await _w3mService.web3App?.request(
      topic: _w3mService.session!.topic ?? "default_topic",
      chainId: 'eip155:11155111',
      request: const SessionRequestParams(
        method: 'personal_sign',
        params: [
          'GM from W3M flutter!!',
          '0xCD48B39cDDBE044944471C45B960C1Fa02712d71'
        ],
      ),
    );
  }

  static String? getUserWalletAddress() {
    if (_w3mService.isConnected && _w3mService.session != null) {
      var address = _w3mService.session?.address;
      print("My wallet address is : ${address!}");
      return address;
    }
  }

  void initializeState() async {
    W3MChainPresets.chains.putIfAbsent(_chainId, () => _sepoliaChain);
    _w3mService = W3MService(
      projectId: 'fcf9f457c1c6ef3dba61870b3fb3cb4b',
      metadata: const PairingMetadata(
        name: 'Web3Modal Flutter Example',
        description: 'Web3Modal Flutter Example',
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
        from: EthereumAddress.fromHex(
            '0xCD48B39cDDBE044944471C45B960C1Fa02712d71'),
        to: EthereumAddress.fromHex(
            '0xf06fa50e011d05B16a13092717AeD28b35cC2282'),
        value: EtherAmount.fromInt(EtherUnit.finney, 1000),
        // == 0.010
      ),
    );

    print(response.toString());

    // Transfer 0.01 amount of Token using Smart Contract's transfer function
    return response;
  }

  Future<bool> getMCTApproval() async {
    // Create DeployedContract object using contract's ABI and address
    final deployedContract = DeployedContract(
      ContractAbi.fromJson(
        jsonEncode(CONTRACT_ABI), // ABI object
        'ADITYA PROPERTIES',
      ),
      EthereumAddress.fromHex(CONTRACT_ADDRESS),
    );

    Transaction transaction = Transaction.callContract(
        contract: deployedContract,
        parameters: [
          EthereumAddress.fromHex("0xf06fa50e011d05B16a13092717AeD28b35cC2282"),
          BigInt.from((14) * pow(10, 18))
        ],
        function: deployedContract.function("transfer"));

    return true;
  }

  void disconnect() {
    _w3mService.disconnect();
  }
}
