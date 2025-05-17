import 'package:flutter/material.dart';
import 'package:ejercicio_grupal/model/account.dart';
import 'package:ejercicio_grupal/model/transaction.dart';
import 'package:ejercicio_grupal/model/bank_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Banco App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final BankService _bankService = BankService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.account_balance,
                  size: 80,
                  color: Colors.green,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Mi Banco App',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de Usuario',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    if (_usernameController.text.isNotEmpty) {
                      _bankService.new_user(_usernameController.text);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => AccountsScreen(bankService: _bankService),
                        ),
                      );
                    }
                  },
                  child: const Text('Ingresar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AccountsScreen extends StatefulWidget {
  final BankService bankService;

  const AccountsScreen({
    super.key,
    required this.bankService,
  });

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  @override
  Widget build(BuildContext context) {
    List<Account> accounts = widget.bankService.get_accounts();
    String? username = widget.bankService.get_user();

    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, $username'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: accounts.isEmpty
          ? const Center(child: Text('No tienes cuentas aún'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          final account = accounts[index];
          return AccountCard(
            account: account,
            bankService: widget.bankService,
            onUpdate: () {
              setState(() {});
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: () {
          widget.bankService.createAccount();
          setState(() {});
        },
        child: const Icon(Icons.add),
        tooltip: 'Crear nueva cuenta',
      ),
    );
  }
}

class AccountCard extends StatelessWidget {
  final Account account;
  final BankService bankService;
  final VoidCallback onUpdate;

  const AccountCard({
    super.key,
    required this.account,
    required this.bankService,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AccountDetailScreen(
                account: account,
                bankService: bankService,
                onUpdate: onUpdate,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cuenta ${account.id.split('-').last}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Saldo disponible'),
                  Text(
                    '\$${account.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountDetailScreen extends StatefulWidget {
  final Account account;
  final BankService bankService;
  final VoidCallback onUpdate;

  const AccountDetailScreen({
    super.key,
    required this.account,
    required this.bankService,
    required this.onUpdate,
  });

  @override
  State<AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  late TextEditingController _amountController;
  late TextEditingController _transferAccountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _transferAccountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _transferAccountController.dispose();
    super.dispose();
  }

  void _showTransactionDialog(
      BuildContext context,
      String title,
      Function(double) onConfirm,
      ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: _amountController,
          decoration: const InputDecoration(
            labelText: 'Asunto',
            prefixText: '\$',
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(_amountController.text);
              if (amount != null && amount > 0) {
                onConfirm(amount);
                Navigator.of(context).pop();
                _amountController.clear();
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _showTransferDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Transferir'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _transferAccountController,
              decoration: const InputDecoration(
                labelText: 'ID de cuenta destino',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Monto',
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(_amountController.text);
              final destinyAccountId = _transferAccountController.text.trim();

              if (amount != null && amount > 0 && destinyAccountId.isNotEmpty) {
                try {
                  widget.bankService.transfer(
                    widget.account.id,
                    destinyAccountId,
                    amount,
                  );
                  setState(() {});
                  widget.onUpdate();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Transferencia realizada con éxito'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  Navigator.of(context).pop();
                }
                _amountController.clear();
                _transferAccountController.clear();
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactions = widget.bankService.get_transactions(widget.account.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cuenta ${widget.account.id.split('-').last}'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Balance card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Saldo disponible',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${widget.account.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'ID: ${widget.account.id}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.arrow_upward),
                    label: const Text('Depositar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      _showTransactionDialog(
                        context,
                        'Depositar',
                            (amount) {
                          widget.bankService.deposit(widget.account.id, amount);
                          setState(() {});
                          widget.onUpdate();
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.arrow_downward),
                    label: const Text('Retirar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      _showTransactionDialog(
                        context,
                        'Retirar',
                            (amount) {
                          try {
                            widget.bankService.withdrawal(widget.account.id, amount);
                            setState(() {});
                            widget.onUpdate();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: ${e.toString()}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text('Transferir'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      _showTransferDialog(context);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Transactions list
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.history, size: 18),
                SizedBox(width: 8),
                Text(
                  'Historial de transacciones',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: transactions.isEmpty
                ? const Center(
              child: Text('No hay transacciones aún'),
            )
                : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return TransactionTile(
                  transaction: transaction['transaction'] as Transaction,
                  amount: transaction['amount'] as double,
                  accountId: widget.account.id,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final double amount;
  final String accountId;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.amount,
    required this.accountId,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    String title;

    if (transaction is DepositTransaction) {
      icon = Icons.arrow_upward;
      color = Colors.green;
      title = 'Depósito';
    } else if (transaction is WithdrawalTransaction) {
      icon = Icons.arrow_downward;
      color = Colors.red;
      title = 'Retiro';
    } else if (transaction is TransferTransaction) {
      final transferTransaction = transaction as TransferTransaction;

      if (transferTransaction.destiny_account.id == accountId) {
        icon = Icons.arrow_downward;
        color = Colors.green;
        title = 'Transferencia recibida';
      } else {
        icon = Icons.arrow_upward;
        color = Colors.orange;
        title = 'Transferencia enviada';
      }
    } else {
      icon = Icons.swap_horiz;
      color = Colors.blue;
      title = 'Transacción';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 1,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color),
          ),
          title: Text(title),
          subtitle: Text(transaction.toString()),
          trailing: Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: amount > 0 ? Colors.black : Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}