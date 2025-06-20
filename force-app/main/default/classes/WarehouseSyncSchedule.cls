global class WarehouseSyncSchedule implements Schedulable {
  // implement scheduled code here
  global void execute (System.SchedulableContext sc){
        
        WarehouseCalloutService.runWarehouseEquipmentSync();
        //optional this can be done by debug mode 
       
           
    }
}