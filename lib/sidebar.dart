import 'package:admin_panel/module/theater/theater_page.dart';
import 'package:admin_panel/module/movie/movie_page.dart';
import 'package:admin_panel/module/promote/promote_page.dart';
import 'package:admin_panel/module/schedule/schedule_page.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Row(
        children: [
          SIDEBARX(controller: _controller),
          Expanded(child: _ScreensExample(controller: _controller)),
        ],
      ),
    );
  }
}

class SIDEBARX extends StatelessWidget {
  const SIDEBARX({Key? key, required this.controller}) : super(key: key);

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 64, 1, 1),
          borderRadius: BorderRadius.circular(20),
        ),
        textStyle: TextStyle(color: Colors.white),
        selectedTextStyle: const TextStyle(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
        selectedIconTheme: const IconThemeData(color: Colors.white),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(color: Color.fromARGB(255, 55, 11, 2)),
      ),
      items: const [
        SidebarXItem(icon: Icons.movie, label: 'Movies'),
        SidebarXItem(icon: Icons.schedule, label: 'Schedules'),
        SidebarXItem(icon: Icons.location_on_outlined, label: 'Theater'),
        SidebarXItem(icon: Icons.discount_outlined, label: 'Promote'),
      ],
    );
  }
}
class _ScreensExample extends StatelessWidget {
  const _ScreensExample({Key? key, required this.controller}) : super(key: key);
  final SidebarXController controller;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        switch (controller.selectedIndex) {
          case 0:
            return MoviePage();
          case 1:
            return SchedulePageV2();
          case 2:
            return TheaterManagementPage();
          case 3:
            return PromotePage();
          default:
            return const Center(child: Text("Select a menu item"));
        }
      },
    );
  }
}

const canvasColor = Color(0xFF2E2E48);
const accentCanvasColor = Color(0xFF3E3E61);
