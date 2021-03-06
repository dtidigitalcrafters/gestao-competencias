import 'package:flutter/material.dart';

import '../View/HomeAppView.dart';
import '../Model/ContextData.dart';
import '../View/LoginView.dart';
import '../Service/SkillsService.dart';
import '../Components/StarRating.dart';
import '../Model/Skill.dart';


class MapSubSkillsView extends StatefulWidget {
  final List<Skill> selectedSkills;
  final ContextData contextData;
  
  MapSubSkillsView(this.selectedSkills, this.contextData);

  @override
  createState() => new MapSubSkillsState(selectedSkills, contextData);
}

class MapSubSkillsState extends State<MapSubSkillsView> {
  List<Skill> selectedSkills;
  ContextData contextData;
  bool loading;

  MapSubSkillsState(this.selectedSkills, this.contextData, [this.loading=false]);

  final snackBarError = new SnackBar(
      content: new Text('Erro ao salvar. Tente novamente mais tarde.'),
      duration: new Duration(seconds: 3)
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Mapear Skills"),
        backgroundColor: Colors.cyan,
        actions: [
          new IconButton(
            onPressed: save,
            icon: new Icon(Icons.save)
          )
        ],
//          icon: new Icon(Icons.close),
//          onPressed: () {
//            Navigator.pop(context);
//          })
        leading:
          new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
            Navigator.pop(context);
            }
        ),
      ),
      body: new Stack(
      children: [
        new Container(
          padding: new EdgeInsets.all(18.0),
          child: new Scrollbar(
            child: new CustomScrollView(
              slivers: [new SliverList(
                delegate: new SliverChildListDelegate(
                  getSubSkillsList()
                ),
              )]
            )  
          ),
        ),
        loading ? new Container(
          child: new Center(
            child: new Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: new Color(0xccffffff),
            ),
          ),
        ): new Container(),
        loading ? new LoadingCircleRotate(): 
        new Container(),]
      )
    );
  }

  void save(){
    setState(() { loading = true;} );

    List<SubSkill> subskillsToUpdate = [];
    List<SubSkill> subskillsToSave = [];


    selectedSkills.forEach((selectedSkill) {
      contextData.userSkills.forEach((oldSkill) {
        if(selectedSkill.skillId == oldSkill.skillId) {
          selectedSkill.subSkills.forEach((selectedSubskill) {
             oldSkill.subSkills.forEach((oldSubskill) {
               if(oldSubskill.subSkillId == selectedSubskill.subSkillId) {
                 selectedSubskill.entryId = oldSubskill.entryId;
                 subskillsToUpdate.add(selectedSubskill);             
               }
             });
          });
        }
      });
    });

    selectedSkills.forEach((selectedSkill) {
      selectedSkill.subSkills.forEach((subSkill) {
        if(subskillsToUpdate.firstWhere((updateSubskill) => updateSubskill.subSkillId == subSkill.subSkillId, orElse: () => null) == null) {
          subskillsToSave.add(subSkill);
        }
      });
    });

    var skillService = new SkillsService();

    skillService.updateSubskills(subskillsToUpdate, contextData.user).then((success) {
      skillService.saveSkills(subskillsToSave, contextData.user).then((success) {
        if(success) {
          new SkillsService().getUserSkills(contextData.user, contextData.user.id).then((skills) {
            setState(() { loading = false;} );
            contextData.userSkills = skills;
            Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new HomeAppView(contextData)));
          });
          
        } else {
            Scaffold.of(context).showSnackBar(snackBarError);
        }
      });
    });
    
  }

  List<Widget> getSubSkillsList(){
    double width = MediaQuery.of(context).size.width;

    List<Widget> newWidgets = [];
    newWidgets.add(new Column(
      children:[
        new Container(
          padding: EdgeInsets.only(right: width*0.333, bottom: 2.0),
          child: new Text(
            "Classifique seu domínio nas skills.",
            style: new TextStyle(
              color: new Color.fromRGBO(97, 97, 97, 1.0),
              fontSize: 14.0
            ),
          ),
        ),
        new Container(
          padding: EdgeInsets.only(right: width*0.165, bottom: 15.0),
          child: new Text(
            "Dê like nas quais tem interesse em aprender.",
            style: new TextStyle(
              color: new Color.fromRGBO(97, 97, 97, 1.0),
              fontSize: 14.0
            ),
          )
        ),
      ],
    ));

    selectedSkills.forEach((skill){
      newWidgets.add(
        new Card(
          child: new Column(
            children: [
              new Container(
                padding: new EdgeInsets.only(top: 16.0, bottom: 8.0, left: 16.0, right: 16.0),
                child: new Row(
                  textDirection: TextDirection.ltr,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Text(
                      skill.skillName,
                      style: new TextStyle(
                        color: new Color.fromRGBO(45, 182, 195, 100.0),
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    new Row(
                      children: [
                        new Text(
                          skill.totalSubSkills.toString(),
                          style: new TextStyle(
                            color: new Color.fromRGBO(97, 97, 97, 100.0),
                            fontSize: 14.0,
                          ),
                        ),
                        new Text(
                          " skills",
                          style: new TextStyle(
                            color: new Color.fromRGBO(190, 190, 190, 100.0),
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              new Container(
                child: new Divider(height: 15.0,color: Colors.grey[300])
              ),
              new Container(
                child: new Column(
                  children: listSubSkills(skill),
                )
              )
              
            ],
          ), 
        )
      );
      
    });

    return newWidgets;
  }

  List<Widget> listSubSkills(Skill skill){
    List<Widget> subSkills = [];

    skill.subSkills.forEach((sub) {
      subSkills.add(
        new Container(
          padding: new EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
          child: new Column(
            children: [
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Text(
                    sub.subSkillName,
                    style: new TextStyle(
                      color: new Color.fromRGBO(97, 97, 97, 100.0),
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              new Container(
                 padding: new EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 6.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new StarRating(
                      rating: sub.subSkillRating, 
                      color: new Color.fromRGBO(245, 184, 43, 100.0),
                      onRatingChanged: (rating) { changeRating(rating, skill, sub); },
                    ),
                    new GestureDetector(
                      child: new Icon(
                        sub.subSkillInterest ? Icons.favorite : Icons.favorite_border, 
                        color: sub.subSkillInterest ? Colors.red : Colors.grey,
                      ),
                      onTap: () { favoritarSubSkill(skill, sub); },
                    ) 
                  ]
                ),
              )
              
            ]
          )
        )
      );
      subSkills.add(
        new Container(
          padding: new EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
          child: new Divider(height: 15.0,color: Colors.grey[300])
        ),
      );
    });
    return subSkills;
  }

  void changeRating(double rating, Skill skill, SubSkill sub) {
    int indexSkill = selectedSkills.indexOf(skill);
    int indexSubskill = skill.subSkills.indexOf(sub);
    List<Skill> skillsTemp = selectedSkills;
    skillsTemp[indexSkill].subSkills[indexSubskill].subSkillRating = rating;
    setState(() { selectedSkills = skillsTemp; });
  }

  void favoritarSubSkill(Skill skill, SubSkill sub) {
    int indexSkill = selectedSkills.indexOf(skill);
    int indexSubskill = skill.subSkills.indexOf(sub);
    List<Skill> skillsTemp = selectedSkills;
    skillsTemp[indexSkill].subSkills[indexSubskill].subSkillInterest = !skillsTemp[indexSkill].subSkills[indexSubskill].subSkillInterest;
    setState(() { selectedSkills = skillsTemp; });
  }
}