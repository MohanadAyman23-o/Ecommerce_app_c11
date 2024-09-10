import 'package:e_commerce_app_c11/core/routes_manager/routes.dart';
import 'package:e_commerce_app_c11/domain/entities/product_response_entity.dart';
import 'package:e_commerce_app_c11/features/main_layout/screens/product_details_screen.dart';
import 'package:e_commerce_app_c11/features/main_layout/tabs/category/cubit/product_state.dart';
import 'package:e_commerce_app_c11/features/main_layout/tabs/category/cubit/products_screen_view_model.dart';
import 'package:e_commerce_app_c11/features/main_layout/widgets/custom_product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/font_manager.dart';
import '../../../../core/resources/image_assets.dart';
import '../../../../core/resources/style_manager.dart';

class ProductsTab extends StatelessWidget {
  ProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 45.w, left: 16.w),
                    child: SearchBar(
                      enabled: true,
                      side: const WidgetStatePropertyAll(
                        BorderSide(width: 0.5, color: ColorManager.primary),
                      ),
                      elevation: const WidgetStatePropertyAll(0),
                      hintText: 'what do you search for?',
                      hintStyle: WidgetStatePropertyAll(
                        getLightStyle(
                          fontSize: FontSize.s14,
                          color: const Color(0xff06004F),
                        ),
                      ),
                      backgroundColor:
                          const WidgetStatePropertyAll(ColorManager.white),
                      leading: Image.asset(IconAssets.icSearch),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.cartRoute);
                    },
                    child: Badge(
                      label: Text(ProductsScreenViewModel.get(context)
                          .numOfCartItems
                          .toString()),
                      child: ImageIcon(AssetImage(IconAssets.icCart)),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: SizedBox(
                height: 750.h,
                width: double.infinity,
                child: GridView.builder(
                  itemCount: BlocProvider.of<ProductsScreenViewModel>(context)
                      .productList
                      ?.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return BlocBuilder<ProductsScreenViewModel, ProductState>(
                      bloc: BlocProvider.of<ProductsScreenViewModel>(context)
                        ..getAllProducts(),
                      builder: (context, state) {
                        if (state is ProductLoadingState) {
                          return Skeletonizer(
                            enabled: true,
                            child: CustomProductItemWidget(
                              productEntity: ProductEntity(title: ''),
                            ),
                          );
                        } else if (state is ProductErrorState) {
                          return Center(
                            child: Text(state.errorMessage),
                          );
                        } else if (state is ProductSuccessState) {
                          return InkWell(
                            key: ValueKey(
                                state.productResponseEntity.data![index].id),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailsScreen(
                                    product: state
                                        .productResponseEntity.data![index],
                                  ),
                                ),
                              );
                            },
                            child: CustomProductItemWidget(
                              productEntity:
                                  state.productResponseEntity.data![index],
                            ),
                          );
                        }
                        return Container();
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
