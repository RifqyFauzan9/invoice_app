enum ScreenRoute {
  splash('splash'),
  login('login'),
  signUp('signUp'),
  forgot('forgot'),
  logSuccess('logSuccess'),
  main('main'),
  invoiceScreen('invoiceScreen'),
  listInvoice('listInvoice'),
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
  profileForm('profileForm'),
  statusScreen('statusScreen'),
  updateInvoice('updateInvoice');

  final String route;
  const ScreenRoute(this.route);
}