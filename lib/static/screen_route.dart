enum ScreenRoute {
  splash('splash'),
  login('login'),
  signUp('signUp'),
  forgot('forgot'),
  logSuccess('logSuccess'),
  invoiceScreen('invoiceScreen'),
  listInvoice('listInvoice'),
  invoiceForm('invoiceForm'),
  profile('profile'),
  main('main');

  final String route;
  const ScreenRoute(this.route);
}