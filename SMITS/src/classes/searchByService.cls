public class searchByService {

    public boolean isChecked{get;set;}
    public id objSelectedServiceId{get;set;}
    public string selectedService{get;set;}
    public string selecteditem{get;set;}
    public list<Service__c> servicelst{get;set;}
    
    public List<Service__c> finalServicelst{get;set;}
    list<Service_Type__c> Services{get;set;}
    List<SelectOption> serviceslist;
    
    public string searchStr{get;set;}
    
    public searchByService(){
        isChecked = false;
        finalServicelst =new List<Service__c>();
    }

   public void serviceInfo()
   {
        system.Debug('inside al services'+selectedService );
        servicelst=[SELECT Description__c,Detailed_Description__c,Id,Name,Service_Type__r.Title__c,Status__c FROM Service__c where Service_Type__c=:selectedService];
        system.Debug('all list'+servicelst);
    }
     public void searchService()
     {
        string searchContain='%'+searchStr+'%';
        servicelst=[SELECT Description__c,Detailed_Description__c,Id,Name,Service_Type__r.Title__c,Status__c FROM Service__c where Service_Type__r.Title__c like : searchContain];
        //system.debug('%%%%%%%%%%%%%'+supplierService);
    }
    public void addtoFinal()
    {   boolean duplicate=false;
        string serviceId = Apexpages.currentpage().getparameters().get('serviceId');
        string checked = Apexpages.currentpage().getparameters().get('checked');
        system.Debug('---- checked list ----' + checked);
        system.Debug('---- Inside Add to Final --- Service ID ----' + serviceId );
        Service__c  selectedserv =new Service__c();
        selectedserv= [SELECT Description__c,Detailed_Description__c,Id,Name,Service_Type__r.Title__c,Status__c FROM Service__c where Id =: serviceId];
           integer count=0;
         if(!finalServicelst.isEmpty())
         {
        
         for(Service__c iserv : finalServicelst)
        {   
            if(iserv.Id==selectedserv.Id)
            {
            
             duplicate=true;  
             break;
             
              
            }
            count++;
        }
        if(duplicate==false)
        {
        finalServicelst.add(selectedserv);
        }
        else
        {
        finalServicelst.remove(count);
        }
       
        }
        else
        {
        finalServicelst.add(selectedserv);
        }
       
        System.Debug('final service'+selectedserv);
    }
    public void removeService()
    {
      string index = Apexpages.currentpage().getparameters().get('Index');
        System.Debug('---- Index ----'+ index);
        if(!finalServicelst.isEmpty())
            finalServicelst.remove(Integer.valueOf(index)-1);
    }
    public List<SelectOption> getItems() {
                List<SelectOption> options = new List<SelectOption>();
                options.add(new SelectOption('HideBlock','-Select-'));
                options.add(new SelectOption('All','All'));
                options.add(new SelectOption('Approved','Approved'));
                return options;
        }
    public List<SelectOption> listServices
    {
        get
        {
            services= [SELECT Id,Status__c,Title__c FROM Service_Type__c WHERE Status__c != 'Inactive'];
            serviceslist= new List<SelectOption>();
            serviceslist.add(new SelectOption('HideBlock','-Select Services-'));  
            
            for(Service_Type__c serv : services){
                serviceslist.add(new SelectOption(serv.Id,serv.Title__c ));      
            }
            return serviceslist;
        }
        set;
    }
  

}