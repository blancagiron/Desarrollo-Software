import 'package:ejercicio_grupal/model/account.dart';
import 'package:ejercicio_grupal/model/transaction.dart';

class BankService_MultiUser {
  Map<String, List<Account>> accounts = {};
  String? actual_user = null;
  Map<String, List<Transaction>> transacciones = {};

  void createAccount() {
    if (actual_user != null) {
      final id = _createID(actual_user!, -1);
      accounts[actual_user]!.add(Account(id: id));
    } else {
      throw Exception("No user selected");
    }
  }

  void set_actual_user(String? name) {
    if (get_all_users().contains(name)) {
      actual_user = name;
    } else {
      throw Exception("User not found");
    }
  }

  void new_user(String name) {
    if (accounts[name] == null) {
      accounts[name] = [];
      actual_user = name;
      createAccount();
    } else {
      Exception("User already exists");
    }
  }

  String? get_actual_user() {
    return actual_user;
  }

  List<String> get_all_users() {
    return accounts.keys.toList();
  }

  List<String> get_rest_of_users() {
    return accounts.keys.where((user) => user != actual_user).toList();
  }

  String _createID(String name, double amount) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final adjustedName =
        name
            .split('')
            .map(
              (char) =>
                  String.fromCharCode(char.codeUnitAt(0) + amount.toInt()),
            )
            .join();
    return '$adjustedName-$timestamp';
  }

  List<Account> get_accounts(String user) {
    return accounts[user] ?? [];
  }

  List<Map<String, dynamic>> get_transactions(String account_id) {
    double amount =
        accounts[actual_user]
            ?.firstWhere((account) => account.id == account_id)
            ?.amount ??
        0.0;
    final transactions = transacciones[account_id] ?? [];

    List<Map<String, dynamic>> result = [];
    for (var transaction in transactions.reversed) {
      result.add({'amount': amount, 'transaction': transaction});
      if (transaction is WithdrawalTransaction) {
        amount -= transaction.amount;
      } else if (transaction is DepositTransaction) {
        amount += transaction.amount;
      } else if (transaction is TransferTransaction) {
        if (transaction.destiny_account.id == account_id) {
          amount -= transaction.amount;
        } else {
          amount += transaction.amount;
        }
      }
    }

    return result;
  }

  void deposit(String account_id, double amount) {
    if (get_accounts(actual_user!).any((account) => account.id == account_id)) {
      final transaction = DepositTransaction(id: _createID(actual_user!, amount), amount: amount);
      transaction.apply(accounts[actual_user]!.firstWhere((account) => account.id == account_id));
      transacciones.putIfAbsent(account_id, () => []).add(transaction);
    } else {
      throw Exception("No account found with that ID");
    } 
  }
  void withdrawal(String account_id, double amount) {
    if (get_accounts(actual_user!).any((account) => account.id == account_id)) {
      final transaction = WithdrawalTransaction(id: _createID(actual_user!, -amount), amount: amount);
      transaction.apply(accounts[actual_user]!.firstWhere((account) => account.id == account_id));
      transacciones.putIfAbsent(account_id, () => []).add(transaction);
    } else {
      throw Exception("No account found with that ID");
    }
  }
  void transfer(String account_id, String destiny_account_id, double amount) {
    final account = accounts[actual_user]!.firstWhere((account) => account.id == account_id, orElse: () => throw Exception("Account not found"));
    final destiny_account = accounts.values
      .expand((userAccounts) => userAccounts)
      .firstWhere((account) => account.id == destiny_account_id, orElse: () => throw Exception("Destiny account not found"));

    final transaction = TransferTransaction(
      id: _createID(actual_user!, -amount),
      amount: amount,
      destiny_account: destiny_account,
    );

    transaction.apply(account);

    transacciones.putIfAbsent(account_id, () => []).add(transaction);
    transacciones.putIfAbsent(destiny_account_id, () => []).add(transaction);
  }
}

class BankService {
  String? user = null;
  late List<Account> accounts = [];
  late Map<String, List<Transaction>> transacciones = {};

  void createAccount() {
    if (user != null) {
      final id = _createID(user!, -1);
      accounts.add(Account(id: id));
    } else {
      throw Exception("There is no user");
    }
  }

  String _createID(String name, double amount) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final adjustedName =
        name
            .split('')
            .map(
              (char) =>
                  String.fromCharCode(char.codeUnitAt(0) + amount.toInt()),
            )
            .join();
    return '$adjustedName-$timestamp';
  }

  void set_user(String? name) {
    user = name;
  }

  void new_user(String name) {
    if (user == null) {
      user = name;
      createAccount();
    } else {
      user = name;
      accounts.clear();
      transacciones.clear();
      createAccount();
    }
  }

  String? get_user() {
    return user;
  }

  List<Account> get_accounts() {
    return accounts;
  }

  List<Map<String, dynamic>> get_transactions(String account_id) {
    double amount = accounts
        .firstWhere((account) => account.id == account_id)
        .amount;
    final transactions = transacciones[account_id] ?? [];

    List<Map<String, dynamic>> result = [];
    for (var transaction in transactions.reversed) {
      result.add({'amount': amount, 'transaction': transaction});
      if (transaction is WithdrawalTransaction) {
        amount -= transaction.amount;
      } else if (transaction is DepositTransaction) {
        amount += transaction.amount;
      } else if (transaction is TransferTransaction) {
        if (transaction.destiny_account.id == account_id) {
          amount -= transaction.amount;
        } else {
          amount += transaction.amount;
        }
      }
    }

    return result;
  }

  void deposit(String account_id, double amount) {
    if (user != null) {
      final transaction = DepositTransaction(id: _createID(user!, amount), amount: amount);
      transaction.apply(accounts.firstWhere((account) => account.id == account_id));
      transacciones.putIfAbsent(account_id, () => []).add(transaction);
    } else {
      throw Exception("There is no user");
    }
  }

  void withdrawal(String account_id, double amount) {
    if (user != null) {
      final transaction = WithdrawalTransaction(id: _createID(user!, -amount), amount: amount);
      transaction.apply(accounts.firstWhere((account) => account.id == account_id));
      transacciones.putIfAbsent(account_id, () => []).add(transaction);
    } else {
      throw Exception("There is no user");
    }
  }

  void transfer(String account_id, String destiny_account_id, double amount) {
    final account = accounts.firstWhere((account) => account.id == account_id, orElse: () => throw Exception("Account not found"));
    final destiny_account = accounts.firstWhere((account) => account.id == destiny_account_id, orElse: () => throw Exception("Destiny account not found"));

    final transaction = TransferTransaction(
      id: _createID(user!, -amount),
      amount: amount,
      destiny_account: destiny_account,
    );

    transaction.apply(account);

    transacciones.putIfAbsent(account_id, () => []).add(transaction);
    transacciones.putIfAbsent(destiny_account_id, () => []).add(transaction);
  }
}
