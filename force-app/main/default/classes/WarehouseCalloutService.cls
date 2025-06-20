global with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    // complete this method to make the callout (using @future) to the
    // REST endpoint and update equipment on hand.
    
     @future(callout=true)
    global static void runWarehouseEquipmentSync(){
        
        Http http=new Http();
        HttpRequest request=new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        HttpResponse response=Http.send(request);
        if (response.getStatusCode() == 200) {
            
             List<Product2> equipmentlist=new List<Product2>();
            // Deserialize the JSON string into collections of primitive data types.
            List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());
            // Cast the values in the 'products' key as a list
            //List<Object> products = (List<Object>) results.get('products');
            System.debug('Received the following products:');
            for (Object product: results) {
                System.debug(product);
            }
            
            for (Object externalEquipment1: results) {
            Map<String,Object> data = (Map<String,Object>)externalEquipment1;
            //system.debug(externalEquipment1);
            //system.debug(data+'==='+data.get('cost'));
            Product2 equipment=new Product2();
            // equipment.Id =(String)data.get('_id');
            equipment.Cost__c=(Integer)data.get('cost');
            equipment.Lifespan_Months__c =(Integer)data.get('lifespan');
            equipment.Maintenance_Cycle__c =(Integer)data.get('maintenanceperiod');
            equipment.Name =(String)data.get('name');
            equipment.Current_Inventory__c =(Integer)data.get('quantity');
            equipment.Replacement_Part__c =(Boolean)data.get('replacement');
            equipment.Warehouse_SKU__c=(String)data.get('sku');
            equipmentlist.add(equipment);
        }
             if(equipmentlist.size() > 0){
                insert equipmentlist;
            }
}
        
    }

}