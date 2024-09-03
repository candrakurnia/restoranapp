import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoranapp/ui/page/result_search.dart';
import 'package:restoranapp/ui/provider/searchscreen_provider.dart';

class SearchPage extends StatefulWidget {
  static const routeName = "/searchPage";
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchResult = "";
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<SearchScreenProvider>(
          builder: (context, state, _) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.search,
                      size: 30,
                    ),
                    title: TextField(
                      controller: _controller,
                      onChanged: (String query) {
                        if (query.isNotEmpty) {
                          Provider.value(value: searchResult = query);
                          state.fetchSearchRestaurant(query);
                        }
                      },
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        hintText: 'Cari Resto',
                        border: InputBorder.none,
                      ),
                    ),
                    trailing: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        if (searchResult.isNotEmpty) {
                          _controller.clear();
                          // setState(() {
                          //   searchResult = '';
                          // });
                          Provider.value(value: searchResult = "");
                        }
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                const Flexible(child: ResultSearch())
              ],
            );
          },
        ),
      ),
    );
  }
}
