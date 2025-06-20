public class WeeklyEmailComponentController{

public static Integer count_cp {get;set;}
public static Integer count_dp {get;set;}
public static Integer count_myp {get;set;}
public static Integer count_pyp {get;set;}  
public static Integer cor_count_cp {get;set;}
public static Integer cor_count_dp {get;set;}
public static Integer cor_count_myp {get;set;}
public static Integer cor_count_pyp {get;set;}
public static boolean check = false;
public Static integer sum =0;
public static string lang{get;set;}
public Id cont;
    
public ID getcont(){ 
    return cont; }
public void setcont(ID s){
            cont = s;
            contact c=[select id,name,User_Language__c from contact where id=:s limit 1];
            lang=c.User_Language__c;
            
        }
public integer getcount_myp(){
    return count_myp;
    }
public integer getcount_pyp(){
        return count_pyp;
    }
public integer getcount_cp(){
    return count_cp;
    }
public integer getcount_dp(){
    return count_dp;
    }
 public integer getcor_count_myp(){
     return cor_count_myp;
    }
public integer getcor_count_pyp(){
    return cor_count_pyp;
    }
public integer getcor_count_cp(){
    return cor_count_cp;
    }
public integer getcor_count_dp(){
    return cor_count_dp;
    }
 
public WeeklyEmailComponentController() {
}
}