class ShowStaticModel {
  JumboInformation? jumboInformation;
  BatchInformation? batchInformation;
  List<MicBatchInformation>? micBatchInformation;
  CartonStockInformation? cartonStockInformation;
  CoreStockInformation? coreStockInformation;

  ShowStaticModel({
    this.jumboInformation,
    this.batchInformation,
    this.micBatchInformation,
    this.cartonStockInformation,
    this.coreStockInformation,
  });

  ShowStaticModel.fromJson(Map<String, dynamic> json) {
    jumboInformation = json['jumboInformation'] != null
        ? new JumboInformation.fromJson(json['jumboInformation'])
        : null;
    batchInformation = json['batchInformation'] != null
        ? new BatchInformation.fromJson(json['batchInformation'])
        : null;
    if (json['micBatchInformation'] != null) {
      micBatchInformation = <MicBatchInformation>[];
      json['micBatchInformation'].forEach((v) {
        micBatchInformation!.add(new MicBatchInformation.fromJson(v));
      });
    }
    cartonStockInformation = json['cartonStockInformation'] != null
        ? new CartonStockInformation.fromJson(json['cartonStockInformation'])
        : null;
    coreStockInformation = json['coreStockInformation'] != null
        ? new CoreStockInformation.fromJson(json['coreStockInformation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.jumboInformation != null) {
      data['jumboInformation'] = this.jumboInformation!.toJson();
    }
    if (this.batchInformation != null) {
      data['batchInformation'] = this.batchInformation!.toJson();
    }
    if (this.micBatchInformation != null) {
      data['micBatchInformation'] = this.micBatchInformation!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.cartonStockInformation != null) {
      data['cartonStockInformation'] = this.cartonStockInformation!.toJson();
    }
    if (this.coreStockInformation != null) {
      data['coreStockInformation'] = this.coreStockInformation!.toJson();
    }
    return data;
  }
}

class JumboInformation {
  int? totalJumboRoll;
  int? thisMonthJumboRoll;
  int? inStockJumboRoll;

  JumboInformation({
    this.totalJumboRoll,
    this.thisMonthJumboRoll,
    this.inStockJumboRoll,
  });

  JumboInformation.fromJson(Map<String, dynamic> json) {
    totalJumboRoll = json['totalJumboRoll'];
    thisMonthJumboRoll = json['thisMonthJumboRoll'];
    inStockJumboRoll = json['inStockJumboRoll'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalJumboRoll'] = this.totalJumboRoll;
    data['thisMonthJumboRoll'] = this.thisMonthJumboRoll;
    data['inStockJumboRoll'] = this.inStockJumboRoll;
    return data;
  }
}

class BatchInformation {
  int? totalBatch;
  int? thisMonthBatch;
  int? inStockBatch;

  BatchInformation({this.totalBatch, this.thisMonthBatch, this.inStockBatch});

  BatchInformation.fromJson(Map<String, dynamic> json) {
    totalBatch = json['totalBatch'];
    thisMonthBatch = json['thisMonthBatch'];
    inStockBatch = json['inStockBatch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalBatch'] = this.totalBatch;
    data['thisMonthBatch'] = this.thisMonthBatch;
    data['inStockBatch'] = this.inStockBatch;
    return data;
  }
}

class MicBatchInformation {
  int? mic;
  int? batch;
  int? piece;

  MicBatchInformation({this.mic, this.batch, this.piece});

  MicBatchInformation.fromJson(Map<String, dynamic> json) {
    mic = json['mic'];
    batch = json['batch'];
    piece = json['piece'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mic'] = this.mic;
    data['batch'] = this.batch;
    data['piece'] = this.piece;
    return data;
  }
}

class CartonStockInformation {
  int? small;
  int? medium;
  int? large;

  CartonStockInformation({this.small, this.medium, this.large});

  CartonStockInformation.fromJson(Map<String, dynamic> json) {
    small = json['small'];
    medium = json['medium'];
    large = json['large'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['small'] = this.small;
    data['medium'] = this.medium;
    data['large'] = this.large;
    return data;
  }
}

class CoreStockInformation {
  int? regular;
  int? heavy;
  int? extraHeavy;

  CoreStockInformation({this.regular, this.heavy, this.extraHeavy});

  CoreStockInformation.fromJson(Map<String, dynamic> json) {
    regular = json['regular'];
    heavy = json['heavy'];
    extraHeavy = json['extraHeavy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['regular'] = this.regular;
    data['heavy'] = this.heavy;
    data['extraHeavy'] = this.extraHeavy;
    return data;
  }
}
