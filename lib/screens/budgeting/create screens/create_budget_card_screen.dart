import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetful/cubit/budget_card_cubit.dart';
import 'package:budgetful/utils/box_decorations/create_button_box_decoration.dart';
import 'package:budgetful/utils/capitalize_first_letter.dart';
import 'package:budgetful/utils/constants.dart';
import 'package:budgetful/utils/dialogs/custom_error_dialog.dart';
import 'package:budgetful/utils/remove_commas.dart';
import 'package:budgetful/utils/text_form_fields/custom_text_form_field.dart';

class CreateBudgetCardScreen extends StatefulWidget {
  const CreateBudgetCardScreen({
    Key? key,
    required this.userID,
    required this.screenID,
  }) : super(key: key);

  final int userID;
  final int screenID;

  @override
  State<CreateBudgetCardScreen> createState() => _CreateBudgetCardScreenState();
}

class _CreateBudgetCardScreenState extends State<CreateBudgetCardScreen> {
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();

  void createBudgetCard() {
    String budget = _budgetController.text;
    String limit = _limitController.text;

    if (budget.isEmpty) {
      showCustomErrorDialog(context, "Please enter a budget name");
    } else if (limit.isEmpty) {
      showCustomErrorDialog(context, "Please enter a budget limit");
    } else if (limit[0] == '-') {
      showCustomErrorDialog(context, "Budget limit cannot be negative");
    } else if (budget.length > budgetCharLimit) {
      showCustomErrorDialog(
          context, "Budget name cannot exceed $budgetCharLimit characters");
    } else if (limit.length > budgetLimit) {
      showCustomErrorDialog(context, "Budget limit cannot exceed \$999,999.99");
    } else {
      String finalBudget = capitalizeFirstLetter(budget);
      double finalLimit = double.parse(removeCommas(limit));

      // changes budgetCardHasBeenEdited to true
      BlocProvider.of<BudgetCardCubit>(context).addBudgetCard(
          finalBudget, finalLimit, 0.0, widget.userID, widget.screenID);

      // changes budgetCardHasBeenEdited back to false
      BlocProvider.of<BudgetCardCubit>(context).updateBudgetCards();

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kMainBGColor,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          "Create budget",
          style: TextStyle(
            color: kTextColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: kMainBGColor,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: SizedBox(
                  //height: 150,
                  //color: kDarkBGColor,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '1. Enter a budget name.',
                            style: TextStyle(
                              color: kCurrencyColor,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '2. Enter spending limit for the budget.',
                            style: TextStyle(
                              color: kCurrencyColor,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'After creating this budget, you will be able to keep track of expenses relating to this budget.',
                        style: TextStyle(
                          color: kTextColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: CustomTextFormField(
                  controller: _budgetController,
                  hint: "Enter budget name",
                  icon: Icons.text_snippet,
                  obscureText: false,
                  inputType: TextInputType.text,
                  enableCurrencyMode: false,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: CustomTextFormField(
                  controller: _limitController,
                  hint: "Enter budget limit",
                  icon: Icons.money,
                  obscureText: false,
                  inputType: const TextInputType.numberWithOptions(),
                  enableCurrencyMode: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: GestureDetector(
                  onTap: createBudgetCard,
                  child: const CreateButtonBoxDecoration(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
