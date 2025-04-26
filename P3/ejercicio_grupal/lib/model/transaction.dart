import "package:ejercicio_grupal/model/account.dart";

abstract class Transaction {
  String id;
  double amount;

  Transaction({
    required this.id,
    required this.amount
  });

  void apply(Account account);
  String toString();
}

class DepositTransaction extends Transaction {
  DepositTransaction({required super.id, required super.amount});

  @override
  void apply(Account account) {
    (account.deposit(amount)) ? null : throw Exception("Error depositing money");
  }

  @override
  String toString() {
    return "Deposit of $amount";
  }
}

class WithdrawalTransaction extends Transaction {
  WithdrawalTransaction({required super.id, required super.amount});

  @override
  void apply(Account account) {
    (account.withdrawal(amount)) ? null : throw Exception("Error withdrawing money");
  }

  @override
  String toString() {
    return "Withdrawal of $amount";
  }
}

class TransferTransaction extends Transaction {
  Account destiny_account;

  TransferTransaction({required super.id, required super.amount, required this.destiny_account});

  @override
  void apply(Account account) {
    if(account.withdrawal(amount)){
      if(!destiny_account.deposit(amount)){
        account.deposit(amount);
        throw Exception("Error depositing money to destination account");
      }
    } else {
      throw Exception("Error transferring money");
    }
  }

  @override
  String toString() {
    return "Transfer of $amount to ${destiny_account.id}";
  }
}