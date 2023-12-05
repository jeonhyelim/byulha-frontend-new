import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taba/domain/auth/login/login_provider.dart';
import 'package:taba/routes/router_provider.dart';

import '../../../main.dart';
import '../../../modules/orb/components/components.dart';

enum Gender { male, female }

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  createState() => _SignUpScreen();
}

class _SignUpScreen extends ConsumerState<SignUpScreen> {
  late final TextEditingController nicknameController;
  late final TextEditingController smsCodeController;
  late final TextEditingController nameController;
  late final TextEditingController ageController;
  late final TextEditingController phoneNumberController;
  late final TextEditingController passwordController;
  late final TextEditingController passwordConfirmController;
  late final GlobalKey<FormState> formKey;
  late List<bool> _isChecked;

  @override
  void initState() {
    // TODO: implement initState
    nicknameController = TextEditingController();
    nameController = TextEditingController();
    ageController = TextEditingController();
    phoneNumberController = TextEditingController();
    smsCodeController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
    formKey = GlobalKey<FormState>();
    _isChecked = [true, false];
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nicknameController.dispose();
    super.dispose();
  }

  void toggleSelect(value) {
    setState(() {
      _isChecked = [false, false];
      _isChecked[value] = !_isChecked[value];
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final ThemeData themeData = Theme.of(context);
    return OrbScaffold(
      body: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '회원가입',
              style: themeData.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            OrbTextFormField(
              controller: nameController,
              labelText: '이름',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '이름을 입력해주세요';
                }
                return null;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: OrbTextFormField(
                    controller: nicknameController,
                    labelText: '닉네임',
                    textInputAction: TextInputAction.next,
                    helperText: "",
                    maxLength: 20,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '닉네임을 입력해주세요';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                OrbButton(
                  buttonSize: OrbButtonSize.compact,
                  buttonRadius: OrbButtonRadius.small,
                  enabledBackgroundColor: themeData.colorScheme.secondary,
                  enabledForegroundColor: themeData.colorScheme.onSecondary,
                  onPressed: () async {
                    final loginNotifier = ref.read(loginProvider.notifier);
                    if (nicknameController.text.isEmpty) {
                      return;
                    }
                    await loginNotifier.verifyNickname(
                        nickname: nicknameController.text);
                    if (loginNotifier.validNickname.isNotEmpty) {
                      if (!context.mounted) return;
                      await OrbDialog(
                        title: '닉네임 중복확인',
                        message: '선택한 닉네임을 사용할 수 있어요!',
                        rightButtonText: '닫기',
                        onLeftButtonPressed: () async {},
                        onRightButtonPressed: () async {},
                      ).show(context);
                    }
                  },
                  buttonText: '중복확인',
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OrbTextFormField(
                    controller: ageController,
                    labelText: '나이',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '나이를 입력해주세요';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                ToggleButtons(
                  isSelected: _isChecked,
                  onPressed: toggleSelect,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('남자'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('여자'),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OrbTextFormField(
                    controller: phoneNumberController,
                    maxLength: 11,
                    labelText: '휴대폰 번호',
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.phone,
                    readOnly: false,
                    autofocus: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '휴대폰 번호를 입력해주세요';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                OrbButton(
                  showCoolDownTime: true,
                  buttonCoolDown: const Duration(seconds: 30),
                  buttonSize: OrbButtonSize.compact,
                  buttonRadius: OrbButtonRadius.small,
                  enabledBackgroundColor: themeData.colorScheme.surfaceVariant,
                  enabledForegroundColor: themeData.colorScheme.onSurface,
                  onPressed: () async {
                    await ref
                        .read(loginProvider.notifier)
                        .sendSMS(phoneNumber: phoneNumberController.text)
                    .then((value){
                      if (value){
                        OrbSnackBar.show(
                          context: globalNavigatorKey.currentContext!,
                          message: "인증번호가 전송되었습니다.",
                          type: OrbSnackBarType.info,
                        );
                      }
                    });
                  },
                  buttonText: '인증 번호 전송',
                  buttonTextStyle: themeData.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OrbTextFormField(
                    controller: smsCodeController,
                    labelText: '인증번호(6자리 숫자)',
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '인증번호를 입력해주세요';
                      }
                      return null;
                    },
                  ),
                ),
                OrbButton(
                  buttonSize: OrbButtonSize.compact,
                  buttonRadius: OrbButtonRadius.small,
                  enabledBackgroundColor: themeData.colorScheme.surfaceVariant,
                  enabledForegroundColor: themeData.colorScheme.onSurface,
                  onPressed: () async {
                    await ref
                        .read(loginProvider.notifier)
                        .verifySMS(code: smsCodeController.text).then((value){
                          if (value){
                            OrbSnackBar.show(
                              context: globalNavigatorKey.currentContext!,
                              message: "인증되었습니다.",
                              type: OrbSnackBarType.info,
                            );
                          }
                    });
                  },
                  buttonText: '인증하기',
                  buttonTextStyle: themeData.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            OrbTextFormField(
              controller: passwordController,
              labelText: '비밀번호',
              textInputAction: TextInputAction.next,
              maxLength: 20,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '비밀번호를 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            OrbTextFormField(
              controller: passwordConfirmController,
              labelText: '비밀번호 확인',
              textInputAction: TextInputAction.done,
              maxLength: 20,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '비밀번호를 입력해주세요';
                }
                if (value != passwordController.text) {
                  return '비밀번호가 일치하지 않습니다';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      submitButton: OrbButton(
        onPressed: () async {
          if (!formKey.currentState!.validate()) {
            return;
          }
          final setNickname = await ref
              .read(loginProvider.notifier)
              .setNickname(nickname: nicknameController.text);

          if(!setNickname) return;

          await ref
              .read(loginProvider.notifier)
              .signUp(
                nickname: nicknameController.text,
                name: nameController.text,
                gender: _isChecked.first
                    ? Gender.male.name.toUpperCase()
                    : Gender.female.name.toUpperCase(),
                age: ageController.text,
                phone: phoneNumberController.text,
                password: passwordController.text,
              )
              .then((value) {
            if (value) {
              ref.read(routerProvider).pop();
              OrbSnackBar.show(
                context: globalNavigatorKey.currentContext!,
                message: "회원가입을 축하합니다 !",
                type: OrbSnackBarType.info,
              );
            }
          });
        },
        buttonText: '회원가입',
      ),
    );
  }
}
