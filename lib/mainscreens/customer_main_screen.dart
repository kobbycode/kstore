import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomerMainScreen extends StatefulWidget {
  const CustomerMainScreen({Key? key}) : super(key: key);

  @override
  State<CustomerMainScreen> createState() => _CustomerMainScreenState();
}

class _CustomerMainScreenState extends State<CustomerMainScreen> {
  int _selectedIndex = 0;

  final List<String> _pageLabels = [
    'Home',
    'Category',
    'Stores',
    'Cart',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _buildPages(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0XFF24697E),
        unselectedItemColor: Colors.grey, //
        currentIndex: _selectedIndex,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
        ),
        elevation: 0,
        items: [
          _buildBottomNavigationBarItem(
            'images/icons/home.svg',
            'Home',
          ),
          _buildBottomNavigationBarItem(
            'images/icons/category.svg',
            'Category',
          ),
          _buildBottomNavigationBarItem(
            'images/icons/shop.svg',
            'Stores',
          ),
          _buildBottomNavigationBarItem(
            'images/icons/cart.svg',
            'Cart',
          ),
          _buildBottomNavigationBarItem(
            'images/icons/profile.svg',
            'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
    String iconPath,
    String label,
  ) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        width: 25,
        color: _selectedIndex == _pageLabels.indexOf(label)
            ? const Color(0XFF24697E)
            : Colors.grey,
      ),
      label: label,
    );
  }

  List<Widget> _buildPages() {
    return [
      const HomePage(),
      const CategoriesPage(),
      const StoresPage(),
      const CartPage(),
      const ProfilePage(),
    ];
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Home Page'),
    );
  }
}

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Categories Page'),
    );
  }
}

class StoresPage extends StatelessWidget {
  const StoresPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Stores Page'),
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Cart Page'),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profile Page'),
    );
  }
}
