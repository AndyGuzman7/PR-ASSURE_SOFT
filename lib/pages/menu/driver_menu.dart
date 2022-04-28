import 'package:taxi_segurito_app/pages/menu/driver_base_menu.dart';
import 'package:taxi_segurito_app/pages/menu/driver_menu_item.dart';

class DriverMenu extends MenuDriver {
  DriverMenu({String? name}) : super(name: name);
  @override
  List<MenuDriverItem> getDriverItems() {
    return [
      MenuDriverItem(
        text: 'Prestar servicio',
        iconPath: 'assets/icons/owner-menu.png',
        pageRoute: 'userList',
      ),
      MenuDriverItem(
        text: 'Configuraciones',
        iconPath: 'assets/icons/config.png',
        pageRoute: 'companyList',
      ),
    ];
  }
}
