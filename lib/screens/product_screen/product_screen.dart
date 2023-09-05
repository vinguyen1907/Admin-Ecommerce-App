import 'package:admin_ecommerce_app/blocs/product_screen_bloc/product_screen_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/custom_loading_widget.dart';
import 'package:admin_ecommerce_app/common_widgets/my_elevated_button.dart';
import 'package:admin_ecommerce_app/common_widgets/my_text_field.dart';
import 'package:admin_ecommerce_app/common_widgets/primary_background.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_name_section.dart';
import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_dimensions.dart';
import 'package:admin_ecommerce_app/constants/firebase_constants.dart';
import 'package:admin_ecommerce_app/models/category.dart';
import 'package:admin_ecommerce_app/repositories/product_repository.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:admin_ecommerce_app/screens/product_screen/widgets/add_product_dialog.dart';
import 'package:admin_ecommerce_app/screens/product_screen/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_pagination/number_pagination.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  static const String routeName = "/product-screen";

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    context.read<ProductScreenBloc>().add(const LoadProducts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductScreenBloc, ProductScreenState>(
      builder: (context, state) {
        if (state is ProductScreenLoading) {
          return const CustomLoadingWidget();
        } else if (state is ProductScreenLoaded) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Responsive.isDesktop(context)
                        ? AppDimensions.defaultHorizontalContentPadding
                        : 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const ScreenNameSection("Product"),
                        MyElevatedButton(
                            onPressed: () async {
                              // await ProductRepository().updateProduct();
                              // Navigator.pushNamed(
                              //     context, AddProductScreen.routeName);
                              await productsRef
                                  .where('keyword', arrayContains: 'k')
                                  .limit(8)
                                  .get()
                                  .then((value) {
                                value.docs.forEach((element) {
                                  print(element['name']);
                                });

                                // firstDocument = value.docs.first;
                                // lastDocument = value.docs.last;
                                // products.addAll(value.docs
                                //     .map((e) => Product.fromMap(e.data() as Map<String, dynamic>)));
                              });
                            },
                            widget: const Text('Add New'))
                      ],
                    ),
                    PrimaryBackground(
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Responsive.isDesktop(context)
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        child: MyTextField(
                                          controller: _searchController,
                                          hintText: 'Search',
                                          suffixIcon: IconButton(
                                            onPressed: () => _onQuery(),
                                            icon: const Icon(Icons.search),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        constraints:
                                            const BoxConstraints(minHeight: 38),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                width: 1,
                                                color: AppColors.greyColor)),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<Category>(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            iconSize: 20,
                                            isDense: true,
                                            value: state.categorySelected,
                                            icon: const Icon(
                                                Icons.arrow_drop_down_sharp),
                                            elevation: 10,
                                            style: const TextStyle(
                                                color: AppColors.primaryColor),
                                            items: state.categories.map<
                                                    DropdownMenuItem<Category>>(
                                                (Category value) {
                                              return DropdownMenuItem<Category>(
                                                value: value,
                                                child: Text(value.name),
                                              );
                                            }).toList(),
                                            onChanged: _onCategoryChange,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : Column(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        child: MyTextField(
                                          controller: _searchController,
                                          hintText: 'Search',
                                          suffixIcon: IconButton(
                                            onPressed: () => _onQuery(),
                                            icon: const Icon(Icons.search),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Container(
                                        constraints:
                                            const BoxConstraints(minHeight: 38),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                width: 1,
                                                color: AppColors.greyColor)),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<Category>(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            iconSize: 20,
                                            isDense: true,
                                            value: state.categorySelected,
                                            icon: const Icon(
                                                Icons.arrow_drop_down_sharp),
                                            elevation: 10,
                                            style: const TextStyle(
                                                color: AppColors.primaryColor),
                                            items: state.categories.map<
                                                    DropdownMenuItem<Category>>(
                                                (Category value) {
                                              return DropdownMenuItem<Category>(
                                                value: value,
                                                child: Text(value.name),
                                              );
                                            }).toList(),
                                            onChanged: _onCategoryChange,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(
                                color: AppColors.greyColor,
                                height: 1,
                              ),
                            ),
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio:
                                          Responsive.isDesktop(context)
                                              ? 1 / 1.6
                                              : 1 / 2,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing:
                                          Responsive.isDesktop(context)
                                              ? 20
                                              : 10,
                                      crossAxisCount:
                                          Responsive.isMobile(context) ? 2 : 4),
                              itemCount: Responsive.isMobile(context)
                                  ? state.products.length
                                  : 8,
                              itemBuilder: (context, index) {
                                if (index < state.products.length) {
                                  return ProductItem(
                                    product: state.products[index],
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    //
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: SizedBox(
                    //     // width: size.width * 0.23,
                    //     child: NumberPagination(
                    //       threshold: 4,
                    //       controlButton: const SizedBox(),
                    //       onPageChanged: _onPageChange,
                    //       pageTotal: state.numberPages,
                    //       pageInit: state.pageSelected +
                    //           1, // picked number when init page
                    //       colorPrimary: AppColors.primaryColor,
                    //       colorSub: AppColors.whiteColor,
                    //     ),
                    //   ),
                    // )
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {}, icon: Icon(Icons.chevron_left)),
                        IconButton(
                            onPressed: () {}, icon: Icon(Icons.chevron_right)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  _onPageChange(int index) {
    // context.read<ProductScreenBloc>().add(ChangePage(pageSelected: index - 1));
  }

  _onCategoryChange(Category? category) {
    context
        .read<ProductScreenBloc>()
        .add(ChangeCategory(categorySelected: category!));
    _searchController.clear();
  }

  _onQuery() {
    String query = _searchController.text.trim();
    context.read<ProductScreenBloc>().add(SearchProduct(query: query));
  }
}
