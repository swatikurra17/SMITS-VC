public class testpopup{
public boolean isChecked{get;set;}
public string selectedSupplier{get;set;}
list<Supplier__c> suppliers{get;set;}
public string searchStr{get;set;}
public list<Supplier__c> supplierInfo{get;set;}
public List<cService> supplierInfo_wrapper{get;set;}
public List<cSupplierService>supplier_serviceWrapper{get;set;}
public string SelectedSupplierByRadio{get;set;}
public list<Supplier__c> suppliers1{get;set;}
public list<Supplier_Service__c> supplierService{get;set;}
public list<Supplier_Service__c> selectedServices{get;set;}
public id objSelectedServiceId{get;set;}
public List<Supplier_Service__c  > finalList{get;set;}
public List<Supplier_Service__c> finalListService{get;set;}
public List<Supplier__c > supplierinfo1{get;set;}

//public List<Supplier_Service__c > finalList{get;set;}

    public class cService {
        public Supplier__c con {get; set;}
        public Boolean selected {get; set;}
        public integer index{get;set;}

        //This is the contructor method. When we create a new cContact object we pass a Contact that is set to the con property. We also set the selected value to false
        public cService() {
            selected = false;
        }
    }
    
     public class cSupplierService {
        public Supplier_Service__c con {get; set;}
        public Boolean selected {get; set;}
        public integer index{get;set;}

        //This is the contructor method. When we create a new cContact object we pass a Contact that is set to the con property. We also set the selected value to false
        public cSupplierService() {
            selected = false;
        }
    }


    public testpopup(){
        isChecked = false;
        supplierService=new list<Supplier_Service__c>();
        finalList=new List<Supplier_Service__c>();
    }

    public List<SelectOption> supplierOptions {
        get {
            suppliers= [SELECT id,name,Supplier_Statu__c FROM Supplier__c WHERE Supplier_Statu__c = 'Active in SSRF'];
            supplierOptions= new List<SelectOption>();
            supplierOptions.add(new SelectOption('HideBlock','-Select Supplier-'));  
            
           if(!suppliers.isEmpty()){
            for(Supplier__c p : suppliers){
                supplierOptions.add(new SelectOption(p.Id,p.Name));      
            }
           }
            return supplierOptions;
        }
        set;
    }
  
    public List<SelectOption> supplierOptions1{
        get{
            if(selectedsupplier != 'HideBlock' && searchStr ==''){
            suppliers1= [SELECT Name,Supplier_ID__c,Supplier_Name__c,Supplier_Statu__c,Supplier_Type__c,Supplier_Type__r.name FROM Supplier__c where id=:selectedsupplier AND Supplier_Statu__c = 'Active in SSRF'];
            }
            else if(searchStr !=''){
             selectedSupplier='';
             string searchContain='%'+searchStr+'%';
             suppliers1= [SELECT Name,Supplier_ID__c,Supplier_Name__c,Supplier_Statu__c,Supplier_Type__c,Supplier_Type__r.name FROM Supplier__c where name like : searchContain AND Supplier_Statu__c = 'Active in SSRF'];
            }
            supplierOptions1= new List<SelectOption>();
            //supplierOptions.add(new SelectOption('HideBlock','-Select Supplier-'));  
            if(!suppliers1.isEmpty()){
                system.debug(suppliers1);
                for(Supplier__c p : suppliers1){
                    supplierOptions1.add(new SelectOption(p.id,''));      
                }
            }
            return supplierOptions1;
        }
        set;
    }  
  
    public void supplierInforamtion(){
        if(selectedsupplier == 'HideBlock'){
            selectedSupplier='';
            supplierInfo();
        }
    }
    public void servicesProvidedBySupplier(){
        if(selectedsupplier == 'HideBlock')
        selectedsupplier=SelectedSupplierByRadio;
        system.debug('-- Inside Checkbox on Change Method ---');
        system.debug('--- SelectedSupplierByRadio ---'+ SelectedSupplierByRadio);
        system.debug('--- supplierService ---' + supplierService);
        /*if(!supplier_serviceWrapper.isEmpty()){
            SelectedSupplierByRadio = '';
            supplier_serviceWrapper.clear();
        }*/
        if(!string.isBlank(SelectedSupplierByRadio)){
         System.debug('@@inside SelectedSupplierByRadio@@ line 92');
            supplierService=[SELECT id,Name,Service_Name__c,Service_Name__r.name,Supplier_Name__c,Supplier_Name__r.name FROM Supplier_Service__c where Supplier_Name__c=:SelectedSupplierByRadio];
            supplier_serviceWrapper= new List<cSupplierService>();
            for(integer i=0;i<supplierService.size();i++){
                cSupplierService supplier= new cSupplierService();
                supplier.con=supplierService[i];
                supplier.index=i;
                supplier_serviceWrapper.add(supplier);
            }
            
            System.debug('@@supplier_serviceWrapper@@'+supplier_serviceWrapper);
        }
            
    }    

    public void supplierInfo(){
        searchStr='';
        if(supplier_serviceWrapper!=null && !supplier_serviceWrapper.isEmpty())
        {
        supplier_serviceWrapper.clear();
        }
        system.debug('---- Inside Supplier Informatiopn Method ----');
        system.debug('----Before SelectedSupplierByRadio ----' + SelectedSupplierByRadio);
        system.debug('----Before supplierService ---- ' + supplierService);
        if(!supplierService.isEmpty()){
            SelectedSupplierByRadio = '';
            supplierService.clear();
        } 
        if(selectedsupplier !='HideBlock')
        supplierInfo=[SELECT Name,Supplier_ID__c,Supplier_Name__c,Supplier_Statu__c,Supplier_Type__c,Supplier_Type__r.name FROM Supplier__c where id=:selectedsupplier ];
        else{
            supplierInfo.clear();
            supplierInfo_wrapper.clear();
        }
         
        system.debug('----After SelectedSupplierByRadio ----' + SelectedSupplierByRadio);
        system.debug('----After supplierService ---- ' + supplierService);
        
        if(!supplierInfo.isempty()){
            supplierInfo_wrapper= new List<cService>();
            for(integer i=0;i<supplierInfo.size();i++){
                cService supplier= new cService();
                supplier.selected=false;
                supplier.con=supplierInfo[i];
                supplier.index=i;
                supplierInfo_wrapper.add(supplier);
            }
        }
        System.debug('@@@supplierInfo_wrapper@@'+supplierInfo_wrapper);
    }
    
    public void search(){
    selectedSupplier='';
    if(supplier_serviceWrapper!=null && !supplier_serviceWrapper.isEmpty())
    {
    supplier_serviceWrapper.clear();
    }
       if(!supplierService.isEmpty()){
            SelectedSupplierByRadio = '';
            supplierService.clear();
        } 
        selectedSupplier='';
        string searchContain='%'+searchStr+'%';
        supplierinfo1=[SELECT Name,Supplier_ID__c,Supplier_Name__c,Supplier_Statu__c,Supplier_Type__c,Supplier_Type__r.name FROM Supplier__c where NAME like : searchContain];
        if(!supplierinfo1.isempty()){
            supplierInfo_wrapper= new List<cService>();
            for(integer i=0;i<supplierinfo1.size();i++){
                cService supplier= new cService();
                supplier.selected=false;
                supplier.con=supplierinfo1[i];
                supplier.index=i;
                supplierInfo_wrapper.add(supplier);
            }
        }
        //system.debug('%%%%%%%%%%%%%'+supplierService);
    }
    
    Public void selectedServices(){
        system.debug('---- paramValue  --');
        System.debug('@@@@supplier_serviceWrapper@@'+supplier_serviceWrapper);
        boolean duplicate=false;
        //Set<Id> supSer=new Set<Id>();
        Integer paramValue = Integer.valueof(ApexPages.currentPage().getParameters().get('parm1'));
        system.debug('---- paramValue  ---'+ paramValue );
       // if(supplier_serviceWrapper[paramValue].selected==false)
         //   supplier_serviceWrapper[paramValue].selected=true;
        //else if(supplier_serviceWrapper[paramValue].selected==true)
          //  supplier_serviceWrapper[paramValue].selected=false;
        System.debug('@@@@supplier_serviceWrapper@@'+supplier_serviceWrapper);
        /*
        Supplier_Service__c lstsup=[select id,name from Supplier_Service__c where id=:paramValue ];
    
        if(!finalList.isEmpty())
         {
         for(Supplier_Service__c iserv : finalList)
        {
            if(iserv.Id==lstsup.Id)
            {
             duplicate=true;   
            }
        }
        if(duplicate==false)
        {
        finalList.add(lstsup);
        }
        }
        else
        {
        finalList.add(lstsup);
        }*/
    }
    
     public void removeService()
    {
       string index = Apexpages.currentpage().getparameters().get('Index');
        System.Debug('---- Index ----'+ index);
        supplier_serviceWrapper[Integer.valueof(index)].selected=false; 
    }
    
}