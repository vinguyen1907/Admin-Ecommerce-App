import 'package:admin_ecommerce_app/blocs/category_screen_bloc/category_screen_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/custom_loading_widget.dart';
import 'package:admin_ecommerce_app/common_widgets/my_elevated_button.dart';
import 'package:admin_ecommerce_app/common_widgets/paginator.dart';
import 'package:admin_ecommerce_app/common_widgets/primary_background.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_name_section.dart';
import 'package:admin_ecommerce_app/common_widgets/search_widget.dart';
import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_dimensions.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:admin_ecommerce_app/screens/add_category_screen/add_category_screen.dart';
import 'package:admin_ecommerce_app/screens/category_screen/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  static const String routeName = "/category-screen";

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    context.read<CategoryScreenBloc>().add(const LoadCategories());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryScreenBloc, CategoryScreenState>(
      builder: (context, state) {
        if (state is CategoryScreenLoading) {
          return const CustomLoadingWidget();
        } else if (state is CategoryScreenError) {
          return Center(
            child: Text(state.message),
          );
        } else {
          final isLoading =
              state is SearchingCategory || state is LoadingCategories;
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
                        const ScreenNameSection("Categories",
                            hasDefaultBackButton: true),
                        MyElevatedButton(
                            onPressed: () async {
                              Navigator.pushNamed(
                                  context, AddCategoryScreen.routeName);
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
                            SearchWidget(
                              controller: _searchController,
                              onQuery: _onQuery,
                              onClear: _onClear,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(
                                color: AppColors.greyColor,
                                height: 1,
                              ),
                            ),
                            isLoading
                                ? const CustomLoadingWidget()
                                : GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio:
                                                Responsive.isDesktop(context)
                                                    ? 1 / 1.6
                                                    : 1 / 1.9,
                                            mainAxisSpacing: 20,
                                            crossAxisSpacing:
                                                Responsive.isDesktop(context)
                                                    ? 20
                                                    : 10,
                                            crossAxisCount: Responsive.isMobile(
                                                    context)
                                                ? 2
                                                : Responsive.isTablet(context)
                                                    ? 4
                                                    : 5),
                                    itemCount: Responsive.isMobile(context)
                                        ? state.categories.length
                                        : 10,
                                    itemBuilder: (context, index) {
                                      if (index < state.categories.length) {
                                        return CategoryItem(
                                          category: state.categories[index],
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  ),
                            Paginator(
                                currentPageIndex: state.currentPageIndex,
                                onPreviousPage: () => _onLoadPreviousPage(),
                                onNextPage: () => _onLoadNextPage())
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  _onLoadNextPage() {
    context.read<CategoryScreenBloc>().add(const LoadNextPage());
  }

  _onLoadPreviousPage() {
    context.read<CategoryScreenBloc>().add(const LoadPreviousPage());
  }

  _onQuery() {
    String query = _searchController.text.trim();
    context.read<CategoryScreenBloc>().add(SearchCategory(query: query));
  }

  _onClear() {
    _searchController.clear();
    context.read<CategoryScreenBloc>().add(const SearchCategory(query: ''));
  }
}
