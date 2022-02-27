import 'package:flutter/material.dart';

class PopupMenu {
  int id;
  String status;
  Icon? icon;
  ImageIcon? imageIcon;
  String? img;
  PopupMenu(
      {required this.id,
      required this.status,
      this.icon,
      this.imageIcon,
      this.img});
}

List<PopupMenu> notificationMenu = <PopupMenu>[
  PopupMenu(id: 0, status: "All"),
  PopupMenu(id: 1, status: "Support"),
  PopupMenu(id: 2, status: "Account")
];

List<PopupMenu> productSortingMenu = <PopupMenu>[
  PopupMenu(id: 0, status: "Descending by updated time"),
  PopupMenu(id: 1, status: "Ascending by updated time"),
  PopupMenu(id: 2, status: "Descending by name"),
  PopupMenu(id: 3, status: "Ascending by name"),
  PopupMenu(id: 4, status: "Descending by model number"),
  PopupMenu(id: 5, status: "Ascending by model number"),
];

List<PopupMenu> customerSortingMenu = <PopupMenu>[
  PopupMenu(id: 0, status: "Descending by customer name"),
  PopupMenu(id: 1, status: "Ascending by customer name"),
];

List<PopupMenu> stationSortingMenu = <PopupMenu>[
  PopupMenu(id: 0, status: "Descending by station name"),
  PopupMenu(id: 1, status: "Ascending by station name"),
];

List<PopupMenu> deviceCategorySortingMenu = <PopupMenu>[
  PopupMenu(id: 0, status: "Ascending by category"),
  PopupMenu(id: 1, status: "Descending by category"),
];

List<PopupMenu> accountStatusFilterMenu = <PopupMenu>[
  PopupMenu(id: 0, status: "All"),
  PopupMenu(id: 1, status: "Only customers"),
  PopupMenu(id: 2, status: "Only invited"),
  PopupMenu(id: 3, status: "Only requested"),
  PopupMenu(id: 4, status: "Only joined"),
  PopupMenu(id: 5, status: "Only disabled"),
];

List<PopupMenu> deviceSortingMenu = <PopupMenu>[
  PopupMenu(id: 1, status: "Descending by updated time"),
  PopupMenu(id: 2, status: "Ascending by updated time"),
  PopupMenu(id: 3, status: "Descending by serial number"),
  PopupMenu(id: 4, status: "Ascending by serial number"),
  PopupMenu(id: 5, status: "Descending by device code"),
  PopupMenu(id: 6, status: "Ascending by device code"),
];
// List<PopupMenu> menuPopup = <PopupMenu>[
//   PopupMenu(id: 1, status: "Vendors", icon: FontAwesome5.file_excel),
//   PopupMenu(id: 2, status: "Models", icon: Entypo.tools),
//   PopupMenu(id: 3, status: "Inventory Takings", icon: Icons.group),
//   PopupMenu(id: 4, status: "Goods received", icon: Icons.supervised_user_circle),
//   PopupMenu(id: 5, status: "Delivery Orders", icon: MaterialCommunityIcons.worker),
//   PopupMenu(id: 6, status: "POs", icon: Icons.exit_to_app),
//   PopupMenu(id: 7, status: "Warehouse", icon: Icons.exit_to_app)
// ];
