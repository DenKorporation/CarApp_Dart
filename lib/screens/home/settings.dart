import 'package:car_app/models/user.dart';
import 'package:car_app/screens/home/favourites.dart';
import 'package:car_app/screens/home/home.dart';
import 'package:car_app/screens/wrapper.dart';
import 'package:car_app/services/authentication_service.dart';
import 'package:car_app/services/database_service.dart';
import 'package:car_app/shared/constants.dart';
import 'package:car_app/shared/loading.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthenticationService();

  final _carCoutnries = [
    'US',
    'DE',
    'GB',
    'FR',
    'IT',
    'ES',
    'CZ',
    'SE',
    'RU',
    'CN',
    'JP',
    'KR'
  ];
  final _carBodyTypes = [
    '',
    'Седан',
    'Хэтчбек',
    'Универсал',
    'Купе',
    'Кабриолет ',
    'Внедорожник',
    'Кроссовер',
    'Минивэн',
    'Пикап',
    'Лифтбек',
    'Лимузин',
    'Фургон'
  ];
  final _carDriverTypes = ['', 'FWD', 'RWD', 'AWD', '4WD', 'EV'];
  final _transmissionTypes = [
    '',
    'Механическая',
    'Автоматическая',
    'Роботизированная',
    'Вариатор',
    'Полуавтоматическая',
    'Двухсцепной робот'
  ];
  final _genders = ['Мужчина', 'Женщина'];
  int _selectedGenderRadio = 0;

  void _setSelectedRadio(int? value) {
    setState(() {
      _selectedGenderRadio = value!;
      _gender = _genders[_selectedGenderRadio];
    });
  }

  String? _firstname;
  String? _lastname;
  String? _gender;
  String? _address;
  DateTime? _birthday;
  String? _phoneNumber;
  String _phoneCountry = '375';
  bool _phoneChanged = false;
  String? _carCountry;
  String? _carBody;
  String? _carDrive;
  String? _transmission;

  @override
  Widget build(BuildContext context) {
    Future selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );
      if (picked != null) {
        setState(() => _birthday = picked);
      }
    }

    final user = Provider.of<User?>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user?.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data!;
            _gender = _gender ?? userData.gender;
            if (_gender == _genders[0]) {
              _selectedGenderRadio = 0;
            } else {
              _selectedGenderRadio = 1;
            }

            return Scaffold(
              backgroundColor: backgroundColor,
              appBar: AppBar(
                leading: SvgPicture.asset('assets/car_logo.svg'),
                title: const Text('Профиль'),
                titleTextStyle:
                    const TextStyle(color: Colors.white, fontSize: 18),
                automaticallyImplyLeading: false,
                backgroundColor: primaryColor,
                actionsIconTheme: const IconThemeData(),
                elevation: 0.0,
                actions: <Widget>[
                  PopupMenuButton<MenuItem>(
                    color: primaryColor,
                    iconColor: secondaryColor,
                    onSelected: (MenuItem item) {
                      switch (item) {
                        case MenuItem.Home:
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home()));
                          break;
                        case MenuItem.Logout:
                          _auth.signOut();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Wrapper()));
                          break;
                        case MenuItem.Settings:
                          // TODO: Handle this case.
                          break;
                        case MenuItem.Favourites:
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Favourites()));
                          break;
                      }
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.menu, color: secondaryColor),
                        SizedBox(width: 10),
                        Text('Меню', style: TextStyle(color: secondaryColor)),
                        SizedBox(width: 20)
                      ],
                    ),
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<MenuItem>>[
                      const PopupMenuItem<MenuItem>(
                        value: MenuItem.Favourites,
                        child: Row(
                          children: [
                            Icon(Icons.favorite, color: secondaryColor),
                            Text('Избранное',
                                style: TextStyle(color: secondaryColor)),
                          ],
                        ),
                      ),
                      const PopupMenuItem<MenuItem>(
                        value: MenuItem.Home,
                        child: Row(
                          children: [
                            Icon(Icons.list, color: secondaryColor),
                            Text('Список',
                                style: TextStyle(color: secondaryColor)),
                          ],
                        ),
                      ),
                      const PopupMenuItem<MenuItem>(
                        value: MenuItem.Logout,
                        child: Row(
                          children: [
                            Icon(Icons.door_front_door_outlined,
                                color: secondaryColor),
                            Text('Выйти',
                                style: TextStyle(color: secondaryColor)),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(color: backgroundColor),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Данные пользователя',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Имя',
                              border: OutlineInputBorder(),
                            ),
                            initialValue: userData.firstname,
                            keyboardType: TextInputType.name,
                            onChanged: (value) {
                              setState(() => _firstname = value);
                            },
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Фамилия',
                              border: OutlineInputBorder(),
                            ),
                            initialValue: userData.lastname,
                            keyboardType: TextInputType.name,
                            onChanged: (value) {
                              setState(() => _lastname = value);
                            },
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            children: [
                              Text(
                                'Дата рождения: ',
                                style: TextStyle(fontSize: 17),
                              ),
                              TextButton(
                                child: Row(
                                  children: [
                                    Text(
                                        DateFormat('dd.MM.yyyy').format(
                                            _birthday ?? userData.birthday),
                                        style: TextStyle(
                                            fontSize: 17, color: primaryColor)),
                                    Icon(
                                      Icons.calendar_month,
                                      color: primaryColor,
                                    )
                                  ],
                                ),
                                onPressed: () => selectDate(context),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Адрес',
                              border: OutlineInputBorder(),
                            ),
                            initialValue: userData.address,
                            keyboardType: TextInputType.streetAddress,
                            onChanged: (value) {
                              setState(() => _address = value);
                            },
                          ),
                          SizedBox(height: 20.0),
                          IntlPhoneField(
                            decoration: InputDecoration(
                              labelText: 'Номер телефона',
                              border: OutlineInputBorder(),
                            ),
                            dropdownTextStyle: TextStyle(fontSize: 17),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            disableLengthCheck: true,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            initialValue: userData.phone.isEmpty
                                ? '+375'
                                : userData.phone,
                            validator: (value) {
                              if (value == null || value.number.isEmpty) {
                                return null;
                              }
                              if (value.number.length < 7 ||
                                  value.number.length > 14) {
                                return 'Некорректный номер телефона';
                              }
                              return null;
                            },
                            onChanged: (phone) => setState(() {
                              _phoneNumber = phone.number;
                              _phoneChanged = true;
                            }),
                            onCountryChanged: (country) {
                              setState(() {
                                _phoneCountry = country.dialCode;
                                _phoneChanged = true;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Center(
                            child: Text(
                              'Пол: ',
                              style:
                              TextStyle(color: textColor, fontSize: 17),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RadioMenuButton<int>(
                                child: Text('Мужчина',
                                    style: TextStyle(
                                        color: textColor, fontSize: 17)),
                                value: 0,
                                groupValue: _selectedGenderRadio,
                                onChanged: _setSelectedRadio,
                              ),
                              RadioMenuButton<int>(
                                child: Text('Женщина',
                                    style: TextStyle(
                                        color: textColor, fontSize: 17)),
                                value: 1,
                                groupValue: _selectedGenderRadio,
                                onChanged: _setSelectedRadio,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Center(
                            child: Text(
                              'Предпочтения',
                              style: TextStyle(color: textColor, fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              Text(
                                'Страна\nпроизводства:',
                                style:
                                    TextStyle(color: textColor, fontSize: 17),
                              ),
                              Expanded(
                                child: CountryCodePicker(
                                  onChanged: (value) =>
                                      setState(() => _carCountry = value.code),
                                  initialSelection:
                                      userData.carCountry.isNotEmpty
                                          ? userData.carCountry
                                          : 'DE',
                                  countryFilter: _carCoutnries,
                                  showCountryOnly: true,
                                  showOnlyCountryWhenClosed: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(
                                  'Тип кузова:',
                                  style:
                                      TextStyle(color: textColor, fontSize: 17),
                                ),
                              ),
                              Expanded(
                                child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                    ),
                                    value: _carBody ?? userData.carBody,
                                    items: _carBodyTypes.map((body) {
                                      return DropdownMenuItem(
                                          value: body,
                                          child: body == ''
                                              ? Text('Нет предочтений')
                                              : Text(body));
                                    }).toList(),
                                    onChanged: (value) =>
                                        setState(() => _carBody = value)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(
                                  'Тип привода:',
                                  style:
                                      TextStyle(color: textColor, fontSize: 17),
                                ),
                              ),
                              Expanded(
                                child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                    ),
                                    value: _carDrive ?? userData.carDrive,
                                    items: _carDriverTypes.map((body) {
                                      return DropdownMenuItem(
                                          value: body,
                                          child: body == ''
                                              ? Text('Нет предочтений')
                                              : Text(body));
                                    }).toList(),
                                    onChanged: (value) =>
                                        setState(() => _carDrive = value)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(
                                  'Коробка\nпередач:',
                                  style:
                                      TextStyle(color: textColor, fontSize: 17),
                                ),
                              ),
                              Expanded(
                                child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                    ),
                                    value:
                                        _transmission ?? userData.transmission,
                                    items:
                                        _transmissionTypes.map((transmission) {
                                      return DropdownMenuItem(
                                          value: transmission,
                                          child: transmission == ''
                                              ? Text('Нет предочтений')
                                              : Text(transmission));
                                    }).toList(),
                                    onChanged: (value) =>
                                        setState(() => _transmission = value)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor),
                                  child: Text(
                                    'Обновить',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await DatabaseService(uid: user?.uid)
                                          .updateUserData(
                                              _firstname ?? userData.firstname,
                                              _lastname ?? userData.lastname,
                                              _birthday ?? userData.birthday,
                                              _gender ?? userData.gender,
                                              _address ?? userData.address,
                                              (!_phoneChanged)
                                                  ? userData.phone
                                                  : (_phoneNumber!.isEmpty
                                                      ? ''
                                                      : '+' +
                                                          _phoneCountry +
                                                          _phoneNumber!),
                                              _carCountry ??
                                                  userData.carCountry,
                                              _carBody ?? userData.carBody,
                                              _carDrive ?? userData.carDrive,
                                              _transmission ??
                                                  userData.transmission);

                                      Navigator.pop(context);
                                    }
                                  }),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: accentColor),
                                  child: Text(
                                    'Удалить аккаунт',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    await _auth.deleteAccount();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Wrapper()));
                                  }),
                            ],
                          ),
                        ],
                      )),
                ),
              ),
            );
          } else {
            return const Loading();
          }
        });
  }
}
