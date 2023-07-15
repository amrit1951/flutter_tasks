import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Provider/products_provider.dart';
import 'package:shop_app/views/product_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    productProvider.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ShopTime",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              print('Selected filter: $value');
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: "men's clothing",
                child: Text("Men's Clothing"),
              ),
              const PopupMenuItem(
                value: "womwn's clothing",
                child: Text("Women's Clothing"),
              ),
              const PopupMenuItem(
                value: "jewelery",
                child: Text('Jewelery'),
              ),
              const PopupMenuItem(
                value: 'eletronics',
                child: Text('Electronics'),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
          builder: (context, value, _) => MasonryGridView.count(
                crossAxisCount: 2,
                itemCount: value.products.length,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ProductDetails(
                              productModel: value.products[index]))),
                      child: Card(
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 180,
                                    width: double.infinity,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: value.products[index].image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // Positioned(child: Obx(()=>CircleAvatar(backgroundColor: Colors.white, child: IconButton(icon: product.,),)))
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                value.products[index].title,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontFamily: 'avenir',
                                    fontWeight: FontWeight.w800),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              if (value.products[index].rating.rate != null)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        value.products[index].rating.rate
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      const Icon(
                                        Icons.star,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('\$${value.products[index].price}',
                                      style: const TextStyle(
                                          fontSize: 32, fontFamily: 'avenir')),
                                  GestureDetector(
                                    onTap: () => value.delete(index),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ));
                },
              )),
    );
  }
}
