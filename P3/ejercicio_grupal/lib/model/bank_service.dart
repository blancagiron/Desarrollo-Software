import 'package:ejercicio_grupal/model/account.dart';
import 'package:ejercicio_grupal/model/transaction.dart';

class BankService {
  String? user = null;
  late List<Account> accounts = [];
  late Map<String, List<Transaction>> transacciones = {};
  static int ACCOUNT_ID = 0;

  void createAccount() {
    if (user != null) {
      final id = _createID(user!, -1);
      accounts.add(Account(id: id));
    } else {
      throw Exception("There is no user");
    }
  }

  String _createID(String name, double amount) {
    if (amount < 0) {
      final id = '$name-$ACCOUNT_ID';
      ACCOUNT_ID++;
      return id;
    } else {
      final id = '$name-$ACCOUNT_ID-$amount';
      ACCOUNT_ID++;
      return id;
    }
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
      final transaction = WithdrawalTransaction(id: _createID(user!, amount), amount: amount);
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
      id: _createID(user!, amount),
      amount: amount,
      destiny_account: destiny_account,
    );

    transaction.apply(account);

    transacciones.putIfAbsent(account_id, () => []).add(transaction);
    transacciones.putIfAbsent(destiny_account_id, () => []).add(transaction);
  }
}
