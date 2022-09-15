import { LightningElement,track } from 'lwc';

export default class ToDo extends LightningElement {

    @track todoList = [
        {
            id:1,
            name:"Task list 1"
        },{
            id:2,
            name:"Task list 2"
        }
    ]

    @track newTask = "";
    addtask(event){
        this.newTask = event.target.value;
    }
    addToList(event) {
        if(this.newTask.length>0) {
            this.todoList.push({id:this.todoList.length+1,name:this.newTask})
        }
        this.newTask = "";
    }
    deleteItem(event) {
        let index ;
        for(let i=0;i<this.todoList.length;i++) {
            if(event.target.name == this.todoList[i].id) {
                index = i;
                break;
            }
        }
        this.todoList.splice(index,1);
        
    }
}