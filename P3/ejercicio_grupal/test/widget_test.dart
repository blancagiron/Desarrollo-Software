import 'package:ejercicio_grupal/model/account.dart';
import 'package:ejercicio_grupal/model/transaction.dart';
import 'package:ejercicio_grupal/model/bank_service.dart';
import 'package:test/test.dart';

void main() {
  group('Account', () {
    test('Initial balance should be zero', () {
      final account = Account(id: 'test-001');
      expect(account.amount, equals(0));
    });

    test('Cannot deposit negative or zero amounts', () {
      final account = Account(id: 'test-002');

      expect(account.deposit(0), equals(false));
      expect(account.amount, equals(0));

      expect(account.deposit(-100), equals(false));
      expect(account.amount, equals(0));

      expect(account.deposit(100), equals(true));
      expect(account.amount, equals(100));
    });

    test('Cannot withdraw negative or zero amounts', () {
      final account = Account(id: 'test-003');
      account.deposit(100);

      expect(account.withdrawal(0), equals(false));
      expect(account.amount, equals(100));

      expect(account.withdrawal(-50), equals(false));
      expect(account.amount, equals(100));

      expect(account.withdrawal(50), equals(true));
      expect(account.amount, equals(50));
    });
  });

  group('Transaction', () {
    test('DepositTransaction.apply increases balance correctly', () {
      final account = Account(id: 'test-004');
      final transaction = DepositTransaction(id: 'deposit-001', amount: 150);

      transaction.apply(account);
      expect(account.amount, equals(150));
    });

    test('WithdrawalTransaction.apply throws Exception when insufficient funds', () {
      final account = Account(id: 'test-005');
      account.deposit(50);

      final transaction = WithdrawalTransaction(id: 'withdrawal-001', amount: 100);

      expect(() => transaction.apply(account), throwsException);
      expect(account.amount, equals(50)); // Balance should remain unchanged
    });

    test('TransferTransaction.apply moves funds between accounts correctly', () {
      final sourceAccount = Account(id: 'source-001');
      final destAccount = Account(id: 'dest-001');

      sourceAccount.deposit(200);

      final transaction = TransferTransaction(
          id: 'transfer-001',
          amount: 125,
          destiny_account: destAccount
      );

      transaction.apply(sourceAccount);

      expect(sourceAccount.amount, equals(75));
      expect(destAccount.amount, equals(125));
    });
  });

  group('BankService', () {
    late BankService bankService;

    setUp(() {
      bankService = BankService();
      bankService.new_user('testUser');
    });

    test('Initial accounts list should be empty before creating account', () {
      // Create a fresh bank service without calling new_user
      final freshService = BankService();
      expect(freshService.accounts, isEmpty);
    });

    test('deposit increases account balance', () {
      final account = bankService.get_accounts().first;
      final initialAmount = account.amount;

      bankService.deposit(account.id, 250);

      expect(account.amount, equals(initialAmount + 250));
    });

    test('withdrawal throws Exception when balance is insufficient', () {
      final account = bankService.get_accounts().first;

      expect(() => bankService.withdrawal(account.id, 300), throwsException);
    });

    test('transfer moves funds correctly', () {
      // Create a second account
      bankService.createAccount();
      final accounts = bankService.get_accounts();
      expect(accounts.length, equals(2));

      final sourceAccount = accounts[0];
      final destAccount = accounts[1];

      // Deposit into source account
      bankService.deposit(sourceAccount.id, 300);

      // Transfer funds
      bankService.transfer(sourceAccount.id, destAccount.id, 150);

      expect(sourceAccount.amount, equals(150));
      expect(destAccount.amount, equals(150));
    });

    test('transfer throws Exception when funds are insufficient', () {
      // Create a second account
      bankService.createAccount();
      final accounts = bankService.get_accounts();

      final sourceAccount = accounts[0];
      final destAccount = accounts[1];

      // Try to transfer with no funds
      expect(
              () => bankService.transfer(sourceAccount.id, destAccount.id, 100),
          throwsException
      );
    });

    test('Transaction IDs are unique', () {
      final account = bankService.get_accounts().first;

      // Create two deposits with minimal time difference
      bankService.deposit(account.id, 100);
      bankService.deposit(account.id, 150);

      final transactions = bankService.get_transactions(account.id);
      expect(transactions.length, equals(2));

      final transaction1 = transactions[0]['transaction'] as DepositTransaction;
      final transaction2 = transactions[1]['transaction'] as DepositTransaction;

      // Verify IDs are different
      expect(transaction1.id != transaction2.id, isTrue);
    });
  });
}