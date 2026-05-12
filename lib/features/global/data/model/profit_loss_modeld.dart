class ProfitAndLossModel {
  int? status;
  OverallProgress? overallProgress;
  ExpensesList? expensesList;
  RevenueList? revenueList;
  String? message;

  ProfitAndLossModel({
    this.status,
    this.overallProgress,
    this.expensesList,
    this.revenueList,
    this.message,
  });

  ProfitAndLossModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    overallProgress = json['overallProgress'] != null
        ? new OverallProgress.fromJson(json['overallProgress'])
        : null;
    expensesList = json['expensesList'] != null
        ? new ExpensesList.fromJson(json['expensesList'])
        : null;
    revenueList = json['revenueList'] != null
        ? new RevenueList.fromJson(json['revenueList'])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.overallProgress != null) {
      data['overallProgress'] = this.overallProgress!.toJson();
    }
    if (this.expensesList != null) {
      data['expensesList'] = this.expensesList!.toJson();
    }
    if (this.revenueList != null) {
      data['revenueList'] = this.revenueList!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class OverallProgress {
  String? overallHeading;
  String? overallTagline;
  String? absoluteRevenue;
  String? revenuePercentage;
  String? absoluteExpenses;
  String? expensesPercentage;
  String? absoluteNetProfit;
  String? netProfitPercentage;
  String? absoluteProfitMargin;
  String? profitMarginPercentage;

  OverallProgress({
    this.overallHeading,
    this.overallTagline,
    this.absoluteRevenue,
    this.revenuePercentage,
    this.absoluteExpenses,
    this.expensesPercentage,
    this.absoluteNetProfit,
    this.netProfitPercentage,
    this.absoluteProfitMargin,
    this.profitMarginPercentage,
  });

  OverallProgress.fromJson(Map<String, dynamic> json) {
    overallHeading = json['overallHeading'];
    overallTagline = json['overallTagline'];
    absoluteRevenue = json['absoluteRevenue'];
    revenuePercentage = json['revenuePercentage'];
    absoluteExpenses = json['absoluteExpenses'];
    expensesPercentage = json['expensesPercentage'];
    absoluteNetProfit = json['absoluteNetProfit'];
    netProfitPercentage = json['netProfitPercentage'];
    absoluteProfitMargin = json['absoluteProfitMargin'];
    profitMarginPercentage = json['profitMarginPercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['overallHeading'] = this.overallHeading;
    data['overallTagline'] = this.overallTagline;
    data['absoluteRevenue'] = this.absoluteRevenue;
    data['revenuePercentage'] = this.revenuePercentage;
    data['absoluteExpenses'] = this.absoluteExpenses;
    data['expensesPercentage'] = this.expensesPercentage;
    data['absoluteNetProfit'] = this.absoluteNetProfit;
    data['netProfitPercentage'] = this.netProfitPercentage;
    data['absoluteProfitMargin'] = this.absoluteProfitMargin;
    data['profitMarginPercentage'] = this.profitMarginPercentage;
    return data;
  }
}

class ExpensesList {
  String? expensesHeading;
  List<ExpensesResult>? expensesResult;

  ExpensesList({this.expensesHeading, this.expensesResult});

  ExpensesList.fromJson(Map<String, dynamic> json) {
    expensesHeading = json['expensesHeading'];
    if (json['expensesResult'] != null) {
      expensesResult = <ExpensesResult>[];
      json['expensesResult'].forEach((v) {
        expensesResult!.add(new ExpensesResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expensesHeading'] = this.expensesHeading;
    if (this.expensesResult != null) {
      data['expensesResult'] = this.expensesResult!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class ExpensesResult {
  String? expensesLabel;
  String? expensesValue;
  String? expensesPercentage;
  String? expensesColorCode;

  ExpensesResult({
    this.expensesLabel,
    this.expensesValue,
    this.expensesPercentage,
    this.expensesColorCode,
  });

  ExpensesResult.fromJson(Map<String, dynamic> json) {
    expensesLabel = json['expensesLabel'];
    expensesValue = json['expensesValue'];
    expensesPercentage = json['expensesPercentage'];
    expensesColorCode = json['expensesColorCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expensesLabel'] = this.expensesLabel;
    data['expensesValue'] = this.expensesValue;
    data['expensesPercentage'] = this.expensesPercentage;
    data['expensesColorCode'] = this.expensesColorCode;
    return data;
  }
}

class RevenueList {
  String? revenueHeading;
  List<RevenueResult>? revenueResult;

  RevenueList({this.revenueHeading, this.revenueResult});

  RevenueList.fromJson(Map<String, dynamic> json) {
    revenueHeading = json['revenueHeading'];
    if (json['revenueResult'] != null) {
      revenueResult = <RevenueResult>[];
      json['revenueResult'].forEach((v) {
        revenueResult!.add(new RevenueResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['revenueHeading'] = this.revenueHeading;
    if (this.revenueResult != null) {
      data['revenueResult'] = this.revenueResult!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class RevenueResult {
  String? revenueLabel;
  String? revenueValue;
  String? revenuePercentage;
  String? revenueColorCode;

  RevenueResult({
    this.revenueLabel,
    this.revenueValue,
    this.revenuePercentage,
    this.revenueColorCode,
  });

  RevenueResult.fromJson(Map<String, dynamic> json) {
    revenueLabel = json['revenueLabel'];
    revenueValue = json['revenueValue'];
    revenuePercentage = json['revenuePercentage'];
    revenueColorCode = json['revenueColorCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['revenueLabel'] = this.revenueLabel;
    data['revenueValue'] = this.revenueValue;
    data['revenuePercentage'] = this.revenuePercentage;
    data['revenueColorCode'] = this.revenueColorCode;
    return data;
  }
}
