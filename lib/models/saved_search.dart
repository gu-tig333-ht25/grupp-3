class SavedSearch {
  // Val
  String selectedRegionCode;
  String selectedRegionName;
  String selectedQuarter;

  SavedSearch({
    required this.selectedRegionCode,
    required this.selectedRegionName,
    required this.selectedQuarter,
  });

  factory SavedSearch.fromJson(Map<String, dynamic> json) {
    return SavedSearch(
      selectedRegionCode: json['selectedRegionCode'],
      selectedRegionName: json['selectedRegionName'],
      selectedQuarter: json['selectedQuarter'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selectedRegionCode': selectedRegionCode,
      'selectedRegionName': selectedRegionName,
      'selectedQuarter': selectedQuarter,
    };
  }

  @override
  String toString() {
    return 'SavedSearch(selectedRegionCode: $selectedRegionCode, selectedRegionName: $selectedRegionName, selectedQuarter: $selectedQuarter)';
  }
}
