import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:olx/main.dart';
import 'package:olx/model/Anuncio.dart';

class ItemAnuncio extends StatelessWidget {
  final Anuncio anuncio;
  final VoidCallback? onTapItem;
  final VoidCallback? onPressedRemover;

  ItemAnuncio({required this.anuncio, this.onTapItem, this.onPressedRemover});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Remover',
            color: Colors.red[400],
            icon: Icons.delete,
            foregroundColor: Colors.white,
            onTap: this.onPressedRemover,
          ),
          IconSlideAction(
            caption: 'Editar',
            color: Colors.grey,
            icon: Icons.edit,
            foregroundColor: Colors.white,
            onTap: (){},
          ),
        ],
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            height: 100,
            child: Row(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    this.anuncio.fotos[0],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          color: temaPadrao.primaryColor,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        Text('Algum erro aconteceu!'),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          this.anuncio.titulo,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("R\$ ${this.anuncio.preco}"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
