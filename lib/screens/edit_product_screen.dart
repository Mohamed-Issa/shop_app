import 'package:flutter/material.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editProduct =
      Product(id: null, price: 0, title: '', description: '', imageUrl: '');

  var _isInit = true;
  var _isloading = false;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editProduct = Provider.of<Products>(context).findById(productId);
        _initValues = {
          'title': _editProduct.title,
          'description': _editProduct.description,
          'price': _editProduct.price.toString(),
//          'imageUrl': _editProduct.imageUrl,
          'imageUrl': ''
        };
        _imageUrlController.text = _editProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImageURL);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  void _updateImageURL() {
    if (!_imageFocusNode.hasFocus) {
      if (((!_imageUrlController.text.startsWith('http')) &&
              (!_imageUrlController.text.startsWith('https'))) ||
          ((!_imageUrlController.text.endsWith('.png')) &&
              (!_imageUrlController.text.endsWith('.jpeg')) &&
              (!_imageUrlController.text.endsWith('.jpg')))) return;
    }
    setState(() {});
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isloading = true;
    });
    if (_editProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editProduct.id, _editProduct);
      setState(() {
        _isloading = false;
      });
      Navigator.of(context).pop();
    } else {
      Provider.of<Products>(context, listen: false)
          .addProduct(_editProduct)
          .then((_) {
        setState(() {
          _isloading = false;
        });
        Navigator.of(context).pop();
      });
    }

//    print(_editProduct.title);
//    print(_editProduct.price);
//    print(_editProduct.description);
//    print(_editProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                            id: _editProduct.id,
                            isFavourite: _editProduct.isFavourite,
                            title: value,
                            description: _editProduct.description,
                            imageUrl: _editProduct.imageUrl,
                            price: _editProduct.price);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please provide a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'please enter a number greater than zero';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                            id: _editProduct.id,
                            isFavourite: _editProduct.isFavourite,
                            title: _editProduct.title,
                            description: _editProduct.description,
                            imageUrl: _editProduct.imageUrl,
                            price: double.parse(value));
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _editProduct = Product(
                            id: _editProduct.id,
                            isFavourite: _editProduct.isFavourite,
                            title: _editProduct.title,
                            description: value,
                            imageUrl: _editProduct.imageUrl,
                            price: _editProduct.price);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please enter a description.';
                        }
                        if (value.length < 10) {
                          return 'should be  at least 10 characters long.';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URl')
                              : FittedBox(
                                  child:
                                      Image.network(_imageUrlController.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'please enter an image URL.';
                              }
                              if ((!value.startsWith('http')) &&
                                  (!value.startsWith('https'))) {
                                return 'please enter a valid URL';
                              }
                              if ((!value.endsWith('.png')) &&
                                  (!value.endsWith('.jpeg')) &&
                                  (!value.endsWith('.jpg'))) {
                                return 'please enter a valid URL';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editProduct = Product(
                                  id: _editProduct.id,
                                  isFavourite: _editProduct.isFavourite,
                                  title: _editProduct.title,
                                  description: _editProduct.description,
                                  imageUrl: value,
                                  price: _editProduct.price);
                            },
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
