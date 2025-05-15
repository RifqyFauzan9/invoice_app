import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final ScrollController verticalScroll = ScrollController();
  final ScrollController verticalScrollForNo = ScrollController();
  final ScrollController horizontalScroll = ScrollController();
  final ScrollController horizontalScrollForHeader = ScrollController();

  final headerColor = const Color(0xFF2E6D89);

  final columns = [
    'No', 'Inv No', 'Inv Date', 'Customer', 'Status', 'Qty', 'Total Amount'
  ];

  final rows = List.generate(
    30,
    (index) => [
      '${index + 1}',
      'INV-00${index + 1}',
      '${(index % 12) + 1}/ ${(index % 28) + 1}/20${10 + (index % 10)}',
      ['Max', 'Kristin', 'Gladys', 'Shane', 'Eduardo', 'Shawn', 'Ann', 'Darrell', 'Cody'][index % 9],
      index % 3 == 0 ? 'booking' : index % 3 == 1 ? 'Fullpay' : 'Issued',
      '${(index % 5) + 1}',
      '${(index + 1) * 100}.555'
    ],
  );

  @override
  void initState() {
    super.initState();
    verticalScroll.addListener(() {
      if (verticalScroll.offset != verticalScrollForNo.offset) {
        verticalScrollForNo.jumpTo(verticalScroll.offset);
      }
    });
    verticalScrollForNo.addListener(() {
      if (verticalScroll.offset != verticalScrollForNo.offset) {
        verticalScroll.jumpTo(verticalScrollForNo.offset);
      }
    });
    horizontalScroll.addListener(() {
      if (horizontalScroll.offset != horizontalScrollForHeader.offset) {
        horizontalScrollForHeader.jumpTo(horizontalScroll.offset);
      }
    });
    horizontalScrollForHeader.addListener(() {
      if (horizontalScroll.offset != horizontalScrollForHeader.offset) {
        horizontalScroll.jumpTo(horizontalScrollForHeader.offset);
      }
    });
  }

  @override
  void dispose() {
    verticalScroll.dispose();
    verticalScrollForNo.dispose();
    horizontalScroll.dispose();
    horizontalScrollForHeader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: headerColor,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: const Text('Report', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.file_download, color: Colors.white),
          )
        ],
      ),
      body: Column(
        children: [
          // Filters
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    filterDropdown('All Status'),
                    filterDropdown('All Periode'),
                    filterDropdown('All Maskapai'),
                    filterDropdown('All Item'),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search customer or invoice',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: headerColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('Search'),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0),
          // Table
          Expanded(
            child: Stack(
              children: [
                // Main scrollable table
                Positioned.fill(
                  left: 60,
                  top: 50,
                  child: SingleChildScrollView(
                    controller: verticalScroll,
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      controller: horizontalScroll,
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: rows.map((row) {
                          return Row(
                            children: row.sublist(1).map((cell) {
                              return Container(
                                width: 120,
                                height: 50,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey.shade300),
                                  ),
                                ),
                                child: Text(cell),
                              );
                            }).toList(),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                // Sticky header (columns)
                Positioned(
                  top: 0,
                  left: 60,
                  right: 0,
                  height: 50,
                  child: SingleChildScrollView(
                    controller: horizontalScrollForHeader,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: columns.sublist(1).map((col) {
                        return Container(
                          width: 120,
                          height: 50,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          color: Colors.grey.shade200,
                          child: Text(
                            col,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                // Sticky column "No"
                Positioned(
                  left: 0,
                  top: 50,
                  bottom: 0,
                  width: 60,
                  child: SingleChildScrollView(
                    controller: verticalScrollForNo,
                    child: Column(
                      children: rows.map((row) {
                        return Container(
                          width: 60,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          child: Text(row[0]),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                // Sticky "No" header
                Positioned(
                  left: 0,
                  top: 0,
                  width: 60,
                  height: 50,
                  child: Container(
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Text(
                      'No',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget filterDropdown(String label) {
    return SizedBox(
      width: 160,
      child: DropdownButtonFormField<String>(
        value: label,
        items: [label].map((e) {
          return DropdownMenuItem(value: e, child: Text(e));
        }).toList(),
        onChanged: (value) {},
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
