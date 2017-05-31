public class ssrfControllerswati {
    public boolean isNewSSRF {get;set;}
    public string currentDate {get;set;}
    public user loggedInUser {get;set;}
    public string selectedArea {get;set;}
    public boolean isChecked{get;set;}
    public string selectedSupplier{get;set;}
    public list<Supplier__c> suppliers{get;set;}
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
    public boolean isServicesVisible {get;set;}
    public boolean isdoneButtonVisible {get;set;}
    public string loggedInUserName;
    public string selectedSpend {get;set;}
    public Attachment attachment {
        get {
            if (attachment == null)
                attachment = new Attachment();
            return attachment;
        }
        set;
    }
    
    public ssrfControllerswati (){
        user loggedInUser = [Select Id, Name from User where id =: userInfo.getUserID()];
        system.debug('logged in user'+ loggedInUser );
        loggedInUserName = loggedInUser.Name;
        isdoneButtonVisible = false;
        isServicesVisible = false;
        isNewSSRF = false;
        isChecked = false;
        supplierService=new list<Supplier_Service__c>();
        finalList=new List<Supplier_Service__c>();
        currentDate = string.valueOf(system.Today());
        loggedInUser = [Select id, username, firstName, lastName, FederationIdentifier, phone from user where Id =: UserInfo.getUserId()];
    }
    
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



    public List<SelectOption> supplierOptions {
        get {
            suppliers= [SELECT id,name,Supplier_Statu__c FROM Supplier__c WHERE Supplier_Statu__c = 'Active in SSRF'];
            supplierOptions= new List<SelectOption>();
            supplierOptions.add(new SelectOption('HideBlock','-Select Supplier-'));  
            
            for(Supplier__c p : suppliers){
                supplierOptions.add(new SelectOption(p.Id,p.Name));      
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
        if(supplier_serviceWrapper!=null && !supplier_serviceWrapper.isEmpty()) {
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
        isdoneButtonVisible=false;
        if(supplier_serviceWrapper!=Null){
            for(cSupplierService ser : supplier_serviceWrapper){
                if(ser.selected){
                    isdoneButtonVisible=true;
                    break;
                }
            }
            
        }
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
    
    
    public List<SelectOption> getBusinessArea() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = User.Business_Area__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    
    public List<SelectOption> getEstimatedSpend() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = SSRF__c.Estimated_Spend__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    
    public pageReference redirect_SSRF(){
        PageReference pgRef = new PageReference('/apex/Create_SSRF');
        pgRef.setRedirect(false);
        return pgRef;
    }
    
    public pageReference redirect_HOME(){
        PageReference pgRef = new PageReference('/apex/homepage');
        pgRef.setRedirect(false);
        return pgRef;
    }
    
    public pageReference buttonVisibility(){
        isNewSSRF = true;
        return null;
    }
    
    public pageReference done(){
        system.debug('Inside done Method ......');
        isServicesVisible = true;
        return null;
    }
    
    public pageReference submitSSRF(){
        system.debug('Inside SSRF Submit Method ----');
        
        List<Business_Area__c > lstbArea = new List<Business_Area__c>([Select Id, Name from Business_Area__c where Name =: selectedArea]);
        
        SSRF__c ssrf = new SSRF__c();
        ssrf.Name = 'SSRF Request : ' +loggedInUserName;
        if(!lstbArea .isEmpty())
            ssrf.Business_Area__c = lstbArea[0].Id;
        ssrf.Created__c = system.today();
        ssrf.Status__c = 'Pending';
        ssrf.Submitted_By__c = loggedInUserName;
        ssrf.Estimated_Spend__c = '';
        insert ssrf;
        
        system.debug('SSRF Id ----' + ssrf.Id);
        
        Id supplierId;
        if(supplierinfo != Null)
            supplierId = supplierinfo[0].Id;
        
        if(supplierinfo1 != Null)
            supplierId = supplierinfo1[0].Id;
        
        SSRF_Supplier__c ssrfSupplier = new SSRF_Supplier__c();
        ssrfSupplier.SSRFCode__c = ssrf.Id;
        ssrfSupplier.Status__c = 'Existing';
        ssrfSupplier.Supplier_Name__c = supplierId;
        insert ssrfSupplier;
        
        system.debug('SSRF Supplier Id ----' + SSRF_Supplier__c.Id);
        
        List<SSRF_Service__c> lstServices = new List<SSRF_Service__c>();
        for(cSupplierService ser : supplier_serviceWrapper){
            if(ser.selected){
                SSRF_Service__c ssrfService = new SSRF_Service__c();
                ssrfService.Service_Name__c = ser.Con.Service_Name__c;
                ssrfService.SSRFCode__c = ssrf.Id;
                ssrfService.Final_Status__c = 'Existing';
                lstServices.add(ssrfService);
            }
        }    
        if(!lstServices.isEmpty())
            insert lstServices;
        
        /*system.debug('STRT - Attachment Upload ----');
        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = ssrf.Id; 
        attachment.IsPrivate = true;
        insert attachment;*/
        
        PageReference pgRef = new PageReference('/'+ssrf.Id);
        pgRef.setRedirect(true);
        return pgRef; 
    }
}