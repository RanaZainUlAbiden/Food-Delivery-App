class AppImages {
  static const String base = 'assets/images/';

  // Menu Items
  static const Map<String, String> menuImages = {
    'Mighty Meat Pizza': '${base}mighty_meat_pizza.jpg',
    'BBQ Chicken Pizza': '${base}bbq_chicken_pizza.jpg',
    'Veggie Delight Pizza': '${base}veggie_delight_pizza.jpg',
    'Stone Burger': '${base}stone_burger.jpg',
    'Zinger Burger': '${base}zinger_burger.jpg',
    'Double Smash': '${base}double_smash.jpg',
    'Family Deal': '${base}family_deal.jpg',
    'Student Deal': '${base}student_deal.jpg',
    'Pepsi': '${base}pepsi.jpg',
    '7UP': '${base}7up.jpg',
    'Garlic Bread': '${base}garlic_bread.mp4',
    'Coleslaw': '${base}coleslaw.mp4',
  };

  static String getImage(String itemName) {
    return menuImages[itemName] ?? '${base}mighty_meat_pizza.jpg';
  }
}