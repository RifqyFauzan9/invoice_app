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
  chooseForm('chooseForm'),
  setup('setup'),
  transaksi('transaksi'),
  realSplash('realSplash'),
  travel('travel'),
  item('item'),
  bank('bank'),
  airlines('airlines'),
  travelForm('travelForm'),
  bankForm('bankForm'),
  airlinesForm('airlinesForm'),
  itemForm('itemForm'),
  note('note'),
  noteForm('noteForm'),
  report('report'),
  main('main');

  final String route;
  const ScreenRoute(this.route);
}