import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './jwtprovider.dart';
import './listbutton.dart';
import './menu.dart';
import './add.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _StatefulWidgetState();
}

class _StatefulWidgetState extends State<ListScreen> {
  int indexBottomNavi = 0; // BottomNaviのインデックスを保持

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('一覧表示'),
      ),
      body: Consumer<JwtProvider>(builder: (context, jwtProvider, _) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  jwtProvider.message,
                  style: const TextStyle(color: Colors.red),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(5),
                    itemCount: jwtProvider.weightList.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(color: Colors.white, height: 10);
                    },
                    itemBuilder: (context, index) => WeightListButton(
                        index: index, weight: jwtProvider.weightList[index]),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
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
