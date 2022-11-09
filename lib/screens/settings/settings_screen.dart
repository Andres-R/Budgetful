import 'package:budgetful/screens/settings/delete_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetful/cubit/user_email_cubit.dart';
import 'package:budgetful/cubit/user_first_name_cubit.dart';
import 'package:budgetful/cubit/user_last_name_cubit.dart';
import 'package:budgetful/cubit/user_name_cubit.dart';
import 'package:budgetful/cubit/user_password_cubit.dart';
import 'package:budgetful/screens/login_screen.dart';
import 'package:budgetful/screens/settings/edit%20screens/edit_email_screen.dart';
import 'package:budgetful/screens/settings/edit%20screens/edit_first_name_screen.dart';
import 'package:budgetful/screens/settings/edit%20screens/edit_last_name_screen.dart';
import 'package:budgetful/screens/settings/edit%20screens/edit_password_screen.dart';
import 'package:budgetful/screens/settings/edit%20screens/edit_user_name_screen.dart';
import 'package:budgetful/utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final int userID;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late UserEmailCubit _userEmailCubit;
  late UserPasswordCubit _userPasswordCubit;
  late UserNameCubit _userNameCubit;
  late UserFirstNameCubit _userFirstNameCubit;
  late UserLastNameCubit _userLastNameCubit;

  @override
  void initState() {
    _userEmailCubit = UserEmailCubit(userID: widget.userID);
    _userPasswordCubit = UserPasswordCubit(userID: widget.userID);
    _userNameCubit = UserNameCubit(userID: widget.userID);
    _userFirstNameCubit = UserFirstNameCubit(userID: widget.userID);
    _userLastNameCubit = UserLastNameCubit(userID: widget.userID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserEmailCubit>(
          create: (context) => _userEmailCubit,
        ),
        BlocProvider<UserPasswordCubit>(
          create: (context) => _userPasswordCubit,
        ),
        BlocProvider<UserNameCubit>(
          create: (context) => _userNameCubit,
        ),
        BlocProvider<UserFirstNameCubit>(
          create: (context) => _userFirstNameCubit,
        ),
        BlocProvider<UserLastNameCubit>(
          create: (context) => _userLastNameCubit,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.only(right: kPadding),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'Log out',
                      style: TextStyle(
                        color: kThemeColor,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      Icons.logout,
                      color: kThemeColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
          centerTitle: true,
          elevation: 0,
          backgroundColor: kMainBGColor,
          automaticallyImplyLeading: false,
          title: Text(
            "Settings",
            style: TextStyle(
              color: kTextColor,
              fontSize: 22,
            ),
          ),
        ),
        body: Container(
          color: kMainBGColor,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(kPadding),
                  child: Container(
                    color: kMainBGColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BlocBuilder<UserFirstNameCubit, UserFirstNameState>(
                              builder: (_, fnameState) {
                                return BlocBuilder<UserLastNameCubit,
                                    UserLastNameState>(
                                  builder: (_, lnameState) {
                                    return areNamesLarge(
                                            fnameState.userFirstName,
                                            lnameState.userLastName)
                                        ? Column(
                                            children: [
                                              Text(
                                                fnameState.userFirstName,
                                                style: TextStyle(
                                                  color: kCurrencyColor,
                                                  fontSize: 22,
                                                ),
                                              ),
                                              Text(
                                                lnameState.userLastName,
                                                style: TextStyle(
                                                  color: kCurrencyColor,
                                                  fontSize: 22,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Text(
                                                fnameState.userFirstName,
                                                style: TextStyle(
                                                  color: kCurrencyColor,
                                                  fontSize: 22,
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                lnameState.userLastName,
                                                style: TextStyle(
                                                  color: kCurrencyColor,
                                                  fontSize: 22,
                                                ),
                                              ),
                                            ],
                                          );
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 5),
                            BlocBuilder<UserEmailCubit, UserEmailState>(
                              builder: (_, state) {
                                return Text(
                                  state.userEmail,
                                  style: TextStyle(
                                    color: kCurrencyColor,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(kPadding),
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: kDarkBGColor,
                      borderRadius:
                          BorderRadius.all(Radius.circular(kRadiusCurve)),
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return BlocProvider.value(
                                    value: _userEmailCubit,
                                    child: EditEmailScreen(
                                      userID: widget.userID,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: const SettingsOption(
                            title: 'Email',
                            icon: Icons.email,
                          ),
                        ),
                        const SettingsDivider(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return BlocProvider.value(
                                    value: _userNameCubit,
                                    child: EditUserNameScreen(
                                      userID: widget.userID,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: const SettingsOption(
                            title: 'Username',
                            icon: Icons.settings,
                          ),
                        ),
                        const SettingsDivider(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return BlocProvider.value(
                                    value: _userFirstNameCubit,
                                    child: EditFirstNameScreen(
                                      userID: widget.userID,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: const SettingsOption(
                            title: 'First name',
                            icon: Icons.person,
                          ),
                        ),
                        const SettingsDivider(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return BlocProvider.value(
                                    value: _userLastNameCubit,
                                    child: EditLastNameScreen(
                                      userID: widget.userID,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: const SettingsOption(
                            title: 'Last name',
                            icon: Icons.person,
                          ),
                        ),
                        const SettingsDivider(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return BlocProvider.value(
                                    value: _userPasswordCubit,
                                    child: EditPasswordScreen(
                                      userID: widget.userID,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: const SettingsOption(
                            title: 'Password',
                            icon: Icons.lock,
                          ),
                        ),
                        const SettingsDivider(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return DeleteAccountScreen(
                                    userID: widget.userID,
                                  );
                                },
                              ),
                            );
                          },
                          child: const SettingsOption(
                            title: 'Delete account',
                            icon: Icons.block,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsDivider extends StatelessWidget {
  const SettingsDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: kPadding),
      child: Divider(
        color: Colors.grey.shade800,
        height: 0,
        thickness: 1,
      ),
    );
  }
}

class SettingsOption extends StatelessWidget {
  const SettingsOption({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //color: kDarkBGColor,
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 0.0,
          horizontal: kPadding,
        ),
        child: Row(
          children: [
            Icon(icon, color: kThemeColor),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: kTextColor,
                fontSize: 18,
              ),
            ),
            Expanded(
              child: Container(
                height: 40,
                color: kDarkBGColor,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: kCurrencyColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

bool areNamesLarge(String fname, String lname) {
  bool firstNameLong = false;
  bool lastNameLong = false;
  if ((fname.length == nameCharLimit) ||
      ((fname.length + 1) == nameCharLimit) ||
      ((fname.length + 2) == nameCharLimit)) {
    firstNameLong = true;
  }
  if ((lname.length == nameCharLimit) ||
      ((lname.length + 1) == nameCharLimit) ||
      ((lname.length + 2) == nameCharLimit)) {
    lastNameLong = true;
  }

  return firstNameLong || lastNameLong;
}
