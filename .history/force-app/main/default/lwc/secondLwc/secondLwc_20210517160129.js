import { LightningElement } from 'lwc';
import firsttemplate from './secondLwc.html';
import secondtemplate from './secondchildComp.html';
export default class secondLwc extends LightningElement {
templatenumber = 'temp1';
showChildCmp = false;
constructor(){
super();
console.log('Inside constructor');
}
connectedCallback(){
console.log('Inside connected callback');
}
disconnectedCallback(){
console.log('Inside disconnected callback');
}
onchange(){
console.log('Inside change template');
if(this.templatenumber==='temp1'){
this.templatenumber='temp2';
this.showChildCmp= true;
alert('child comp**'+this.showChildCmp);

}else{
this.templatenumber='temp1';
}
}
render(){
console.log('Inside render');
if(this.templatenumber==='temp1')
return firsttemplate;
else return secondtemplate;
}
renderedCallback()    {  
    console.log('This is From parent component rendered callback'); 
 }
}