// lib/funding_data.dart

// Data for Govt. of India
final List<Map<String, String>> govtOfIndiaData = [
  {
    "scheme": "Swachh Bharat Mission [34]",
    "component": "Center Schemes/ Grants",
    "expected": "₹ 0",
    "received": "₹ 0",
    "reverted": "₹ 0",
    "expenditure": "₹ 32,000"
  },
  {
    "scheme": "Swachh Bharat Mission [34]",
    "component": "Center Schemes/ Grants",
    "expected": "₹ 0",
    "received": "₹ 6,318",
    "reverted": "₹ 0",
    "expenditure": "₹ 0"
  },
  {
    "scheme": "XV Finance Commission [1769]",
    "component": "Center Schemes/ Grants",
    "expected": "₹ 16,44,104",
    "received": "₹ 11,70,070",
    "reverted": "₹ 7,02,042",
    "expenditure": "₹ 11,24,140"
  },
  {
    "scheme": "XV Finance Commission [1769]",
    "component": "Center Schemes/ Grants",
    "expected": "₹ 16,44,104",
    "received": "₹ 11,70,070",
    "reverted": "₹ 7,02,042",
    "expenditure": "₹ 11,24,140"
  },
  {
    "scheme": "XV Finance Commission [1769]",
    "component": "Center Schemes/ Grants",
    "expected": "₹ 16,44,104",
    "received": "₹ 11,70,070",
    "reverted": "₹ 7,02,042",
    "expenditure": "₹ 11,24,140"
  }
  // Add more data items as needed
];

// Data for State Govt.
final List<Map<String, String>> stateGovtData = [
  {
    "scheme": "State Scheme X",
    "component": "State Schemes/ Grants",
    "expected": "₹ 10,000",
    "received": "₹ 5,000",
    "reverted": "₹ 1,000",
    "expenditure": "₹ 4,000"
  },
  {
    "scheme": "Swachh Bharat Mission [34]",
    "component": "Center Schemes/ Grants",
    "expected": "₹ 0",
    "received": "₹ 6,318",
    "reverted": "₹ 0",
    "expenditure": "₹ 0"
  },
  {
    "scheme": "XV Finance Commission [1769]",
    "component": "Center Schemes/ Grants",
    "expected": "₹ 16,44,104",
    "received": "₹ 11,70,070",
    "reverted": "₹ 7,02,042",
    "expenditure": "₹ 11,24,140"
  },
  {
    "scheme": "XV Finance Commission [1769]",
    "component": "Center Schemes/ Grants",
    "expected": "₹ 16,44,104",
    "received": "₹ 11,70,070",
    "reverted": "₹ 7,02,042",
    "expenditure": "₹ 11,24,140"
  },
  {
    "scheme": "XV Finance Commission [1769]",
    "component": "Center Schemes/ Grants",
    "expected": "₹ 16,44,104",
    "received": "₹ 11,70,070",
    "reverted": "₹ 7,02,042",
    "expenditure": "₹ 11,24,140"
  }
  // Add more data items as needed
];

// Data for Other
final List<Map<String, String>> otherData = [
  {
    "scheme": "Other Scheme Y",
    "component": "Other Schemes/ Grants",
    "expected": "₹ 20,000",
    "received": "₹ 15,000",
    "reverted": "₹ 2,000",
    "expenditure": "₹ 13,000"
  },
  {
    "scheme": "Swachh Bharat Mission [34]",
    "component": "Center Schemes/ Grants",
    "expected": "₹ 0",
    "received": "₹ 6,318",
    "reverted": "₹ 0",
    "expenditure": "₹ 0"
  },
  {
    "scheme": "XV Finance Commission [1769]",
    "component": "Center Schemes/ Grants",
    "expected": "₹ 16,44,104",
    "received": "₹ 11,70,070",
    "reverted": "₹ 7,02,042",
    "expenditure": "₹ 11,24,140"
  },
  {
    "scheme": "XV Finance Commission [1769]",
    "component": "Center Schemes/ Grants",
    "expected": "₹ 16,44,104",
    "received": "₹ 11,70,070",
    "reverted": "₹ 7,02,042",
    "expenditure": "₹ 11,24,140"
  },
  {
    "scheme": "XV Finance Commission [1769]",
    "component": "Center Schemes/ Grants",
    "expected": "₹ 16,44,104",
    "received": "₹ 11,70,070",
    "reverted": "₹ 7,02,042",
    "expenditure": "₹ 11,24,140"
  }
  // Add more data items as needed
];

// Function to get the list for the selected section
List<Map<String, String>> getListForSelectedSection(String selectedSection) {
  switch (selectedSection) {
    case "Govt. of India":
      return govtOfIndiaData;
    case "State Govt.":
      return stateGovtData;
    case "Other":
      return otherData;
    default:
      return [];
  }
}
