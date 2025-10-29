class SavedSearch {
  // Val
  String selectedRegionCode;
  String selectedRegionName;

  SavedSearch({
    required this.selectedRegionCode,
    required this.selectedRegionName,
  });

  factory SavedSearch.fromJson(Map<String, dynamic> json) {
    return SavedSearch(
      selectedRegionCode: json['selectedRegionCode'],
      selectedRegionName: json['selectedRegionName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selectedRegionCode': selectedRegionCode,
      'selectedRegionName': selectedRegionName,
    };
  }

  @override
  String toString() {
    return 'SavedSearch(selectedRegionCode: $selectedRegionCode, selectedRegionName: $selectedRegionName)';
  }
}
