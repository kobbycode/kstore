final List<Map<String, dynamic>> categories = [
  {
    'image': 'images/category/electronics.png',
    'title': 'Electronics',
    'route': '/electronics',
  },
  {
    'image': 'images/category/appliance.png',
    'title': 'Appliances',
    'route': '/appliances',
  },
  {
    'image': 'images/category/computing.png',
    'title': 'Computing',
    'route': '/computing',
  },
  {
    'image': 'images/category/gaming.png',
    'title': 'Gaming',
    'route': '/gaming',
  },
  {
    'image': 'images/category/healthBeauty.png',
    'title': 'Health & Beauty',
    'route': '/healthBeauty',
  },
  {
    'image': 'images/category/homeOffice.png',
    'title': 'Home & Office',
    'route': '/homeOffice',
  },
];

List<ItemData> categoryList = [
  ItemData(text: 'Electronics'),
  ItemData(text: 'Appliances'),
  ItemData(text: 'Computing'),
  ItemData(text: 'Gaming'),
  ItemData(text: 'Health & Beauty'),
  ItemData(text: 'Home & Office'),
];

class ItemData {
  String text;
  bool isSelected;
  ItemData({required this.text, this.isSelected = false});
}
