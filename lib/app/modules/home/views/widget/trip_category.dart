import "package:flutter/material.dart";
import "package:get/get.dart";

import "../../../../helpers/theme.dart";
import "category_list.dart";

class TripCategoryWidget extends StatefulWidget {
  final void Function(String selectedCategory) onHandleChange;
  String selectedCategory;

  TripCategoryWidget({super.key, required this.onHandleChange, required this.selectedCategory});

  @override
  State<TripCategoryWidget> createState() => _TripCategoryWidgetState();
}

class _TripCategoryWidgetState extends State<TripCategoryWidget> {

  void handleSelectedCategory(String selectedCategoryValue) {
    // Do something with the selected category in this class
    setState(() {
      widget.selectedCategory = selectedCategoryValue;
    });

    widget.onHandleChange(selectedCategoryValue);

    print("Selected Category: ${widget.selectedCategory}");
  }

  Widget button(String name, double opacity) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      child: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(
                vertical: 12), // Set the desired padding values
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(5), // Set the desired border radius
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
              textButtonSecondaryColor.withOpacity(opacity)),
          minimumSize:
          MaterialStateProperty.all<Size>(Size(double.infinity, 0)),
        ),
        child: Text(
          name,
          style: buttonPrimaryTextStyle.copyWith(
              fontSize: 22, fontWeight: semibold),
        ),
      ),
    );
  }

  Widget bottomSheetWidget(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text("Choose Trip Category", style: primaryTextStylePlusJakartaSans.copyWith(
                  fontWeight: FontWeight.bold, fontSize: 18
              ),),
              Spacer(),
              IconButton(
                  onPressed: () => Get.back(),
                  splashRadius: 25,
                  icon: Icon(Icons.keyboard_arrow_up, size: 25, color: textHintColor,))
            ],
          ),
          CategoryList(onCategorySelected: handleSelectedCategory, selectedValue: widget.selectedCategory,),
          Spacer(),
          button("Continue", 1)
        ],
      ),
    );
  }

  Widget tripCategory(){
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          bottomSheetWidget()
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Category *",
              style: primaryTextStylePlusJakartaSans.copyWith(
                fontSize: 12,
                fontWeight: semibold,
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 5),
                width: Get.size.width * 0.4,
                height: 40,
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: containerPostColor,
                ),
                child: Row(
                  children: [
                    Text(widget.selectedCategory == 'ALAM' ? 'Alam'
                        : widget.selectedCategory == 'SEJARAH' ? 'Sejarah'
                        : widget.selectedCategory == 'BUDAYA' ? "Budaya"
                        : "Choose",
                      style: primaryTextStylePlusJakartaSans.copyWith(
                      fontSize: 12,
                    ),),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_down, size: 25, color: textHintColor,)
                  ],
                ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return tripCategory();
  }
}
