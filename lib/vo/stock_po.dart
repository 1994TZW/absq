class StockPO {
  String? id;
  String? poNumber;
  DateTime? date;
  String? stockId;
  String? stockName;
  double stockPrice;
  double emptyDepositPrice;
  int qty;
  String? status;
  double outstandingAmount;

  List<Payment> payments = [];

  double get emptyDepositAmount {
    double v = (emptyDepositPrice * qty);
    return v;
  }

  double get totalAmount {
    double stockAmount = (stockPrice * qty);
    double emptyDepositAmount = (emptyDepositPrice * qty);
    double v = stockAmount + emptyDepositAmount;
    return v;
  }

  StockPO(
      {this.id,
      this.poNumber,
      this.date,
      this.stockId,
      this.stockName,
      this.stockPrice = 0,
      this.emptyDepositPrice = 0,
      this.qty = 0,
      this.status,
      this.outstandingAmount = 0,
      this.payments = const []});
}

class Payment {
  DateTime? date;
  double? amount;
  Payment({this.date, this.amount});
}
