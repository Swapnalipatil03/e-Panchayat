class Fundingmodel {
  String? scheme;
  String? expected;
  String? component;
  String? reverted;
  String? expenditure;
  String? received;
  String? remaining;

  Fundingmodel({
    required this.scheme,
    this.expected,
    this.component,
    this.reverted,
    this.expenditure,
    this.received,
    this.remaining,
  });
}

List<Fundingmodel> fundingScheme = [];
List<Fundingmodel> govtIndiaSchemes = [];
List<Fundingmodel> stateGovtSchemes = [];
List<Fundingmodel> otherSchemes = [];
