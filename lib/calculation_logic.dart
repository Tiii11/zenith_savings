// lib/calculation_logic.dart
import 'dart:math';

class SavingsPlan {
  final double monthlyIncome;
  final double monthlyTransportFee;
  
  double moneyAfterTransportation = 0;
  static const double MONTHLY_SPECIAL_FOOD_FUND = 10.00;
  double moneyAfterTransportAndSpecialFood = 0; 

  double guaranteedMonthlySavings = 0;
  double monthlyPotForDailySpendingAndGroceries = 0;
  double recommendedDailySpendingAndGroceries = 0;
  
  String statusMessage = "";
  bool calculationSuccess = false;
  String appliedStrategyName = "";
  String savingsTierDetail = ""; 

  static const double DAYS_IN_MONTH_AVG = 365.2425 / 12.0;

  // --- UPDATED AGGRESSIVE SAVINGS PERCENTAGES ---
  static const double TIER1_MATSF_UPPER_BOUND = 300.00;
  static const double TIER1_SAVINGS_PERCENTAGE = 0.25; // WAS 0.10

  static const double TIER2_MATSF_UPPER_BOUND = 1000.00;
  static const double TIER2_SAVINGS_PERCENTAGE = 0.40; // WAS 0.20

  static const double TIER3_SAVINGS_PERCENTAGE = 0.50; // WAS 0.30
  // --- END OF UPDATED PERCENTAGES ---

  static const double CHALLENGING_DAILY_SPEND_THRESHOLD = 5.00; // Lowered this slightly due to more aggressive savings


  SavingsPlan({required this.monthlyIncome, required this.monthlyTransportFee}) {
    _calculate();
  }

  void _calculate() {
    moneyAfterTransportation = monthlyIncome - monthlyTransportFee;

    if (moneyAfterTransportation < 0) {
        statusMessage = "Error: Transportation costs exceed your income. No funds available for special food, savings, or daily spending.";
        calculationSuccess = false;
        appliedStrategyName = "Income Deficit";
        _resetValuesToZero();
        return;
    }

    moneyAfterTransportAndSpecialFood = moneyAfterTransportation - MONTHLY_SPECIAL_FOOD_FUND;

    if (moneyAfterTransportAndSpecialFood < 0) {
        statusMessage = "After transport and the \$${MONTHLY_SPECIAL_FOOD_FUND.toStringAsFixed(2)} special food fund, there are no funds left for savings or daily groceries. Try to reduce transport costs or increase income.";
        if (moneyAfterTransportation > 0 && moneyAfterTransportation < MONTHLY_SPECIAL_FOOD_FUND) {
             statusMessage = "Income after transport (\$$moneyAfterTransportation_formatted) is less than the \$${MONTHLY_SPECIAL_FOOD_FUND.toStringAsFixed(2)} special food fund. This fund may not be viable.";
        }
        calculationSuccess = true; 
        appliedStrategyName = "Funds Exhausted Early";
        _resetValuesToZero(); 
        return;
    }

    double currentSavingsPercentage;

    if (moneyAfterTransportAndSpecialFood <= TIER1_MATSF_UPPER_BOUND) {
      appliedStrategyName = "Foundational Max Savings"; // Renamed
      currentSavingsPercentage = TIER1_SAVINGS_PERCENTAGE;
      savingsTierDetail = "Aiming for ${ (currentSavingsPercentage * 100).toStringAsFixed(0) }% savings from the remainder.";
      if (moneyAfterTransportAndSpecialFood < 50) {
         statusMessage = "Funds are very tight. Every dollar saved counts! ($appliedStrategyName)";
      } else {
         statusMessage = "Focus on building a consistent aggressive savings habit. ($appliedStrategyName)";
      }
    } else if (moneyAfterTransportAndSpecialFood <= TIER2_MATSF_UPPER_BOUND) {
      appliedStrategyName = "Focused Max Savings"; // Renamed
      currentSavingsPercentage = TIER2_SAVINGS_PERCENTAGE;
      savingsTierDetail = "Targeting ${ (currentSavingsPercentage * 100).toStringAsFixed(0) }% savings from the remainder.";
      statusMessage = "Strive for regular, substantial savings by managing daily costs tightly. ($appliedStrategyName)";
    } else {
      appliedStrategyName = "Intense Max Savings"; // Renamed
      currentSavingsPercentage = TIER3_SAVINGS_PERCENTAGE;
      savingsTierDetail = "Maximizing savings with ${ (currentSavingsPercentage * 100).toStringAsFixed(0) }% from the remainder.";
      statusMessage = "Aggressively manage daily costs to achieve very high savings. ($appliedStrategyName)";
    }

    guaranteedMonthlySavings = moneyAfterTransportAndSpecialFood * currentSavingsPercentage;
    if (guaranteedMonthlySavings < 0) guaranteedMonthlySavings = 0; 

    monthlyPotForDailySpendingAndGroceries = moneyAfterTransportAndSpecialFood - guaranteedMonthlySavings;
    if (monthlyPotForDailySpendingAndGroceries < 0) monthlyPotForDailySpendingAndGroceries = 0;

    recommendedDailySpendingAndGroceries = (monthlyPotForDailySpendingAndGroceries > 0) ? (monthlyPotForDailySpendingAndGroceries / DAYS_IN_MONTH_AVG) : 0;
    
    calculationSuccess = true; 
    
    if (recommendedDailySpendingAndGroceries > 0 && recommendedDailySpendingAndGroceries < CHALLENGING_DAILY_SPEND_THRESHOLD) {
        statusMessage += " CRITICAL NOTE: Your daily spending amount (\$$recommendedDailySpendingAndGroceries_formatted) for groceries and ALL other needs is extremely low. This will be very challenging and requires strict discipline.";
    } else if (recommendedDailySpendingAndGroceries == 0 && moneyAfterTransportAndSpecialFood > 0) {
        statusMessage += " Your entire remainder after the special food fund is allocated to savings, leaving \$0 for daily groceries and other spending. This is an extreme savings approach.";
    }
  }

  void _resetValuesToZero() {
      guaranteedMonthlySavings = 0;
      monthlyPotForDailySpendingAndGroceries = 0;
      recommendedDailySpendingAndGroceries = 0;
  }

  String get monthlyIncome_formatted => monthlyIncome.toStringAsFixed(2);
  String get monthlyTransportFee_formatted => monthlyTransportFee.toStringAsFixed(2);
  String get moneyAfterTransportation_formatted => moneyAfterTransportation.toStringAsFixed(2);
  String get moneyAfterTransportAndSpecialFood_formatted => moneyAfterTransportAndSpecialFood.toStringAsFixed(2);
  String get monthlySpecialFoodFund_formatted => MONTHLY_SPECIAL_FOOD_FUND.toStringAsFixed(2);
  
  String get guaranteedMonthlySavings_formatted => guaranteedMonthlySavings.toStringAsFixed(2);
  String get monthlyPotForDailySpendingAndGroceries_formatted => monthlyPotForDailySpendingAndGroceries.toStringAsFixed(2);
  String get recommendedDailySpendingAndGroceries_formatted => recommendedDailySpendingAndGroceries.toStringAsFixed(2);
  
  String get averageDaysPerMonth_formatted => DAYS_IN_MONTH_AVG.toStringAsFixed(1);
}