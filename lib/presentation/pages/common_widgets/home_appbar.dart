import 'package:flutter/material.dart';
import 'package:tocopedia/presentation/pages/features/home/search_page.dart';

class HomeAppBar extends StatelessWidget with PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  elevation: 1,
                  child: TextFormField(
                    onFieldSubmitted: (value) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          SearchPage.routeName, ModalRoute.withName("/"),
                          arguments: value);
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.only(top: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Search Tocopedia',
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                icon: Badge(
                    label: Text("10"),
                    child: Icon(Icons.shopping_cart_outlined, size: 25)),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
