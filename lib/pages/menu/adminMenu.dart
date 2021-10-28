import 'package:taxi_segurito_app/pages/menu/baseMenu.dart';
import 'package:taxi_segurito_app/pages/menu/menuItem.dart';

class AdminMenu extends Menu {
  @override
  List<MenuItem> getItems() {
    return [
      MenuItem(
        text: 'Ver lista de Dueños',
        iconPath: 'assets/icons/owner-menu.png',
        pageRoute: 'userList',
      ),
      MenuItem(
        text: 'Ver lista de Compañias',
        iconPath: 'assets/icons/company-menu.png',
        pageRoute: 'companyList',
      ),
      MenuItem(
        text: 'Registrar Dueño',
        iconPath: 'assets/icons/add-owner-menu.png',
        pageRoute: 'driverRegistration',
      ),
      MenuItem(
        text: 'Registrar Compañia',
        iconPath: 'assets/icons/add-company-menu.png',
        pageRoute: 'registerCompany',
      ),
    ];
  }
}
