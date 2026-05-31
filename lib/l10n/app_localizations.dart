import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedStrings = {
    'es': {
      'app_title': 'Tu App',
      'login': 'Iniciar Sesión',
      'register': 'Registrarse',
      'username': 'Usuario',
      'password': 'Contraseña',
      'email': 'Correo Electrónico',
      'age': 'Edad',
      'birthplace': 'Lugar de Nacimiento',
      'treatment': 'Trato',
      'treatment_mr': 'Sr.',
      'treatment_mrs': 'Sra.',
      'confirm_password': 'Repetir Contraseña',
      'terms_conditions': 'Términos y Condiciones',
      'forgot_password': '¿Olvidaste tu contraseña?',
      'send': 'Enviar',
      'password_recovery': 'Recuperar Contraseña',
      'enter_username': 'Ingresa tu usuario',
      'google_login': 'Acceder con Google',
      'take_photo': 'Tomar Foto',
      'load_image': 'Cargar Imagen',
      'home': 'Eventos',
      'orders': 'Pedidos',
      'profile': 'Yo',
      'welcome': 'Bienvenido',
      'logout': 'Cerrar Sesión',
      'exit_app': 'Salir de la Aplicación',
      'shopping': 'Eventos',
      'stock': 'Stock',
      'price': 'Precio',
      'quantity': 'Cantidad',
      'buy': 'Reservar',
      'no_products_selected': 'No has seleccionado ninguna entrada',
      'quantity_exceeds_stock': 'La cantidad supera el stock disponible',
      'purchase_successful': 'Reserva realizada con éxito',
      'order_number': 'Número de Pedido',
      'status': 'Estado',
      'pending': 'Reservada',
      'in_production': 'Pagada',
      'in_delivery': 'Cancelada',
      'delivered': 'Asistida',
      'order': 'Pedido',
      'edit': 'Editar',
      'delete': 'Eliminar',
      'block': 'Bloquear',
      'unblock': 'Desbloquear',
      'create': 'Crear',
      'add': 'Añadir',
      'contact': 'Contacto',
      'help': 'Ayuda',
      'phone': 'Teléfono',
      'website': 'Página Web',
      'google_maps': 'Google Maps',
      'user_management': 'Gestión de Usuarios',
      'product_management': 'Gestión de Eventos',
      'inventory_management': 'Gestión de Entradas',
      'order_management': 'Gestión de Pedidos',
      'administrator': 'Administrador',
      'client': 'Cliente',
      'description': 'Descripción',
      'total': 'Total',
      'date': 'Fecha',
      'place': 'Lugar',
      'artist': 'Artista',
      'event_details': 'Detalles del evento',
      'audio_controls': 'Controles de audio',
      'track': 'Pista',
      'volume': 'Volumen',
      'skip_forward': 'Avanzar 10s',
      'skip_backward': 'Retroceder 10s',
      'stop_audio': 'Detener audio',
      'play': 'Reproducir',
      'pause': 'Pausar',
      'view_details': 'Ver detalles',
      'personal_information': 'Información Personal',
      'not_available': 'N/D',
      'view_location': 'Ver ubicación en el mapa',
      'help_title': 'Ayuda',
      'help_description': 'Aquí encontrarás información sobre cómo usar la aplicación y cómo contactar con soporte.',
      'help_orders': 'Puedes ver tus pedidos y su estado desde la pestaña de Pedidos.',
      'help_profile': 'Modifica tu perfil y datos de contacto desde la sección de Yo.',
      'help_contact': 'Si necesitas ayuda adicional, usa la página de contacto para llamar o enviar correo.',
      'cancel': 'Cancelar',
      'confirm': 'Confirmar',
      'error': 'Error',
      'success': 'Éxito',
      'language': 'Idioma',
      'spanish': 'Español',
      'english': 'Inglés',
      'information': 'Información',
      'close_session_question': '¿Deseas cerrar sesión?',
      'exit_app_question': '¿Deseas salir de la aplicación?',
      'reservation_prefix': 'Reserva #',
      'reserved_tickets': 'Entradas reservadas:',
      'no_reservations_made': 'No tienes reservas realizadas',
      'type': 'Tipo',
      'unauthenticated_user_error': 'Error: Usuario no autenticado',
      'ready_to_book': 'listo para reservar',
      'name': 'Nombre',
      'optional_new_password': 'Nueva Contraseña (opcional)',
      'keep_current_password_hint': 'Dejar vacío para mantener la actual',
      'valid_age_range': 'Ingresa una edad válida (1-120)',
      'empty_name_error': 'El nombre no puede estar vacío',
      'madrid_spain': 'Madrid, España',
      'edit_profile': 'Editar Perfil',
      'profile_image': 'Imagen de perfil',
      'save_changes': 'Guardar cambios',
      'profile_updated': 'Perfil actualizado con éxito',
      'required_field': 'Este campo es requerido',
      'invalid_age': 'Ingresa una edad válida',
      'password_minimum': 'La contraseña debe tener al menos 4 caracteres',
      'contactInfo': 'Información de Contacto',
      'contactMessage': 'Si necesitas ayuda adicional, contacta con nuestro equipo de soporte.',
      'no_users': 'No hay usuarios',
      'role': 'Rol',
      'current_user': 'Usuario actual',
      'blocked_state': 'Bloqueado',
      'unblocked_state': 'Desbloqueado',
      'no_actions_available': 'Sin acciones disponibles',
      'image_url_or_asset': 'Imagen (URL o assets/...)',
      'delete_user_question': '¿Eliminar usuario',
      'cannot_edit_protected_user': 'No se puede editar un administrador o tu propio usuario',
      'cannot_delete_protected_user': 'No se puede eliminar un administrador o tu propio usuario',
      'cannot_block_protected_user': 'No se puede bloquear/desbloquear un administrador o tu propio usuario',
      'user_updated': 'Usuario actualizado',
      'user_deleted': 'Usuario eliminado',
      'user_created': 'Usuario creado',
      'type_festival': 'Festival',
      'type_concert': 'Concierto',
      'event_various_artists': 'Varios Artistas',
      'event_1_name': 'Rocanrola 2026',
      'event_1_description': 'El festival Rocanrola reúne a más de un centenar de artistas y referentes de la música urbana y el hip-hop en español.\n\nEl cartel del evento incluye destacadas actuaciones de:\n\n• Kase.O (con una actuación exclusiva en España)\n• Hijos de la Ruina\n• Nach\n• Delaossa\n• Fernandocosta\n• Hoke\n• Lia Kali\n• Hard GZ\n• Foyone',
      'event_1_place': 'Recinto Ferial IFEMA, Madrid',
      'event_2_name': 'Festival Coachella 2024',
      'event_2_description': 'Festival de música más importante del mundo con artistas internacionales.',
      'event_2_place': 'Empire Polo Club, Indio, California',
      'event_3_name': 'Concierto Taylor Swift - Eras Tour',
      'event_3_artist': 'Taylor Swift',
      'event_3_description': 'Show internacional con los éxitos más importantes de Taylor Swift.',
      'event_3_place': 'Wembley Stadium, Londres',
      'audio_track_1': 'Fragmento 1',
      'audio_track_2': 'Fragmento 2',
      'audio_track_3': 'Fragmento 3',
      'synopsis': 'Sinopsis',
      'view_information': 'Ver información',
    },
    'en': {
      'app_title': 'Your App',
      'login': 'Login',
      'register': 'Register',
      'username': 'Username',
      'password': 'Password',
      'email': 'Email',
      'age': 'Age',
      'birthplace': 'Place of Birth',
      'treatment': 'Treatment',
      'treatment_mr': 'Mr.',
      'treatment_mrs': 'Ms.',
      'confirm_password': 'Confirm Password',
      'terms_conditions': 'Terms and Conditions',
      'forgot_password': 'Forgot your password?',
      'send': 'Send',
      'password_recovery': 'Password Recovery',
      'enter_username': 'Enter your username',
      'google_login': 'Login with Google',
      'take_photo': 'Take Photo',
      'load_image': 'Load Image',
      'home': 'Events',
      'orders': 'Orders',
      'profile': 'Profile',
      'welcome': 'Welcome',
      'logout': 'Logout',
      'exit_app': 'Exit Application',
      'shopping': 'Events',
      'stock': 'Stock',
      'price': 'Price',
      'quantity': 'Quantity',
      'buy': 'Book',
      'no_products_selected': 'You haven\'t selected any ticket',
      'quantity_exceeds_stock': 'The quantity exceeds available stock',
      'purchase_successful': 'Booking completed successfully',
      'order_number': 'Order Number',
      'status': 'Status',
      'pending': 'Reserved',
      'in_production': 'Paid',
      'in_delivery': 'Cancelled',
      'delivered': 'Attended',
      'order': 'Order',
      'edit': 'Edit',
      'delete': 'Delete',
      'block': 'Block',
      'unblock': 'Unblock',
      'create': 'Create',
      'add': 'Add',
      'contact': 'Contact',
      'help': 'Help',
      'phone': 'Phone',
      'website': 'Website',
      'google_maps': 'Google Maps',
      'user_management': 'User Management',
      'product_management': 'Event Management',
      'inventory_management': 'Ticket Management',
      'order_management': 'Order Management',
      'administrator': 'Administrator',
      'client': 'Client',
      'description': 'Description',
      'total': 'Total',
      'date': 'Date',
      'place': 'Place',
      'artist': 'Artist',
      'event_details': 'Event Details',
      'audio_controls': 'Audio Controls',
      'track': 'Track',
      'volume': 'Volume',
      'skip_forward': 'Skip forward 10s',
      'skip_backward': 'Skip backward 10s',
      'stop_audio': 'Stop audio',
      'play': 'Play',
      'pause': 'Pause',
      'view_details': 'View details',
      'personal_information': 'Personal Information',
      'not_available': 'N/A',
      'view_location': 'View location on map',
      'help_title': 'Help',
      'help_description': 'Here you can find information on how to use the app and how to contact support.',
      'help_orders': 'View your orders and status from the Orders tab.',
      'help_profile': 'Edit your profile and contact details from the Profile section.',
      'help_contact': 'If you need extra help, use the contact page to call or email us.',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'error': 'Error',
      'success': 'Success',
      'language': 'Language',
      'spanish': 'Español',
      'english': 'English',
      'information': 'Information',
      'close_session_question': 'Do you want to log out?',
      'exit_app_question': 'Do you want to exit the application?',
      'reservation_prefix': 'Reservation #',
      'reserved_tickets': 'Reserved tickets:',
      'no_reservations_made': 'You have no reservations yet',
      'type': 'Type',
      'unauthenticated_user_error': 'Error: User not authenticated',
      'ready_to_book': 'ready to book',
      'name': 'Name',
      'optional_new_password': 'New Password (optional)',
      'keep_current_password_hint': 'Leave blank to keep the current one',
      'valid_age_range': 'Enter a valid age (1-120)',
      'empty_name_error': 'Name cannot be empty',
      'madrid_spain': 'Madrid, Spain',
      'edit_profile': 'Edit Profile',
      'profile_image': 'Profile Image',
      'save_changes': 'Save Changes',
      'profile_updated': 'Profile updated successfully',
      'required_field': 'This field is required',
      'invalid_age': 'Enter a valid age',
      'password_minimum': 'Password must be at least 4 characters',
      'contactInfo': 'Contact Information',
      'contactMessage': 'If you need additional help, contact our support team.',
      'no_users': 'No users',
      'role': 'Role',
      'current_user': 'Current user',
      'blocked_state': 'Blocked',
      'unblocked_state': 'Unblocked',
      'no_actions_available': 'No actions available',
      'image_url_or_asset': 'Image (URL or assets/...)',
      'delete_user_question': 'Delete user',
      'cannot_edit_protected_user': 'You cannot edit an administrator or your own user',
      'cannot_delete_protected_user': 'You cannot delete an administrator or your own user',
      'cannot_block_protected_user': 'You cannot block/unblock an administrator or your own user',
      'user_updated': 'User updated',
      'user_deleted': 'User deleted',
      'user_created': 'User created',
      'type_festival': 'Festival',
      'type_concert': 'Concert',
      'event_various_artists': 'Various Artists',
      'event_1_name': 'Rocanrola 2026',
      'event_1_description': 'Rocanrola Festival brings together over a hundred artists and icons of urban and Spanish hip-hop music.\n\nThe lineup features outstanding performances by:\n\n• Kase.O (exclusive show in Spain)\n• Hijos de la Ruina\n• Nach\n• Delaossa\n• Fernandocosta\n• Hoke\n• Lia Kali\n• Hard GZ\n• Foyone',
      'event_1_place': 'IFEMA Fairgrounds, Madrid',
      'event_2_name': 'Coachella Festival 2024',
      'event_2_description': 'One of the world\'s biggest music festivals with international artists.',
      'event_2_place': 'Empire Polo Club, Indio, California',
      'event_3_name': 'Taylor Swift Concert - Eras Tour',
      'event_3_artist': 'Taylor Swift',
      'event_3_description': 'An international show featuring Taylor Swift\'s biggest hits.',
      'event_3_place': 'Wembley Stadium, London',
      'audio_track_1': 'Track 1',
      'audio_track_2': 'Track 2',
      'audio_track_3': 'Track 3',
      'synopsis': 'Synopsis',
      'view_information': 'View information',
    },
  };

  String translate(String key) {
    return _localizedStrings[locale.languageCode]?[key] ?? key;
  }

  String get appTitle => translate('app_title');
  String get login => translate('login');
  String get register => translate('register');
  String get username => translate('username');
  String get password => translate('password');
  String get email => translate('email');
  String get age => translate('age');
  String get birthplace => translate('birthplace');
  String get treatment => translate('treatment');
  String get treatmentMr => translate('treatment_mr');
  String get treatmentMrs => translate('treatment_mrs');
  String get confirmPassword => translate('confirm_password');
  String get termsConditions => translate('terms_conditions');
  String get forgotPassword => translate('forgot_password');
  String get send => translate('send');
  String get passwordRecovery => translate('password_recovery');
  String get enterUsername => translate('enter_username');
  String get googleLogin => translate('google_login');
  String get takePhoto => translate('take_photo');
  String get loadImage => translate('load_image');
  String get home => translate('home');
  String get orders => translate('orders');
  String get profile => translate('profile');
  String get welcome => translate('welcome');
  String get logout => translate('logout');
  String get exitApp => translate('exit_app');
  String get shopping => translate('shopping');
  String get stock => translate('stock');
  String get price => translate('price');
  String get quantity => translate('quantity');
  String get buy => translate('buy');
  String get noProductsSelected => translate('no_products_selected');
  String get quantityExceedsStock => translate('quantity_exceeds_stock');
  String get purchaseSuccessful => translate('purchase_successful');
  String get orderNumber => translate('order_number');
  String get status => translate('status');
  String get pending => translate('pending');
  String get inProduction => translate('in_production');
  String get inDelivery => translate('in_delivery');
  String get delivered => translate('delivered');
  String get order => translate('order');
  String get edit => translate('edit');
  String get delete => translate('delete');
  String get personalInformation => translate('personal_information');
  String get notAvailable => translate('not_available');
  String get viewLocation => translate('view_location');
  String get block => translate('block');
  String get unblock => translate('unblock');
  String get create => translate('create');
  String get add => translate('add');
  String get contact => translate('contact');
  String get help => translate('help');
  String get helpTitle => translate('help_title');
  String get helpDescription => translate('help_description');
  String get helpOrders => translate('help_orders');
  String get helpProfile => translate('help_profile');
  String get helpContact => translate('help_contact');
  String get phone => translate('phone');
  String get website => translate('website');
  String get googleMaps => translate('google_maps');
  String get userManagement => translate('user_management');
  String get productManagement => translate('product_management');
  String get inventoryManagement => translate('inventory_management');
  String get orderManagement => translate('order_management');
  String get administrator => translate('administrator');
  String get client => translate('client');
  String get description => translate('description');
  String get total => translate('total');
  String get date => translate('date');
  String get place => translate('place');
  String get artist => translate('artist');
  String get eventDetails => translate('event_details');
  String get audioControls => translate('audio_controls');
  String get track => translate('track');
  String get volume => translate('volume');
  String get skipForward => translate('skip_forward');
  String get skipBackward => translate('skip_backward');
  String get stopAudio => translate('stop_audio');
  String get play => translate('play');
  String get pause => translate('pause');
  String get viewDetails => translate('view_details');
  String get cancel => translate('cancel');
  String get confirm => translate('confirm');
  String get error => translate('error');
  String get success => translate('success');
  String get language => translate('language');
  String get spanish => translate('spanish');
  String get english => translate('english');
  String get information => translate('information');
  String get closeSessionQuestion => translate('close_session_question');
  String get exitAppQuestion => translate('exit_app_question');
  String get reservationPrefix => translate('reservation_prefix');
  String get reservedTickets => translate('reserved_tickets');
  String get noReservationsMade => translate('no_reservations_made');
  String get type => translate('type');
  String get unauthenticatedUserError => translate('unauthenticated_user_error');
  String get readyToBook => translate('ready_to_book');
  String get name => translate('name');
  String get optionalNewPassword => translate('optional_new_password');
  String get keepCurrentPasswordHint => translate('keep_current_password_hint');
  String get validAgeRange => translate('valid_age_range');
  String get emptyNameError => translate('empty_name_error');
  String get madridSpain => translate('madrid_spain');
  String get editProfile => translate('edit_profile');
  String get profileImage => translate('profile_image');
  String get saveChanges => translate('save_changes');
  String get profileUpdated => translate('profile_updated');
  String get requiredField => translate('required_field');
  String get invalidAge => translate('invalid_age');
  String get passwordMinimum => translate('password_minimum');
  String get contactInfo => translate('contactInfo');
  String get contactMessage => translate('contactMessage');
  String get noUsers => translate('no_users');
  String get role => translate('role');
  String get currentUser => translate('current_user');
  String get blockedState => translate('blocked_state');
  String get unblockedState => translate('unblocked_state');
  String get noActionsAvailable => translate('no_actions_available');
  String get imageUrlOrAsset => translate('image_url_or_asset');
  String get deleteUserQuestion => translate('delete_user_question');
  String get cannotEditProtectedUser => translate('cannot_edit_protected_user');
  String get cannotDeleteProtectedUser => translate('cannot_delete_protected_user');
  String get cannotBlockProtectedUser => translate('cannot_block_protected_user');
  String get userUpdated => translate('user_updated');
  String get userDeleted => translate('user_deleted');
  String get userCreated => translate('user_created');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['es', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

