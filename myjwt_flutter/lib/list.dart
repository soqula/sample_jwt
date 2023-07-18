import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './jwtprovider.dart';
import './menu.dart';
import './add.dart';
import './listlist.dart';
import './chart.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _StatefulWidgetState();
}

class _StatefulWidgetState extends State<ListScreen> {
  int indexBottomNavi = 1; // BottomNaviのインデックスを保持

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('一覧表示'),
      ),
      body: SafeArea(
        child: IndexedStack(
          children: [ListList(), ListList(), ChartList()],
          index: indexBottomNavi,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => const WeightAdd(),
            ),
          );
        },
      ),
      bottomNavigationBar: Consumer<JwtProvider>(
        builder: (context, jwtProvider, _) {
          return BottomNavigationBar(
            onTap: (index) => {
              if (index == 0)
                {
                  jwtProvider.clear(),
                  jwtProvider.logout(),
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MenuScreen()),
                    (route) => false,
                  ),
                },
              setState(
                () => indexBottomNavi = index,
              ),
            },
            currentIndex: indexBottomNavi, // 今現在アクティブなページ
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'logout',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_reaction_rounded),
                label: 'list',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_reaction_rounded),
                label: 'graph',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.settings),
              //   label: 'settings',
              // ),
            ],
          );
        },
      ),
    );
  }
}
