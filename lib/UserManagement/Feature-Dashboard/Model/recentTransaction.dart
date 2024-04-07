class recentTransaction {
  final String propName;
  final String type;
  final String status;


  recentTransaction(
      {required this.propName,
        required this.type,
        required this.status,
      });

  factory recentTransaction.fromJson(Map<String, dynamic> json) {
    return recentTransaction(
      propName: json['propName'] ?? 'NA',
      type: json['type'] ?? 'NA',
      status: json['status'] ?? 'NA',

    );
  }
}
