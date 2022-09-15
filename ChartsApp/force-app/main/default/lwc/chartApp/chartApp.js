import { LightningElement,track,api } from 'lwc';
import 	HighCharts from '@salesforce/resourceUrl/HighCharts';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import getOpportunities from '@salesforce/apex/OpportunityData.getOpportunities';
export default class ChartApp extends LightningElement {
    @api recordId;
    formatdata = []
    chartContainer
    @track tableData
    @track  columns = [
        { label: 'Id', fieldName: 'Id' },
        { label: 'Opportunity Name', fieldName: 'Name', type: 'text' },
        { label: 'Amount', fieldName: 'Amount', type: 'Number' },
        { label: 'Stage Name', fieldName: 'StageName', type: 'text' },
        // { label: 'Account Id', fieldName: 'AccountId', type: 'Id' },
    ];
    connectedCallback() {
        // '0015i00000NYISeAAP'
        getOpportunities({AccId:this.recordId})
        .then((data) =>{
            this.tableData = data
            for(let item in data) {
                this.formatdata.push({name:data[item].Name,y:data[item].Amount})
            }
        })
        .then(()=>{
            Promise.all([
                loadScript(this, HighCharts ),
            ]).then(() => { 
                this.chartContainer =this.template.querySelector(".chartContainer");
                this.renderChart();
            });
        })
        .catch((error) =>{
            console.log("error :",error);
        })
       
       }
    
    renderChart() {
       window.Highcharts.chart(this.chartContainer, {
           chart: {
               type: 'pie'
           },
           title: {
               text: 'Browser market shares. January, 2022'
           },
           plotOptions: {
               series: {
                   dataLabels: {
                       enabled: true,
                       format: '{point.name}: {point.y}'
                   }
               }
           },
           tooltip: {
               headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
               pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.y}</b> of total<br/>'
           },
           series: [
               {
                   name: "Browsers",
                   colorByPoint: true,
                   data: this.formatdata
               }
           ]
       });
       
       
      }
    }