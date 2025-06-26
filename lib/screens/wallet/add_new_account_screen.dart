import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/models/wallet/dynamic_form_model.dart';
import 'package:subrate/models/wallet/dynamic_payment_request.dart';
import 'package:subrate/provider/authprovider.dart';
import 'package:subrate/provider/profileprovider.dart';
import 'package:subrate/provider/walletprovider.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/failure.dart';
import 'package:subrate/theme/text_style.dart';
import 'package:subrate/theme/ui_helper.dart';
import 'package:subrate/translations/locale_keys.g.dart';
import 'package:subrate/widgets/app/button.dart';
import 'package:subrate/widgets/app/loadingdialog.dart';
import 'package:subrate/widgets/app/text_widget.dart';
import 'package:subrate/widgets/app/textfield.dart';

class AddNewAccountScreen extends StatefulWidget {
  static const routeName = '/add-new-account-screen';
  const AddNewAccountScreen({super.key});

  @override
  State<AddNewAccountScreen> createState() => _AddNewAccountScreenState();
}

class _AddNewAccountScreenState extends State<AddNewAccountScreen> {
  late Future _fetcheAllData;
  final Map<String, dynamic> formData = {};
  final formKey = GlobalKey<FormState>();
  var _isInit = true;
  @override
  void didChangeDependencies() {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    if (_isInit) {
      formData.clear();

      final argumets =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _fetcheAllData = walletProvider.getPayoutMethodDetails(
          payoutMethodId: argumets['id'] ?? '');

      // homeProvider.getRecentlyProducts(page: 1);
      // homeProvider.getHomeData();
    }
    _isInit = false;

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    final profileProvider = Provider.of<Profileprovider>(context);
    final argumets =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final authProvider = Provider.of<AuthProvider>(context);
    final walletProvider = Provider.of<WalletProvider>(context);
    return Scaffold(
      body: Form(
        key: formKey,
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: sizew * .035, vertical: sizeh * .015),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: sizeh * .07,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: sizew * .01, vertical: sizeh * .005),
                        child: Icon(Icons.arrow_back, color: yallewTextColor),
                      ),
                    ),
                    SizedBox(
                      width: sizew * .02,
                    ),
                    Text(
                      LocaleKeys.manage_your_accounts.tr(),
                      style: AppTextStyles.semiBold
                          .copyWith(fontSize: 16.sp, color: primaryColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: sizeh * .035,
                ),
                FutureBuilder(
                  future: _fetcheAllData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: sizeh * .5,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    if (snapshot.hasData) {
                      if (snapshot.data is Failure) {
                        return authProvider.tenantID == null
                            ? Center(
                                child: Text(''),
                              )
                            : Center(
                                child: TextWidget(snapshot.data.toString()));
                      }
                      final provider = Provider.of<WalletProvider>(context);

                      var getDynamicFormList = provider.paymentDetailsList;
                      return getDynamicFormList.isNotEmpty
                          ? Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemCount: getDynamicFormList.length,
                                  itemBuilder: (context, index) {
                                    final field = getDynamicFormList[index];

                                    // Initialize formData with default values if not already set
                                    if (formData[field.name ?? ''] == null) {
                                      formData[field.name ?? ''] = field.value;
                                    }

                                    return DynamicFormField(
                                      key: ValueKey(field.name),
                                      apiData: field,
                                      onChanged: (newValue) {
                                        setState(() {
                                          formData[field.name ?? ''] = newValue;
                                        });
                                      },
                                    );
                                  },
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ButtonWidget(
                                    radius: 5,
                                    textStyle: AppTextStyles.regular.copyWith(
                                        fontSize: 13.sp,
                                        color: Colors.white,
                                        fontFamily: 'Inter'),
                                    height: sizeh * .042,
                                    width: sizew * .42,
                                    text: LocaleKeys.save.tr(),
                                    onPress: () {
                                      final isVaild =
                                          formKey.currentState!.validate();
                                      if (isVaild) {
                                        loadingDialog(context);
                                        List<Fields> fields =
                                            formData.entries.map((entry) {
                                          return Fields(
                                              fieldName: entry.key,
                                              fieldValue: entry.value);
                                        }).toList();

                                        walletProvider
                                            .addPaymentMethod(
                                                paymentDetailsRequest:
                                                    PaymentDetailsRequest(
                                                        accountName:
                                                            '${profileProvider.profileModel?.firstName} ${profileProvider.profileModel?.lastName}',
                                                        payoutMethodId:
                                                            argumets['id'],
                                                        fields: fields))
                                            .then((value) {
                                          Navigator.pop(context);
                                          if (value == true) {
                                            Navigator.pop(context);
                                            walletProvider.getAccountsForMethod(
                                                id: argumets['id']);
                                            UIHelper.showNotification(
                                                LocaleKeys
                                                    .payment_added_sucseefuly
                                                    .tr(),
                                                backgroundColor: Colors.green);
                                          }
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(
                              height: 60.h,
                              child: Center(
                                child: Text('Empty'),
                              ),
                            );
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DynamicFormField extends StatefulWidget {
  final DynamicFormModel apiData;
  final ValueChanged<dynamic>? onChanged;

  DynamicFormField({required this.apiData, this.onChanged, Key? key})
      : super(key: key);

  @override
  _DynamicFormFieldState createState() => _DynamicFormFieldState();
}

class _DynamicFormFieldState extends State<DynamicFormField> {
  late dynamic value; // Dynamic value to store input
  late TextEditingController _controller;

  // Date format for the DatePicker
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    value = widget.apiData.value;
    _controller = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.apiData.name;
    final type = widget.apiData.type;
    final isRequired = widget.apiData.isRequired;

    switch (type) {
      case 'TEXT':
      case 'NUMBER':
      case 'EMAIL':
        return _buildTextField(name ?? '', type ?? '', isRequired ?? false);
      case 'DATE':
        return _buildDateField(name ?? '', isRequired ?? false);
      case 'BOOLEAN':
        return _buildRadioField(name ?? '', isRequired ?? false);
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildTextField(String name, String type, bool isRequired) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: CustomField(
        hint: AppTextStyles.regular.copyWith(
            fontSize: 9.sp, fontFamily: 'Inter', color: HexColor('#8F94A3')),
        isCustomField: true,
        isPhone: type == 'NUMBER' ? true : false,
        title: name,
        hintText: "$name",
        keyboardType:
            type == 'NUMBER' ? TextInputType.number : TextInputType.text,
        controller: _controller,
        hintSize: 14.0,
        onChange: (newValue) {
          value = newValue;
          if (widget.onChanged != null) {
            widget.onChanged!(newValue);
          }
        },
      ),
    );
  }

  Widget _buildDateField(String name, bool isRequired) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: () async {
          DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (selectedDate != null) {
            setState(() {
              value = selectedDate;
              _controller.text =
                  formatter.format(value); // Format date to 'yyyy-MM-dd'
            });
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          }
        },
        child: AbsorbPointer(
          child: CustomField(
            title: name,
            hintText: "Select $name",
            controller: _controller,
            hintSize: 14.0,
          ),
        ),
      ),
    );
  }

  Widget _buildRadioField(String name, bool isRequired) {
    value = value ?? false; // Default to `false` if null
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Row(
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: value,
                    onChanged: (newValue) {
                      setState(() {
                        value = newValue;
                      });
                      if (widget.onChanged != null) {
                        widget.onChanged!(value);
                      }
                    },
                  ),
                  Text('Yes'),
                ],
              ),
              Row(
                children: [
                  Radio<bool>(
                    value: false,
                    groupValue: value,
                    onChanged: (newValue) {
                      setState(() {
                        value = newValue;
                      });
                      if (widget.onChanged != null) {
                        widget.onChanged!(value);
                      }
                    },
                  ),
                  Text('No'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
