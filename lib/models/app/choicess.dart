import 'package:subrate/theme/assets_managet.dart';

class Choicess {
  bool clicked;
  int value;
  final String name;
  final String? subTitle;
  final String choiceImage;
  final int? type;

  Choicess(
      {required this.clicked,
      required this.name,
      this.type,
      this.subTitle,
      required this.value,
      required this.choiceImage});
}

List<Choicess> onBoadrdingChoices = [
  Choicess(
      name: "Let's Get Training",
      value: 1,
      clicked: false,
      choiceImage: pageSlider1,
      subTitle:
          "Our goal is to ensure that you have everything you need of learning, and training, and ready to make an impact."),
  Choicess(
      name: "Let’s Start Work",
      value: 2,
      clicked: false,
      choiceImage: pageSlider2,
      subTitle:
          "Our goal is to ensure that you have everything you need of learning, and training, and ready to make an impact."),
  Choicess(
      name: "Great! Earn your money",
      value: 3,
      clicked: false,
      choiceImage: pageSlider3,
      subTitle:
          "Our goal is to ensure that you have everything you need of learning, and training, and ready to make an impact."),
];
