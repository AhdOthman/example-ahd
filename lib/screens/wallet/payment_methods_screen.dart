import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/api_url.dart';
import 'package:subrate/models/wallet/dynamic_form_model.dart';
import 'package:subrate/models/wallet/dynamic_payment_request.dart';
import 'package:subrate/provider/authprovider.dart';
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

class PaymentMethodsScreen extends StatefulWidget {
  static const routeName = '/payment-methods-screen';
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  // List<Choicess> paymentMethods = [
  //   Choicess(
  //       clicked: false,
  //       name: LocaleKeys.bank.tr(),
  //       value: 1,
  //       choiceImage: bankCard),
  //   Choicess(
  //       clicked: false,
  //       name: LocaleKeys.paypal.tr(),
  //       value: 1,
  //       choiceImage: paypal),
  //   Choicess(
  //       clicked: false,
  //       name: LocaleKeys.bank.tr(),
  //       value: 1,
  //       choiceImage: paypal)
  // ];
  String? paymentValue;
  clickedItem(int index) {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    setState(() {
      paymentValue = walletProvider.payoutMethodList[index].payoutMethodId;
      formData.clear();

      _fetcheAllData = walletProvider.getPayoutMethodDetails(
          payoutMethodId: paymentValue ?? '');

      walletProvider.payoutMethodList.map((e) => e.isClicked = false).toList();
      // weekDays[index].isSelected = false ? true : false;
      walletProvider.payoutMethodList[index].isClicked =
          !walletProvider.payoutMethodList[index].isClicked;
    });
  }

  TextEditingController fullNameController = TextEditingController();
  Future _getPayoutMethod() async {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    return await walletProvider.getPayoutMethod();
  }

  final Map<String, dynamic> formData = {};

  @override
  void initState() {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    walletProvider.paymentDetailsList.clear();
    _fetcheAllData = _getPayoutMethod();

    super.initState();
  }

  late Future _fetcheAllData;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthProvider>(context);
    final walletProvider = Provider.of<WalletProvider>(context);
    return Scaffold(
      backgroundColor: innerBackgroundColor,
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
                      LocaleKeys.payment_methods.tr(),
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
                                child: Text('Please Select Tenant'),
                              )
                            : Center(
                                child: TextWidget(snapshot.data.toString()));
                      }
                      final provider = Provider.of<WalletProvider>(context);

                      var getPayoutMethod = provider.payoutMethodList;
                      return getPayoutMethod.isNotEmpty
                          ? SizedBox(
                              height: sizeh * .11,
                              child: ListView.builder(
                                  itemCount: getPayoutMethod.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        clickedItem(index);
                                      },
                                      child: buildPaymentMethodCard(
                                          sizeh, sizew,
                                          clicked:
                                              getPayoutMethod[index].isClicked,
                                          name: getPayoutMethod[index]
                                                  .payoutMethod
                                                  ?.name ??
                                              '',
                                          choiceImage:
                                              '$downloadPhoto${getPayoutMethod[index].payoutMethod?.image}'),
                                    );
                                  }),
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
                SizedBox(
                  height: sizeh * .02,
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
                                Center(
                                  child: ButtonWidget(
                                    radius: 5,
                                    textStyle: AppTextStyles.regular.copyWith(
                                        fontSize: 12.5.sp, color: Colors.white),
                                    height: sizeh * .05,
                                    width: sizew * .45,
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
                                                        payoutMethodId:
                                                            paymentValue ?? '',
                                                        fields: fields))
                                            .then((value) {
                                          Navigator.pop(context);
                                          if (value == true) {
                                            Navigator.pop(context);
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

  Widget buildPaymentMethodCard(double sizeh, double sizew,
      {required bool clicked,
      required String name,
      required String choiceImage}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: sizew * .01),
      padding:
          EdgeInsets.symmetric(horizontal: sizew * .02, vertical: sizeh * .01),
      width: sizew * .28,
      height: sizew * .26,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: clicked
                ? Colors.grey.withOpacity(0.2)
                : Colors.transparent, // Shadow color with transparency
            spreadRadius: 1, // How much the shadow spreads
            blurRadius: 8, // The blur intensity
            offset: Offset(0, 2), // Offset in the x and y direction
          ),
        ],
        color: clicked ? Colors.white : innerBackgroundColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color: clicked ? yallewTextColor : Colors.transparent, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            choiceImage,
            height: sizeh * .035,
          ),
          SizedBox(
            height: sizeh * .01,
          ),
          Text(
            name,
            style: AppTextStyles.regular
                .copyWith(fontSize: 9.sp, color: Colors.black),
          )
        ],
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
    _controller = TextEditingController(text: value?.toString() ?? "");
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
