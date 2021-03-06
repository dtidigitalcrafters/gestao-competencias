import 'package:flutter/material.dart';

import '../Model/ContextData.dart';
import '../Model/Skill.dart';
import '../Model/User.dart';
import '../Components/BackgroundProfileAppBar.dart';
import '../Components/CardProfile.dart';
import '../Components/ChipProfile.dart';


class ProfileView extends StatefulWidget {

  final List<Skill> skillsProfile;
  final User user;
  final ContextData contextData;

  ProfileView(this.skillsProfile, this.user, this.contextData);

  @override
  createState() => new ProfileState(skillsProfile, user, contextData);

}

class ProfileState extends State<ProfileView> {

  List<Skill> skillsProfile;
  User user;
  ContextData contextData;

  ProfileState(this.skillsProfile, this.user, this.contextData);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double _flexibleSpaceMaxHeight = height*0.4;
    return new Scaffold(
        body: new CustomScrollView(
          slivers: [
            new SliverAppBar(
                expandedHeight: _flexibleSpaceMaxHeight,
                flexibleSpace: new BackgroundProfileAppBar(animation: kAlwaysDismissedAnimation, image: new Image.asset('assets/background-profile.png').image),
                bottom: new PreferredSize(
                    preferredSize: new Size.fromHeight(_flexibleSpaceMaxHeight*0.67),
                    child: new Container(
                      padding: new EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          new Text(
                            user.name,
                            style: new TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          new Text(
                            user.email,
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                          new Divider(color: Colors.transparent,),
                          new Row(
                              children: [
                                new SizedBox(
                                    width: MediaQuery.of(context).size.width-32.0,
                                    height: _flexibleSpaceMaxHeight*0.15,
                                    child: new Scrollbar(
                                      child: new CustomScrollView(
                                          scrollDirection: Axis.horizontal,
                                          slivers: [new SliverList(
                                              delegate: new SliverChildListDelegate(
                                                  getChipList()
                                              )
                                          )]
                                      ),
                                    )
                                )
                              ]
                          )
                        ],
                      ),
                    )
                )
            ),
            new SliverList(
              delegate: new SliverChildListDelegate(
                  getCardsList()
              ),
            ),
          ],
        ),
    );
  }

  List<Widget> getCardsList(){
    List<Widget> skillsCards = [];

    if(skillsProfile.isNotEmpty){
      skillsProfile.forEach((skill){
        skillsCards.add(new CardProfile(skill));
      });
    }


    return skillsCards;
  }

  List<Widget> getChipList(){
    List<Widget> chips = [];

    skillsProfile.forEach((skill){
      if(skill.skillRating != 0.0) {
        chips.add(new ChipProfile(skill.skillName));
      }
    });

    return chips;
  }
  
}