import 'package:employee_data_app/features/employee/screens/add_employee_screen.dart';
import 'package:employee_data_app/gen/assets.gen.dart';
import 'package:employee_data_app/gen/colors.gen.dart';
import 'package:employee_data_app/shared/constants/string_constants.dart';
import 'package:employee_data_app/shared/fonts/font_constant.dart';
import 'package:employee_data_app/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import '../../../gen/fonts.gen.dart';
import '../../../shared/fonts/size_config.dart';
import '../../../shared/services/storage_services.dart';
import '../../../shared/text_widgets/build_text.dart';
import '../../employee/entity/employee_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.put(EmployeeStorageService());

  double height = 0.0;
  double width = 0.0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    height = SizeConfig.safeBlockVertical!;
    width = SizeConfig.safeBlockHorizontal!;
    return SafeArea(
        child: Scaffold(
      backgroundColor: ColorName.colorWhite,
      appBar: appbarWidget(),
      body: _createBody(),
      floatingActionButton: AppButton(
        color: ColorName.colorPrimary,
        icon: const Icon(Icons.add),
        onTap: () {
          Get.to(() => const AddEmployeeScreen());
        },
      ),
    ));
  }

  AppBar appbarWidget() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: ColorName.colorPrimary,
      elevation: 0,
      title: Column(
        children: [
          Row(
            children: [
              BuildText(
                text: StringConstants.employeeList,
                family: FontFamily.robotoMedium,
                fontSize: 10.0.medium18px(),
                color: ColorName.colorWhite,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _createBody() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: height * 2.5),
            ValueListenableBuilder(
              valueListenable: controller.employeeList,
              builder: (context, employess, _) => employess.isEmpty ? imageWidget() : addedEmpoyeeList(),
            ),
            SizedBox(height: height * 20),
          ],
        ),
      ),
    );
  }

  Widget imageWidget() {
    return Center(
      child: Assets.images.homeImg.image(),
    );
  }

  Widget addedEmpoyeeList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildText(
          text: 'Current employes',
          family: FontFamily.robotoMedium,
          fontSize: 10.0.medium16px(),
          color: ColorName.colorPrimary,
        ),
        SizedBox(height: height * 1.5),
        employeeList(controller.employeeList.value.where((e) => e.toDate.isEmpty).toList()),
        BuildText(
          text: 'Previous employes',
          family: FontFamily.robotoMedium,
          fontSize: 10.0.medium16px(),
          color: ColorName.colorPrimary,
        ),
        SizedBox(height: height * 1.5),
        employeeList(controller.employeeList.value.where((e) => e.toDate.isNotEmpty).toList()),
      ],
    );
  }

  Widget employeeList(List<EmployeeModel> list) {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, index) {
        return const SizedBox();
      },
      itemCount: list.length,
      itemBuilder: (context, index) {
        final data = list[index];
        return Slidable(
          endActionPane: ActionPane(motion: const ScrollMotion(), children: [
            SlidableAction(
              onPressed: (context) {
                controller.deleteEmployee(index);
              },
              backgroundColor: ColorName.delectColor,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
            SlidableAction(
              onPressed: (context) {
                Get.to(() => AddEmployeeScreen(index: index, model: data));
              },
              backgroundColor: ColorName.colorPrimary,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
          ]),
          child: SizedBox(
            height: 104,
            width: 428,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildText(
                  text: data.name,
                  family: FontFamily.robotoMedium,
                  fontSize: 10.0.medium16px(),
                  color: Colors.black,
                ),
                SizedBox(height: height * 1.5),
                BuildText(
                  text: data.role,
                  family: FontFamily.robotoRegular,
                  fontSize: 10.0.small14px(),
                  color: ColorName.colorSecondary,
                ),
                SizedBox(height: height * 1.5),
                Row(
                  children: [
                    BuildText(
                      text: data.fromDate,
                      family: FontFamily.robotoRegular,
                      fontSize: 10.0.small14px(),
                      color: ColorName.colorSecondary,
                    ),
                    SizedBox(width: width * 3),
                    BuildText(
                      text: data.toDate,
                      family: FontFamily.robotoRegular,
                      fontSize: 10.0.small14px(),
                      color: ColorName.colorSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
