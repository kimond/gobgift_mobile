import 'package:flutter/material.dart';
import 'package:gobgift_mobile/src/models/gift.dart';

class _GridTitleText extends StatelessWidget {
  const _GridTitleText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return new FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: new Text(text),
    );
  }
}

class GiftGridItem extends StatelessWidget {
  final Gift gift;

  GiftGridItem({Key key, this.gift}) : super(key: key);

  void openGiftPage(BuildContext context) {
    Navigator.push(context,
        new MaterialPageRoute<Null>(builder: (BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(title: new Text(gift.name)),
        body: new SizedBox.expand(
          child: new Hero(
            tag: gift.name,
            child: new Text('hey'),
          ),
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    final Widget image = new GestureDetector(
      onTap: () {
        openGiftPage(context);
      },
      child: new Hero(
        key: new Key('${gift.id}'),
        tag: gift.id,
        child: new Image.asset('lib/assets/giftplaceholder.png',
            fit: BoxFit.cover),
      ),
    );

    return new GridTile(
      footer: new GestureDetector(
        onTap: () {
          openGiftPage(context);
        },
        child: new GridTileBar(
          backgroundColor: Colors.black45,
          title: new _GridTitleText(gift.name),
          subtitle: new _GridTitleText(gift.description??''),
          trailing: new Icon(
            Icons.shopping_cart,
            color: Colors.white,
          ),
        ),
      ),
      child: image,
    );
  }
}

class GiftGrid extends StatelessWidget {
  final List<Gift> gifts;

  GiftGrid({this.gifts});

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return new Column(children: <Widget>[
      new Expanded(
          child: new GridView.count(
        crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        padding: const EdgeInsets.all(8.0),
        childAspectRatio: (orientation == Orientation.portrait) ? 1.0 : 1.3,
        children:
            gifts.map((Gift gift) => new GiftGridItem(gift: gift)).toList(),
      ))
    ]);
  }
}
