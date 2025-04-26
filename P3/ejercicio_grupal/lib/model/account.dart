class Account {
  String id;
  double amount = 0;

  Account({
    required this.id
  });

  bool deposit(double amount){
    if (amount <= 0){
      return false;
    } else {
      this.amount += amount;
      return true;
    }
  }

  bool withdrawal(double amount){
    if (this.amount - amount < 0 || amount <= 0){
      return false;
    } else {
      this.amount -= amount;
      return true;
    }
  }
}
