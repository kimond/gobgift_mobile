import 'package:flutter/material.dart';
import 'package:gobgift_mobile/src/models/gift.dart';
import 'package:gobgift_mobile/src/pages/gift_page.dart';
import 'package:gobgift_mobile/src/services/config.dart';

class _GridTitleText extends StatelessWidget {
  final String text;

  const _GridTitleText(this.text);

  @override
  Widget build(BuildContext context) {
    return new FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: new Text(
        text,
        style: new TextStyle(color: Colors.grey.shade500),
      ),
    );
  }
}

class GiftGridItem extends StatelessWidget {
  final Gift gift;

  GiftGridItem({Key key, this.gift}) : super(key: key);

  void openGiftPage(BuildContext context) {
    Navigator.push(
      context,
      new MaterialPageRoute<Null>(
        builder: (BuildContext context) => new Hero(
              tag: gift.id,
              child: new GiftPage(gift: gift),
            ),
      ),
    );
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
        child: gift.photo != null
            ? new Image.network(
                gift.photo,
                fit: BoxFit.cover,
              )
            : new Image.asset('lib/assets/giftplaceholder.png',
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
          subtitle: new Text(gift.description ?? ''),
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
