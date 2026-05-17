import { LightningElement } from 'lwc';

export default class DataBinding extends LightningElement {
    str = "Hello I'm a string";
    arr = ['a','b','c'];
    obj={
        name:'John',
        age:30
    }
    bool = false;
    conditional;
    changeHandler(event){
        this.conditional= event.target.value;
    }
    players=[
{name:'Virat Kohli',age:21,height:`6'4"`},
{name:'Rohit Sharma',age:30,height:`5'8"`},
{name:'MS Dhoni',age:40,height:`5'9"`}

    ];

    get addition(){
        return this.players.reduce((acc,player)=> acc+player.age,0);
    }

    get firstPlayerName(){
        return this.players[0].name;
    }
}