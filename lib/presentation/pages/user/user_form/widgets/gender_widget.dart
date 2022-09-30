import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../domain/user/gender/gender.dart';

class GenderWidget extends StatelessWidget {
  final List<Gender> genders;
  final Gender? selected;
  final Function onSelect;
  final String title;
  const GenderWidget({
    Key? key,
    required this.genders,
    this.selected,
    required this.onSelect,
    required this.title,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _dropdownGender = genders
        .map((eachGender) => _buildGenderDropdownListItem(eachGender, context))
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(
          width: 1.sw,
          child: DropdownButton(
            hint: Text(
              "Selecionar",
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: Colors.black,
                  ),
            ),
            items: _dropdownGender,
            value: selected,
            // ignore: unnecessary_lambdas
            onChanged: (gender) => onSelect(gender),
          ),
        )
      ],
    );
  }

  DropdownMenuItem<Gender> _buildGenderDropdownListItem(
    Gender gender,
    BuildContext context,
  ) {
    return DropdownMenuItem<Gender>(
      value: gender,
      child: Text(
        gender.description,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
              color: Colors.black,
            ),
      ),
    );
  }
}
