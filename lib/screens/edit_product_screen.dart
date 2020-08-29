import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';
import '../provider/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product-screen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  String title;
  String imageUrl;
  String description;
  double price;
  bool initEdit = true;
  bool isUploading = false;
  Map<String, String> initialValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
    'id': null,
    'favorite': null,
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(updateImageUrl);
    _imageUrlFocusNode.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void updateImageUrl() {
    print('in update image url');
    if (_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveProduct() async {
    final isvalid = _form.currentState.validate();
    if (!isvalid) {
      return;
    }
    _form.currentState.save();

    String id = initialValues['id'];
    print('$id in edit product screen');
    bool favorite = initialValues['favorite'] == null ? false : true;
    // print('$price $description $title $imageUrl $id');
    setState(() {
      isUploading = true;
    });
    try {
      await Provider.of<Products>(context, listen: false).saveItem(
        Product(
          id: id,
          title: title,
          price: price,
          description: description,
          imageUrl: imageUrl,
          favorite: favorite,
        ),
      );
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Something went wrong'),
          content: Text('An error occured !!! ... please try again'),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Okay'),
            ),
          ],
        ),
      );
    } finally {
      setState(() => isUploading = false);
      Navigator.of(context).pop();
    }
  }

  @override
  void didChangeDependencies() {
    if (initEdit) {
      var productId = ModalRoute.of(context).settings.arguments;
      if (productId != null) {
        var product = Provider.of<Products>(context, listen: false).getItem(productId);
        initialValues['title'] = product.title;
        initialValues['description'] = product.description;
        _imageUrlController.text = product.imageUrl;
        initialValues['price'] = product.price.toString();
        initialValues['id'] = product.id;
        initialValues['favorite'] = product.favorite.toString();
      }
    }
    initEdit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveProduct(),
          ),
        ],
      ),
      body: Form(
        key: _form,
        child: isUploading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: initialValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a title';
                        }
                        if (value.length < 4) {
                          return 'Please enter a bigger title';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        title = value;
                      },
                    ),
                    TextFormField(
                      initialValue: initialValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (double.tryParse(value) == null) {
                          return 'Enter a number for price';
                        }
                        if (double.parse(value) < 1) {
                          return 'Enter a valid Price';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        price = double.parse(value);
                      },
                    ),
                    TextFormField(
                      minLines: 3,
                      maxLines: 3,
                      initialValue: initialValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      focusNode: _descriptionFocusNode,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value.length < 10) {
                          return 'Please enter a discription of more than 10 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        description = value;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 8.0),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.0,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text(
                                  'Enter the Url',
                                )
                              : Image.network(
                                  _imageUrlController.text,
                                ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'Image Url'),
                              keyboardType: TextInputType.url,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) => setState(() {}),
                              validator: (value) {
                                if ((!value.startsWith('http') && !value.startsWith('https') || (!value.endsWith('.png') && !value.endsWith('.jpg')))) {
                                  return 'Enter a valid image Url';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                imageUrl = value;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
