import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';
import 'package:flutter_news_new/common/colors.dart';
import 'package:flutter_news_new/common/common.dart';
import 'package:flutter_news_new/common/widgets/no_connectivity.dart';
import 'package:flutter_news_new/models/listdata_model.dart';
import 'package:flutter_news_new/models/news_model.dart' as m;
import 'package:flutter_news_new/providers/news_provider.dart';
import 'package:flutter_news_new/screens/home/widgets/CategoryItem.dart';
import 'package:flutter_news_new/screens/home/widgets/newsCard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> categories = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology',
  ];

  int activeCategory = 0;
  int page = 1;
  bool isFinish = false;
  bool isLoading = false;

  List<m.News> articles = [];

  @override
  void initState() {
    super.initState();
    _checkConnectivityAndLoad();
  }

  Future<void> _checkConnectivityAndLoad() async {
    final hasInternet = await getInternetStatus();

    if (!hasInternet && mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const NoConnectivity(),
        ),
      );
    }

    if (mounted) {
      _loadNews(reset: true);
    }
  }

  Future<bool> _loadNews({bool reset = false}) async {
    if (isLoading || isFinish) return false;

    isLoading = true;

    if (reset) {
      page = 1;
      articles.clear();
      isFinish = false;
    }

    final ListData listData = await NewsProvider()
        .GetEverything(categories[activeCategory], page);

    if (!listData.status) {
      isLoading = false;
      return false;
    }

    final List<m.News> items = listData.data as List<m.News>;

    if (items.isEmpty) {
      isFinish = true;
    } else {
      page++;
      articles.addAll(items);
    }

    isLoading = false;

    if (mounted) setState(() {});
    return true;
  }

  void _onCategoryChange(int index) {
    setState(() {
      activeCategory = index;
    });
    _loadNews(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Image.asset(
            "assets/images/logo.png",
            fit: BoxFit.contain,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.black,
        elevation: 5,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.search,
              size: 34,
              color: AppColors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          /// CATEGORIES
          SizedBox(
            height: 50,
            width: size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) => CategoryItem(
                index: index,
                categoryName: categories[index],
                activeCategory: activeCategory,
                onClick: () => _onCategoryChange(index),
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// NEWS LIST + LOAD MORE
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await _loadNews(reset: true);
              },
              child: LoadMore(
                isFinish: isFinish,
                onLoadMore: _loadNews,
                whenEmptyLoad: true,
                textBuilder: DefaultLoadMoreTextBuilder.english, // optional
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    return NewsCard(article: articles[index]);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
