@isTest
public class TriggerDispatcherBaseTest {
@isTest
    public static void TriggerDispatchmtd(){
        new TriggerDispatcherBase().bulkBefore();
        new TriggerDispatcherBase().bulkAfter();
        new TriggerDispatcherBase().beforeInsert(null);
        new TriggerDispatcherBase().beforeUpdate(null);
        new TriggerDispatcherBase().beforeDelete(null);
        new TriggerDispatcherBase().afterInsert(null);
        new TriggerDispatcherBase().afterUpdate(null);
        new TriggerDispatcherBase().afterDelete(null);
        new TriggerDispatcherBase().afterUnDelete(null);
        new TriggerDispatcherBase().andFinally();
        
        
    }
}