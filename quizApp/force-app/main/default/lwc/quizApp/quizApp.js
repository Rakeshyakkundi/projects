import { LightningElement,track } from 'lwc';
import { getDataflowJobs } from 'lightning/analyticsWaveApi';

export default class QuizApp extends LightningElement {
    
    answStore = {}
    @track selectedAll = true
    @track showScore = false
    @track correctAnswers = 0
    @track questions=[
        {
            id:1,
            ques:'Who is the founder of Tesla ?',
            answers:
            {
                a:'Elon Musk',
                b:'Steve Jobs',
                c:'Mark Zuckerberg'
            },        
            correctAnswer:'a'
        },{
            id:2,
            ques:'Which of the below startup is related to to food delivery ?',
            answers:
            {
                a:'Ola',
                b:'Swiggy',
                c:'Oyo'
            },
            correctAnswer:'b'
        },{ 
            id:3,
            ques:'Which is the highest valued cryptocurrency ?',
            answers:
            {
                a:'Ethereum',
                b:'Cardano',
                c:'Bitcoin'
            },
            correctAnswer:'a'
        }
    ]   
    answerHandle(event) {
        this.answStore[event.target.name] =event.target.value
        if(Object.keys(this.answStore).length===this.questions.length) {
            this.selectedAll = false
        } else {
            this.selectedAll = true
        }
    }
    submitHandle(event) {
        this.correctAnswers = 0
        for(var item in this.questions) {
            if(this.questions[item].correctAnswer===this.answStore[this.questions[item].id]) {
                this.correctAnswers  = this.correctAnswers +1
                console.log(this.answStore[this.questions[item].id]);
            }
        }
        this.showScore = true
        event.preventDefault() // as submit in form and we need basic fun on form
    }
    resetHandle(event) {
        this.correctAnswers = 0
        this.showScore = false
    }
}

