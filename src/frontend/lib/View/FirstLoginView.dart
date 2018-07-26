import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Model/ContextData.dart';
import 'MapSkillsView.dart';

class FirstLoginView extends StatefulWidget {
  ContextData context;

  FirstLoginView(this.context, {Key key}) : super(key: key);

  @override
  createState() => new FirstLoginState(context);
}

class FirstLoginState extends State<FirstLoginView>{

  ContextData contextData;

  FirstLoginState(this.contextData);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return new MaterialApp(
      title: 'Welcome to Flutter',
      home: new Scaffold(
          body: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.fromLTRB(36.0, height * 0.176, 36.0, height * 0.0625),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      child: new Image.asset('assets/logo.png'),
                      padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, height * 0.075),
                    ),
                    new Container(
                      margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, height * 0.0375),
                      child: new Text(
                        'Olá ' + contextData.user.name,
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          color: new Color(0xff616161),
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                    new Container(
                        margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, height * 0.0375),
                        child: new Text(
                          'Informe quais habilidades você possui e quais você ainda '
                              'não tem domínio, mas tem interesse em aprender.',
                          style: new TextStyle(
                            color: new Color(0xff616161),
                            fontSize: 16.0,
                          ),
                        )
                    ),
                    new Container(
                      margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, height * 0.0375),
                      child: new Text('Reserve 5 minutos para iniciar o mapeamento das suas '
                          'skills.',
                        style: new TextStyle(
                          color: new Color(4284572001),
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    new Container(
                      margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, height * 0.075),
                      child: new Text('É importante manter seu perfil sempre atualizado.',
                        style: new TextStyle(
                          color: new Color(4284572001),
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    new Container(
                        height: 48.0,
                        width: 272.0,
                        child: new RaisedButton.icon(
                          icon: new Icon(Icons.arrow_forward, color:const Color(0xff5e529d) ,),
                          color: Colors.white,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(36.0),
                              side: new BorderSide(
                                color: const Color(0xff5e529d),
                                width: 1.0,
                              )
                          ),
                          label: new Text(
                            'VAMOS COMEÇAR?',
                            style: new TextStyle(
                                color: const Color(0xff5e529d), fontSize: 16.0
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new MapSkillsView(contextData)));
                          },
                        )
                    ),
                  ],
                ),
              )
            ],
          )


      ),
    );
  }
}
