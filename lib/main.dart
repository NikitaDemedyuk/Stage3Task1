import 'dart:io';

enum StatisticType {
  poorestClientAllBanks,
  richestBank,
  averageSumAllBanks,
}

class IncorrectValueException implements Exception {
  String getErrorMessage() {
    return '\nIncorrect value or index\n';
  }
}

final List<List<double>> accounts = [];

double? parseDoubleInputValue(String readLine, String source) {
  try {
    if (RegExp(source).hasMatch(readLine)) {
      throw IncorrectValueException();
    } else {
      return double.parse(readLine);
    }
  } on IncorrectValueException catch (e) {
    stdout.write(e.getErrorMessage());
    return null;
  }
}

int? parseIntInputValue(String readLine, String source) {
  try {
    if (RegExp(source).hasMatch(readLine)) {
      throw IncorrectValueException();
    } else {
      return int.parse(readLine);
    }
  } on IncorrectValueException catch (e) {
    stdout.write(e.getErrorMessage());
    return null;
  }
}

void fillAccountsList() {
  stdout.write("\nEnter the number of banks: ");
  final int? numberOfBanks = parseIntInputValue(
      stdin.readLineSync() ?? '', r"[a-zA-Z.a-zA-Z.!#$%&'*+-/=?^_`{|}~]+");
  if (numberOfBanks == 0 || numberOfBanks == null) return;
  final List<int> numbersOfUsersInBank = <int>[];
  stdout.write("\n-----------------------------------------------\n");
  for (int i = 0; i < numberOfBanks; ++i) {
    stdout.write("\nNumber of clients in bank # ${i + 1} = ");
    final int? value = parseIntInputValue(
        stdin.readLineSync() ?? '', r"[a-zA-Z.a-zA-Z.!#$%&'*+-/=?^_`{|}~]+");
    if (value != null) {
      numbersOfUsersInBank.add(value);
    } else {
      return;
    }
  }
  stdout.write("\n-----------------------------------------------\n");
  for (int i = 0; i < numberOfBanks; ++i) {
    final List<double> clientsAccounts = <double>[];
    for (int j = 0; j < numbersOfUsersInBank[i]; ++j) {
      stdout.write("Client [${i + 1}][${j + 1}] = ");
      final double? value = parseDoubleInputValue(stdin.readLineSync() ?? '',
          r"[a-zA-Za-zA-Z!#$%&'*+-/=?^_`{|}~]+.[a-zA-Za-zA-Z!#$%&'*+-/=?^_`{|}~]");
      if (value != null) {
        clientsAccounts.add(value);
      } else {
        clientsAccounts.add(0.0);
      }
    }
    accounts.add(clientsAccounts);
  }
}

void printAccountList() {
  stdout.write("\n-----------------------------------------------\n");
  for (int i = 0; i < accounts.length; ++i) {
    stdout.write('Bank #$i: [ ');
    for (int j = 0; j < accounts[i].length; ++j) {
      stdout.write('${accounts[i][j]} ');
    }
    stdout.write(']\n');
  }
  stdout.write("\n-----------------------------------------------\n");
}

double _getPoorestClientScore() {
  double minElement = accounts[0][0];

  for (int i = 0; i < accounts.length; ++i) {
    final double minElementInLine = accounts[i].fold(
        accounts[i][0],
        (previousValue, element) =>
            previousValue < element ? previousValue : element);
    if (minElementInLine < minElement) {
      minElement = minElementInLine;
    }
  }
  return minElement;
}

double _getRichestBankScore() {
  final List<double> scoresBanks = <double>[];
  for (int i = 0; i < accounts.length; ++i) {
    scoresBanks.add(accounts[i]
        .reduce((firstElement, secondElement) => firstElement + secondElement));
  }
  scoresBanks.sort();
  return scoresBanks[scoresBanks.length - 1];
}

double _getAverageClientScore() {
  double sumAllBanks = 0.0;
  int numberOfAllClients = 0;
  for (int i = 0; i < accounts.length; ++i) {
    sumAllBanks += accounts[i]
        .reduce((firstElement, secondElement) => firstElement + secondElement);
    numberOfAllClients += accounts[i].length;
  }
  return sumAllBanks / numberOfAllClients;
}

double? getStatistic(StatisticType? statisticType) {
  if (accounts.isEmpty || statisticType == null) return null;
  switch (statisticType) {
    case StatisticType.poorestClientAllBanks:
      return _getPoorestClientScore();
    case StatisticType.richestBank:
      return _getRichestBankScore();
    case StatisticType.averageSumAllBanks:
      return _getAverageClientScore();
    default:
      stdout.write('\nSomething went wrong\n');
      return null;
  }
}

bool _testGetPoorestClient(double? expectedResult) {
  final double? result = _getPoorestClientScore();
  return result == expectedResult;
}

bool _testGetRichestBankScore(double? expectedResult) {
  final double? result = _getRichestBankScore();
  return result == expectedResult;
}

bool _testGetAverageBankScore(double? expectedResult) {
  final double? result = _getAverageClientScore();
  return result == expectedResult;
}

int main() {
  stdout.write("Start!\n");

  stdout.write(
      'Select:\n1 - Enter values by yourself\n2 - Test mode\n3 - Exit\nEnter: ');
  final int? chooseModeIndex = parseIntInputValue(stdin.readLineSync() ?? '',
      r"[a-zA-Z04-9.a-zA-Z04-9.!#$%&'*+-/=?^_`{|}~ ]+");
  if (chooseModeIndex == null) return 0;
  if (chooseModeIndex == 1) {
    fillAccountsList();
    stdout.write(
        "Choose necessary operation:\n1 - Get the poorest client of all banks ,\n2 - Get the sum of all accounts of the richest bank ,\n3 - Get the average sum of clients account for all banks\nEnter: ");
    final int? selectStatisticType = parseIntInputValue(
        stdin.readLineSync() ?? '',
        r"[a-zA-Z04-9.a-zA-Z04-9.!#$%&'*+-/=?^_`{|}~ ]+");
    if (selectStatisticType == null) return 0;
    StatisticType? statisticType;
    if (selectStatisticType == 1) {
      statisticType = StatisticType.poorestClientAllBanks;
    }
    if (selectStatisticType == 2) {
      statisticType = StatisticType.richestBank;
    }
    if (selectStatisticType == 3) {
      statisticType = StatisticType.averageSumAllBanks;
    }
    final double? result = getStatistic(statisticType);
    if (result == null) return 0;
    stdout.write('\nResult = $result\n');
  }
  if (chooseModeIndex == 2) {
    accounts.add([100.0, 35.0, 125.0]);
    accounts.add([75.0, 25.0, 55.0]);
    accounts.add([60.0, 130.0]);
    accounts.add([175.0, 90.0]);
    accounts.add([40.0, 50.0]);
    stdout.write(_testGetPoorestClient(25.0));
    stdout.write(_getRichestBankScore());
    stdout.write(_testGetRichestBankScore(265.0));
    stdout.write(_testGetAverageBankScore(80.0));
  }
  if (chooseModeIndex == 3) {
    return 0;
  }
  stdout.write('\nEnd of program\n');
  return 0;
}
