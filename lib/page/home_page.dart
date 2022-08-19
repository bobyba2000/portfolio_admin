import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/page/about/about_page.dart';
import 'package:portfolio/page/blog/blog_page.dart';
import 'package:portfolio/page/service/service_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController page = PageController();

  bool isExpanded = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: page,
            style: SideMenuStyle(
              displayMode: isExpanded ? SideMenuDisplayMode.open : SideMenuDisplayMode.compact,
              hoverColor: Colors.grey,
              compactSideMenuWidth: 62,
              selectedColor: Colors.black,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
              backgroundColor: Colors.white,
              iconSize: 36,
            ),
            title: Padding(
              padding: EdgeInsets.symmetric(horizontal: !isExpanded ? 0 : 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: isExpanded ? 80 : 50,
                            maxWidth: isExpanded ? 80 : 50,
                          ),
                          child: const Icon(
                            Icons.webhook_rounded,
                            size: 60,
                          ),
                        ),
                        onTap: () {
                          if (!isExpanded) {
                            setState(() {
                              isExpanded = true;
                            });
                          }
                        },
                      ),
                      Visibility(
                        visible: isExpanded,
                        child: InkWell(
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.all(10),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              isExpanded = false;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  Visibility(
                    visible: isExpanded,
                    child: const Text(
                      "Dung's Personal Web",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !isExpanded,
                    child: const SizedBox(height: 20),
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            items: [
              SideMenuItem(
                priority: 0,
                title: 'About',
                onTap: () {
                  page.jumpToPage(0);
                },
                icon: const Icon(Icons.account_circle_outlined),
              ),
              SideMenuItem(
                priority: 1,
                title: 'Services',
                onTap: () {
                  page.jumpToPage(1);
                },
                icon: const Icon(Icons.dashboard_customize_outlined),
              ),
              SideMenuItem(
                priority: 2,
                title: 'Blogs',
                onTap: () {
                  page.jumpToPage(2);
                },
                icon: const Icon(Icons.article_outlined),
              ),
            ],
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: PageView(
                      controller: page,
                      children: [
                        Container(
                          color: Colors.grey.withOpacity(0.3),
                          child: const Padding(
                            padding: EdgeInsets.all(24),
                            child: AboutPage(),
                          ),
                        ),
                        Container(
                          color: Colors.grey.withOpacity(0.3),
                          child: const Padding(
                            padding: EdgeInsets.all(24),
                            child: ServicePage(),
                          ),
                        ),
                        Container(
                          color: Colors.grey.withOpacity(0.3),
                          child: const Padding(
                            padding: EdgeInsets.all(24),
                            child: BlogPage(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
