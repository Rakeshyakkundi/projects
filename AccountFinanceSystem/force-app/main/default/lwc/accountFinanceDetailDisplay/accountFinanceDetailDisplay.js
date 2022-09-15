import { LightningElement, wire, api, track } from 'lwc';
import getTargetDeviation from '@salesforce/apex/AccountFinance.getTargetDeviationList';
import saveTargetAmount from '@salesforce/apex/AccountFinance.saveTargetAmount';
import HighCharts from '@salesforce/resourceUrl/HighCharts';
import { refreshApex } from '@salesforce/apex';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';


export default class AccountFinanceDetailDisplay extends LightningElement {

    @api recordId;
    totalTarget;
    totalPipeline;
    totalDeviation;
    values;
    @track data = [];
    chartTarget = [];
    chartPipeline = [];
    chartMonth = [];

    @track chartTable = true;
    chartTableToggle(event) {
        this.chartTable = !this.chartTable;
        let chartContainer = this.template.querySelector(".chartContainer");
        chartContainer.classList.toggle("slds-hide");
    }

    @track checked = false;
    changeToggle(event) {
        this.checked = !this.checked;
        console.log(this.checked);
    }

    @track targetValues;
    @track targetName;
    @track mapData = [];
    getValue(event) {
        this.targetValues = event.target.value;
        this.targetName = event.target.name;
        let month = this.targetName + ' ' + this.recordId;
        let amount = this.targetValues;
        this.mapData.push({ month: month, amount: amount });
    }

    //save the changed target
    saveTarget(event) {
        this.checked = !this.checked;
        saveTargetAmount({ targetData: JSON.stringify(this.mapData) , accId: this.recordId})
            .then(() => {
                console.log('this result save taget');
            })
            .then(() => {
                getTargetDeviation({ accId: this.recordId })
                    .then((data) => {
                        console.log('Hello this result', data);
                        this.totalTarget = data.totalTarget;
                        this.totalPipeline = data.totalPipeline;
                        this.totalDeviation = (Math.round(data.totalDeviation * 100) / 100).toFixed(2);
                        this.data = data.dataValues;
                        this.chartTarget = data.chartTarget;
                        this.chartPipeline = data.chartPipeline;
                        this.chartMonth = data.chartMonth;
                        console.log('Data :', this.data);
                        this.renderChart();
                    })
                    .catch((error) => {
                        console.log(error, 'this error');
                    });
            })
            .catch((error) => {
                console.log(error, 'this error');
            });
        console.log('1 Map data :', this.mapData);
        console.log('2', typeof (this.mapData));
        console.log('3 MapData :', this.mapData);
        this.mapData = [];


    }
    changeToggleCancle(event) {
        this.checked = !this.checked;
        this.mapData = [];
    }



    // Charts
    connectedCallback() {
        getTargetDeviation({ accId: this.recordId })
            .then((result) => {
                console.log('connectedCallback  list :', result);
                this.totalTarget = result.totalTarget;
                this.totalPipeline = result.totalPipeline;
                this.totalDeviation = (Math.round(result.totalDeviation * 100) / 100).toFixed(2);
                this.data = result.dataValues;
                this.chartTarget = result.chartTarget;
                this.chartPipeline = result.chartPipeline;
                this.chartMonth = result.chartMonth;
                console.log('Data=', this.data);
                this.renderChart();
            })
            .catch((error) => {
                console.log('Error is', error);
            });
        Promise.all([
            loadScript(this, HighCharts),

        ]).then(() => {

        });
    }
    renderChart() {
        let chartContainer = this.template.querySelector(".chartContainer");
        console.log(chartContainer);
        console.log('chartTarget:', this.chartTarget);
        console.log('chartPipeline:', this.chartPipeline);
        console.log('chartMonth:', this.chartMonth);
        Highcharts.chart(chartContainer, {
            chart: {
                type: 'column'
            },
            title: {
                text: 'Monthly Target Pipeline'
            },
            xAxis: {
                categories: this.chartMonth,
                crosshair: true
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Amount'
                }
            },
            tooltip: {
                headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y:.1f} mm</b></td></tr>',
                footerFormat: '</table>',
                shared: true,
                useHTML: true
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0
                }
            },
            series: [{
                name: 'Target',
                data: this.chartTarget

            }, {
                name: 'Pipeline',
                data: this.chartPipeline

            }]
        });
    }

}