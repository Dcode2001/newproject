import 'dart:convert';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../first.dart';

class loadimage extends StatefulWidget {
  const loadimage({Key? key}) : super(key: key);

  @override
  State<loadimage> createState() => _loadimageState();
}

class _loadimageState extends State<loadimage> {
  bool status = false;
  Map<String, dynamic> m = {};
  Acess? d;

  @override
  void initState() {
    super.initState();

    getAllData();
  }

  getAllData() async {
    var url = Uri.parse('https://dummyjson.com/products');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    m = jsonDecode(response.body);

    d = Acess.fromJson(m);

    setState(() {
      status = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: status
              ? GridView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                        height: 200,
                        width: 150,
                        margin: EdgeInsets.all(5),
                        color: Colors.grey,
                        child: InkWell(
                            onTap: () {
                              Navigator.push(context, PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return NextPage(d!.products![index]);
                                },
                              ));
                            },
                            child: Stack(
                              children: [
                                Container(
                                  height: 200,
                                  width: 200,
                                  margin: EdgeInsets.only(bottom: 40),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          "${d!.products![index].thumbnail}"),
                                    ),
                                  ),
                                ),
                                Container(
                                    height: 60,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 148),
                                    decoration: BoxDecoration(
                                      color: Colors.purple.shade100,
                                    ),
                                    child: Text(
                                      "Model : ${d!.products![index].title}\nPrice : ${d!.products![index].price}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13),
                                      textAlign: TextAlign.center,
                                    )),
                              ],
                            )));
                  },
                  itemCount: d!.products!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                    mainAxisSpacing: 1,
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
        onWillPop: back);
  }

  Future<bool> back() {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return first();
      },
    ));
    return Future.value();
  }
}

class Acess {
  List<Products>? products;
  int? total;
  int? skip;
  int? limit;

  Acess({this.products, this.total, this.skip, this.limit});

  Acess.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['skip'] = this.skip;
    data['limit'] = this.limit;
    return data;
  }
}

class Products {
  int? id;
  String? title;
  String? description;
  int? price;
  double? discountPercentage;
  double? rating;
  int? stock;
  String? brand;
  String? category;
  String? thumbnail;
  List<String>? images;

  Products(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.discountPercentage,
      this.rating,
      this.stock,
      this.brand,
      this.category,
      this.thumbnail,
      this.images});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    discountPercentage = json['discountPercentage'];
    rating = double.parse(json['rating'].toString());
    stock = json['stock'];
    brand = json['brand'];
    category = json['category'];
    thumbnail = json['thumbnail'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['price'] = this.price;
    data['discountPercentage'] = this.discountPercentage;
    data['rating'] = this.rating;
    data['stock'] = this.stock;
    data['brand'] = this.brand;
    data['category'] = this.category;
    data['thumbnail'] = this.thumbnail;
    data['images'] = this.images;
    return data;
  }
}

class NextPage extends StatefulWidget {
  Products products;

  NextPage(this.products);

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Text(
                "${widget.products.description}",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade200,
                ),
                height: MediaQuery.of(context).size.height / 2.5,
                width: double.infinity,
                margin: EdgeInsets.all(10),
                child: PageView.builder(
                  itemCount: widget.products.images!.length,
                  controller: _pageController,
                  itemBuilder: (context, index) {
                    return Image.network(
                      "${widget.products.images![index]}",
                      fit: BoxFit.fill,
                    );
                  },
                ),
              ),

              SmoothPageIndicator
                (
                  controller: _pageController,  // PageController
                  count:  widget.products.images!.length,
                  effect:  WormEffect(),  // your preferred effect
              ),
              SizedBox(height: 20),
              Text(
                "Title : ${widget.products.title}",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text(
                "Price : ${widget.products.price}",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text(
                "Brand : ${widget.products.brand}",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text(
                "Category : ${widget.products.category}",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text(
                "Rating : ${widget.products.rating}",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*


class Next extends StatefulWidget {
  Products products;

  Next(this.products);

  @override
  State<Next> createState() => _NextState();
}

class _NextState extends State<Next> {
  PageController pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  width: double.infinity,
                  child: PageView.builder(
                    itemCount: widget.products.images!.length,
                    controller: pageController,
                    itemBuilder: (context, index) {
                      return Image.network(
                        "${widget.products.images![index]}",
                        fit: BoxFit.fill,
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.products.title}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("  \$${widget.products.price}"
                                " (${widget.products.discountPercentage} \%off)"),
                            Text(
                              "Rating :${widget.products.rating}",
                            )
                          ],
                        ),
                        Text(
                          "description : ${widget.products.description}",
                        ),
                        Text(
                          "stock : ${widget.products.stock}",
                        ),
                        Text(
                          "brand : ${widget.products.brand}",
                        ),
                        Text(
                          "category : ${widget.products.category}",
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
        onWillPop: goback);
  }

  Future<bool> goback() {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return first();
      },
    ));
    return Future.value();
  }
}*/
