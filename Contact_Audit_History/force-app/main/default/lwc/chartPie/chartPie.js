import { LightningElement, wire } from 'lwc';
import HighCharts from '@salesforce/resourceUrl/HighCharts';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import ChartData from '@salesforce/apex/auditHistory.ChartData';
export default class ChartPie extends LightningElement {
   DataChart = {}
   @wire(ChartData)
   chartSummary({data,error}){
    if (data) {
      console.log('Chart Data',data);
      this.DataChart = data;
      this.renderData();
   } else if (error) {
       console.log('Error',error);
   }
}
    connectedCallback() {
        Promise.all([
            loadScript(this, HighCharts ),
            
        ])
        .then((data) => {
                    
        })
        .catch((error) => {
            console.log('Error is', this.error); 
        });
    }
    renderData(){
      console.log('Data',this.DataChart);
      
      // for (const [key, value] of Object.entries(this.DataChart)) {
        
      //   console.log(key, value);
        
      // }
      
        let container=this.template.querySelector(".container");
        Highcharts.chart(container, {

          chart: {
            styledMode: true
          },
        
          title: {
            text: 'Summary'
          },
          series: [{
            type: 'pie',
            allowPointSelect: true,
            keys: ['name', 'y'],
            data: this.DataChart
          }]
        });  
    }
}