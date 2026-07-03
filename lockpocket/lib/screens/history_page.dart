import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

import 'add_salary_page.dart';
import 'add_income_page.dart';
import 'add_expense_page.dart';

class HistoryPage extends StatefulWidget {
  final VoidCallback? onChanged;
  final bool isActive;

  const HistoryPage({super.key, this.onChanged, required this.isActive});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final TransactionService transactionService = TransactionService();
  final searchController = TextEditingController();

  List<TransactionModel> allTransactions = [];
  List<TransactionModel> filteredTransactions = [];
  bool isLoading = true;
  String selectedType = 'All';
  String selectedMonth =
    DateFormat("MMMM yyyy").format(DateTime.now());

  List<String> months = [];
  final List<String> types = ['All', 'Salary', 'Income', 'Expense'];

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  @override
  void didUpdateWidget(HistoryPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      loadTransactions();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadTransactions() async {
    setState(() => isLoading = true);
    final data = await transactionService.getTransactions();
    setState(() {
      allTransactions = data;

        months = data
            .map((e) => e.month)
            .toSet()
            .toList();

        months.sort((a, b) {
        final d1 = DateFormat("MMMM yyyy").parse(a);
        final d2 = DateFormat("MMMM yyyy").parse(b);
        return d2.compareTo(d1);
        });

        if (!months.contains(selectedMonth) && months.isNotEmpty) {
        selectedMonth = months.first;
        }

        filteredTransactions =
            _applyFilters();
      isLoading = false;
    });
  }

  List<TransactionModel> _applyFilters() {
  final query = searchController.text.toLowerCase();

  return allTransactions.where((t) {
    final matchesSearch =
        t.category.toLowerCase().contains(query) ||
        t.type.toLowerCase().contains(query) ||
        t.notes.toLowerCase().contains(query);

    final matchesType =
        selectedType == "All" ||
        t.type == selectedType.toLowerCase();

    final matchesMonth =
        t.month == selectedMonth;

    return matchesSearch &&
        matchesType &&
        matchesMonth;
  }).toList();
}

  void search(String query) {
  setState(() {
    filteredTransactions = _applyFilters();
  });
}
  IconData getIcon(String type) {
    switch (type) {
      case 'salary': return Icons.account_balance_wallet;
      case 'income': return Icons.payments;
      case 'expense': return Icons.receipt_long;
      default: return Icons.attach_money;
    }
  }

  Color getColor(String type) {
    switch (type) {
      case 'salary': return Colors.green;
      case 'income': return Colors.blue;
      case 'expense': return Colors.red;
      default: return Colors.grey;
    }
  }

  Future<void> openEditPage(TransactionModel transaction) async {
    Widget page;
    switch (transaction.type) {
      case 'salary': page = AddSalaryPage(transaction: transaction); break;
      case 'income': page = AddIncomePage(transaction: transaction); break;
      case 'expense': page = AddExpensePage(transaction: transaction); break;
      default: return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );

    if (result == true) {
      await loadTransactions();
      widget.onChanged?.call();
    }
  }

  Future<void> deleteTransaction(TransactionModel transaction) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await transactionService.deleteTransaction(transaction.id!);
    await loadTransactions();
    widget.onChanged?.call();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction Deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(
        title: const Text('Transaction History'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: TextField(
                      controller: searchController,
                      onChanged: search,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: const TextStyle(fontSize: 14),
                        prefixIcon: const Icon(Icons.search, size: 20),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedType,
                      items: types.map((e) =>
                        DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))
                      ).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedType = value!;
                          filteredTransactions = _applyFilters();
                        });
                      },
                    ),
                  ),
                ),
                if (months.isNotEmpty) ...[
                  const SizedBox(width: 10),
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedMonth,
                        items: months.map((m) =>
                          DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(fontSize: 13)))
                        ).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedMonth = value!;
                            filteredTransactions = _applyFilters();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredTransactions.isEmpty
                    ? const Center(child: Text('No Transactions'))
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final t = filteredTransactions[index];
                          return GestureDetector(
                            onLongPress: () => deleteTransaction(t),
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: ListTile(
                                onTap: () => openEditPage(t),
                                leading: CircleAvatar(
                                  backgroundColor: getColor(t.type).withOpacity(.15),
                                  child: Icon(getIcon(t.type), color: getColor(t.type)),
                                ),
                                title: Text(
                                  t.category,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(DateFormat('dd MMM yyyy').format(DateTime.parse(t.date))),
                                    if (t.notes.isNotEmpty)
                                      Text(
                                        t.notes,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                                trailing: Text(
                                  '₹${t.amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: getColor(t.type),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
