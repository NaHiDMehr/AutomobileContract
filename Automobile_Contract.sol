// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract automobileContract {

  
    struct Company{
        uint companyId; 
        uint companyParentId; 
        string name; 
        string code; 
        uint8 companyType; 
        uint8 status; 
        uint createDate; 
        uint signerId;
        uint entity;
    }

  
    struct adminInfo{
        string name;
        uint adminId;
        uint companyId;
        uint companyParentId;
        uint status;
        uint entity;
        uint [] signRecords;
        uint [] changeStatusRecords;
        uint [] createRecords;
        uint [] requestRecords;
        uint [] paymentRecords;
    }
    
  
    struct CarInfo{
        uint carVinId;
        uint companyId; 
        uint8 typeFuel; 
        string carModel;
        string kind; 
        string style; 
        string chassisNumber;
        string color; 
        string motor;
        uint createDate;
        uint [] ownerIds;
    }


    struct OwnerInfo{
        uint ownerId;
        uint typeLicense;
        string fullName;
        string birthDay;
        string licenseNumber;
        string dateLicense; 
        uint [] carVinIds;
        uint [] licensePlateIds;
    }

 
    struct LicensePlateInfo{
        uint licensePlateId;
        uint carVinId;
        uint ownerId;
        string licensePlateNum;
    }

   
    struct ThirdInsuranceInfo{
        uint thirdInsuranceId;
        uint companyId;
        uint carVinId;
        uint ownerId; 
        uint financialCommitment; 
        uint physicalCommitment; 
        uint driverAccidentCommitment;
        string startDate;
        string endDate;
        string numberInsurance;
    }

   
    struct BodyInsuranceInfo{
        uint bodyInsuranceId;
        uint companyId;
        uint carVinId;
        uint ownerId;
        uint countDay;
        uint carValue;
        uint otherEquipment;
        string startDate;
        string endDate;
        string agentCode;
    }

   
    struct InsuranceUse {
        uint insuranceUseId; 
        uint carVinId; 
        uint insuranceType;
        uint ownerId; 
        uint price; 
        uint dateUse; 
        string driver;
    }

  
    struct CarDelivery {
        uint carDeliveryId;
        uint companyId;
        uint agencyId;
        uint carVinId;
        uint licensePlateId;
        string deliveryDate;
        uint [] ownerIds;
        uint signerId;
    }   

  
    struct WarrantyInfo{
        uint companyId;
        uint carVinId;
        uint8 typeWarranty;
        string startDate;
        string endDate;
        uint maxKilometer;
    }


    struct RepairsInfo {
        uint carVinId; 
        uint warrantyId;
        uint companyId; 
        uint kilometer; 
        string serviceDate; 
        string reasonReferral; 
        string diagnosis; 
        uint8 operation;
        string namePiece ; 
        string reasonReplacePiece;
        string description; 
    }
    
    struct SmoothingPaintInfo{
        uint carVinId; 
        uint kilometer; 
        uint warrantyId; 
        uint companyId; 
        uint8 isColor; 
        string spaceSmoothing; 
        string spacePaint; 
        string description; 
    }

    mapping (uint => Company)  companyMapping;
    mapping (uint => CarInfo)  carInfoMapping;
    mapping (uint => OwnerInfo)  ownerInfoMapping;
    mapping (uint => LicensePlateInfo)  licensePlateInfoMapping;
    mapping (uint => ThirdInsuranceInfo)  thirdInsuranceInfoMapping;
    mapping (uint => BodyInsuranceInfo)  bodyInsuranceInfoMapping;
    mapping (uint => CarDelivery) carDeliveryMapping;
    mapping (uint => WarrantyInfo) warrantyInfoMapping;
    mapping (uint => RepairsInfo) repairsInfoMapping;
    mapping (uint => SmoothingPaintInfo) smoothingPaintInfoMapping;
    mapping (uint => InsuranceUse) insuranceUseMapping;
    mapping (uint => adminInfo) adminInfoMapping;
    mapping (address => uint) addresstoId;
    mapping (uint => address) IdtoAdress;
    mapping (uint => uint ) entity;

    constructor(address  _addres) {

        uint _companyId = 1000;
        entity[1000]= 10;
        companyMapping[_companyId].status = 1;
        companyMapping[_companyId].name = "0x62696d636861696e";

        uint _adminId=1234567890;
        entity[_adminId]= 11;
        addresstoId[_addres] =  _adminId;
        IdtoAdress[_adminId] = _addres;
        adminInfoMapping[_adminId].companyId = 1000;
        adminInfoMapping[_adminId].status = 1;

        

    }

    // ------------------------------------------------------
    event companyCreated(string name,string code, uint companyId,uint companyParentId);
    event ownerInfoCreated(uint typeLicense,uint nationalId,
                           string fullName,string birthDay,string licenseNumber,
                           string dateLicense);
    event carInfoCreated(uint companyId,uint8 typeFuel,string carModel,string kind,
                         string style,string chassisNumber,uint vin,string color,string motor);                       
    
    // -----------------------------------------------------
    
    // --------------Random function-----------------------

    function random() private view returns(uint) {
        uint rand= uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty)))%10;
        return rand;
    }
    
    // --------------END Random function-----------------------

    // --------------Company & agency function-----------------------
    
    function addCompanyInfo (string memory _name,string memory _code, uint _adminId,uint _entity,
                             uint8 _companyType) public payable returns(uint companyId) {
        
        require(addresstoId[msg.sender] == _adminId , 'Wrong ID');

        uint _companyId = random();
        companyMapping[_companyId].name = _name;
        companyMapping[_companyId].code = _code;
        companyMapping[_companyId].companyId = _companyId;
        companyMapping[_companyId].createDate = block.timestamp;
        companyMapping[_companyId].status = 1;
        companyMapping[_companyId].companyType = _companyType;
        companyMapping[_companyId].entity = _entity;
        entity[_companyId]= _entity;
        uint _companyParentId = adminInfoMapping[_adminId].companyId;
        companyMapping[_companyId].companyParentId = _companyParentId;
        adminInfoMapping[_adminId].createRecords.push(_companyId);

        emit companyCreated(_name, _code, _companyId,_companyParentId);
        return _companyId;
    }

    function changeCompanyStatus(uint _companyId, uint _adminId, uint8 _status) public{
        
        require(addresstoId[msg.sender]==_adminId, 'Wrong ID');
        require(companyMapping[_companyId].status != _status, 'The status now is this');

        companyMapping[_companyId].status = _status;
        adminInfoMapping[_adminId].changeStatusRecords.push(_companyId);

    }

    function getCompanyInfo(uint _companyId) public view returns (string memory name,string memory code,uint8 companyType,
    uint companyEntity,uint8 status,uint createDate){
 
         return (companyMapping[_companyId].name,companyMapping[_companyId].code, companyMapping[_companyId].companyType,
                 companyMapping[_companyId].entity, companyMapping[_companyId].status,companyMapping[_companyId].createDate);
    }

    
    // --------------Company & agency function-----------------------
    // --------------Admin function------------------------
    function addAdminInfo (string memory _name, uint _companyId, uint _companyParentId, uint _adminEntity) public returns(uint newadminId){
        require(addresstoId[msg.sender]==0, 'You are already registered');
        uint _newadminId = random();
        adminInfoMapping[_newadminId].name = _name;
        adminInfoMapping[_newadminId].companyId = _companyId;
        adminInfoMapping[_newadminId].adminId = _newadminId;
        adminInfoMapping[_newadminId].status = 1;
        entity[_newadminId]= _adminEntity;
        adminInfoMapping[_newadminId].companyParentId = _companyParentId;
        addresstoId[msg.sender] = _newadminId;
        IdtoAdress[_newadminId] = msg.sender;
        return (_newadminId);
        }
    function getAdminInfo (uint _adminId) public view returns (string memory name, uint adminId, uint status){
        return (adminInfoMapping[_adminId].name, adminInfoMapping[_adminId].adminId, adminInfoMapping[_adminId].status);
    }
    function getAdminArray(uint _adminId) public view returns (uint [] memory requestRecords, uint [] memory changeStatusRecords, uint [] memory createRecords ){

        return(adminInfoMapping[_adminId].requestRecords, adminInfoMapping[_adminId].changeStatusRecords, adminInfoMapping[_adminId].createRecords );
    }
    function changeAdminStatus(uint _adminId, uint _adminParentId, uint _status) public{
        require(addresstoId[msg.sender]==_adminParentId, 'You are not allowed');
        require(adminInfoMapping[_adminParentId].status == 2, 'You are disable');
        require(adminInfoMapping[_adminId].status != _status, 'The status now is this');
        adminInfoMapping[_adminId].status = _status;
        adminInfoMapping[_adminParentId].changeStatusRecords.push(_adminId);

    }
// -----------------Admin function-------------------------

    // --------------Car & Owner function ---------------------------
    function addCarInfo (uint _companyId,uint8 _typeFuel,string memory _carModel,string memory _kind,
                         string memory _style,string memory _chassisNumber, uint _vin,string memory _color,string memory _motor
                        ) 
                         public returns(string memory) {
        

        carInfoMapping[_vin].companyId = _companyId;
        carInfoMapping[_vin].typeFuel = _typeFuel;
        carInfoMapping[_vin].carModel = _carModel;
        carInfoMapping[_vin].kind = _kind;
        carInfoMapping[_vin].style = _style;
        carInfoMapping[_vin].chassisNumber = _chassisNumber;
        carInfoMapping[_vin].color = _color;
        carInfoMapping[_vin].motor = _motor;
        carInfoMapping[_vin].createDate = block.timestamp;

        emit carInfoCreated(_companyId,_typeFuel,_carModel,_kind, _style, _chassisNumber,_vin, _color, _motor);
        
        return "successfully.";
    }

    function getCarInfo (uint _vinId) public view returns (uint companyId,uint8 typeFuel,string memory carModel,string memory kind,
                         string memory style,string memory chassisNumber){
         
        require(carInfoMapping[_vinId].carVinId == _vinId, 'The car is not of this specification');

        return (carInfoMapping[_vinId].companyId,carInfoMapping[_vinId].typeFuel,carInfoMapping[_vinId].carModel,carInfoMapping[_vinId].kind,
                carInfoMapping[_vinId].style,carInfoMapping[_vinId].chassisNumber);
    }

    function addownerInfo (uint _typeLicense,uint _nationalId,
                           string memory _fullName,string memory _birthDay,string memory _licenseNumber,
                           string memory _dateLicense) public returns(string memory) {

        ownerInfoMapping[_nationalId].fullName = _fullName;
        ownerInfoMapping[_nationalId].dateLicense = _dateLicense;
        ownerInfoMapping[_nationalId].typeLicense = _typeLicense;
        ownerInfoMapping[_nationalId].birthDay = _birthDay;
        ownerInfoMapping[_nationalId].licenseNumber = _licenseNumber;
        ownerInfoMapping[_nationalId].dateLicense = _dateLicense;

        emit ownerInfoCreated(_typeLicense, _nationalId, _fullName, _birthDay,
                              _licenseNumber, _dateLicense);
        
         return "successfully.";                       
    }

    function getOwnerInfo (uint _ownerNationalId) 
             public view returns (uint typeLicense,string memory fullName,
                                  string memory birthDay,string memory licenseNumber, string memory dateLicense){
            
        require(ownerInfoMapping[_ownerNationalId].ownerId != _ownerNationalId, 'This Owner does not exist'); 
        return (ownerInfoMapping[_ownerNationalId].typeLicense,
                ownerInfoMapping[_ownerNationalId].fullName,ownerInfoMapping[_ownerNationalId].birthDay,
                ownerInfoMapping[_ownerNationalId].licenseNumber,ownerInfoMapping[_ownerNationalId].dateLicense);

   }

    function ownerAssignedToPlate (uint _carVinId, uint _ownerId, string memory _licensePlateNum)
                                   public returns (string memory) {
         
        require(carInfoMapping[_carVinId].carVinId != _carVinId, 'This Car does not exist');  
        require(ownerInfoMapping[_ownerId].ownerId != _ownerId, 'This Owner does not exist'); 

        uint _licensePlateId = random();    
        licensePlateInfoMapping[_licensePlateId].carVinId = _carVinId;
        licensePlateInfoMapping[_licensePlateId].ownerId = _ownerId;
        licensePlateInfoMapping[_licensePlateId].licensePlateNum = _licensePlateNum;
        
        ownerInfoMapping[_ownerId].licensePlateIds.push(_licensePlateId);

        return "successfully."; 
       
    }

    function getAllLicensePlateAndCarForOwner (uint _ownerId) public view returns(string memory fullName,uint [] memory licensePlateIds,uint [] memory carVinIds) {
        
        require(ownerInfoMapping[_ownerId].ownerId != _ownerId, 'This Owner does not exist'); 

        return(ownerInfoMapping[_ownerId].fullName, ownerInfoMapping[_ownerId].licensePlateIds, ownerInfoMapping[_ownerId].carVinIds );
    }

    function carDeliveryToOwner (uint _carVinId,uint _ownerId,uint _companyId,
                                 uint _licensePlateId, uint _bill,
                                 string memory _deliveryDate)public  payable returns (string memory) {
        
        require(carInfoMapping[_carVinId].carVinId == _carVinId, 'The car is not of this specification');
        require(ownerInfoMapping[_ownerId].ownerId != _ownerId, 'This Owner does not exist'); 
        require(licensePlateInfoMapping[_licensePlateId].licensePlateId == _licensePlateId, 'The license Plate is not of this specification');
       
        uint _carDeliveryId = random();

        carDeliveryMapping[_carDeliveryId].companyId = _companyId;
        carDeliveryMapping[_carDeliveryId].carVinId = _carVinId;
        carDeliveryMapping[_carDeliveryId].licensePlateId = _licensePlateId;
        carDeliveryMapping[_carDeliveryId].deliveryDate = _deliveryDate;
        
        ownerInfoMapping[_ownerId].carVinIds.push(_carVinId);
        carDeliveryMapping[_carDeliveryId].ownerIds.push(_ownerId);
        
        uint amount = _bill * 0.3 ether;
        require(msg.value==amount , "must amount trx");
        payable(IdtoAdress[carDeliveryMapping[_carDeliveryId].signerId]).transfer(amount);

        return "Success";
    }


    function getCarDeliveryInfo (uint _carDeliveryId) 
             public view returns (uint carVinId,uint [] memory ownerIds,uint companyId,
                                  uint agencyId,uint licensePlateId,
                                  string memory _deliveryDate){
        
        require(carDeliveryMapping[_carDeliveryId].carDeliveryId == _carDeliveryId, 'The car is not of this specification');

        return (carDeliveryMapping[_carDeliveryId].carVinId,carDeliveryMapping[_carDeliveryId].ownerIds,carDeliveryMapping[_carDeliveryId].companyId,
                carDeliveryMapping[_carDeliveryId].agencyId,carDeliveryMapping[_carDeliveryId].licensePlateId,carDeliveryMapping[_carDeliveryId].deliveryDate);
    }


    // --------------Car & Owner function ---------------------------

   
    // --------------Insurance Car ----------------------------------

    function addThirdInsuranceInfo(uint _companyId,uint _carVinId, uint _ownerId, uint _financialCommitment,uint _physicalCommitment, uint _driverAccidentCommitment,
                                   string memory _startDate, string memory _endDate,string memory _numberInsurance) public returns (uint thirdInsuranceId) {
        
        uint _thirdInsuranceId = random();    
        thirdInsuranceInfoMapping[_thirdInsuranceId].companyId = _companyId;
        thirdInsuranceInfoMapping[_thirdInsuranceId].carVinId = _carVinId;
        thirdInsuranceInfoMapping[_thirdInsuranceId].ownerId = _ownerId; 
        thirdInsuranceInfoMapping[_thirdInsuranceId].financialCommitment = _financialCommitment; 
        thirdInsuranceInfoMapping[_thirdInsuranceId].physicalCommitment = _physicalCommitment;
        thirdInsuranceInfoMapping[_thirdInsuranceId].driverAccidentCommitment = _driverAccidentCommitment; 
        thirdInsuranceInfoMapping[_thirdInsuranceId].startDate = _startDate;
        thirdInsuranceInfoMapping[_thirdInsuranceId].endDate = _endDate;
        thirdInsuranceInfoMapping[_thirdInsuranceId].numberInsurance = _numberInsurance;

         return _thirdInsuranceId; 

    }

    function addBodyInsuranceInfo (uint _companyId,uint _carVinId, uint _ownerId, uint _countDay, uint _carValue, uint _otherEquipment,
                                   string memory _startDate, string memory _endDate) public returns (uint bodyInsuranceId) {
        
        
        uint _bodyInsuranceId = random();
        bodyInsuranceInfoMapping[_bodyInsuranceId].companyId = _companyId;
        bodyInsuranceInfoMapping[_bodyInsuranceId].countDay = _countDay;
        bodyInsuranceInfoMapping[_bodyInsuranceId].carVinId = _carVinId;
        bodyInsuranceInfoMapping[_bodyInsuranceId].ownerId = _ownerId; 
        bodyInsuranceInfoMapping[_bodyInsuranceId].carValue = _carValue; 
        bodyInsuranceInfoMapping[_bodyInsuranceId].otherEquipment = _otherEquipment;
        bodyInsuranceInfoMapping[_bodyInsuranceId].startDate = _startDate;
        bodyInsuranceInfoMapping[_bodyInsuranceId].endDate = _endDate;

         return _bodyInsuranceId; 

    }


    function insuranceUse(uint _carVinId,uint _insuranceType,uint _ownerId,uint _price,string memory _driver) public returns (uint insuranceUseId) {

         uint _insuranceUseId = random();

        insuranceUseMapping[_insuranceUseId].carVinId = _carVinId;
        insuranceUseMapping[_insuranceUseId].insuranceType = _insuranceType;
        insuranceUseMapping[_insuranceUseId].ownerId = _ownerId;
        insuranceUseMapping[_insuranceUseId].price = _price;
        insuranceUseMapping[_insuranceUseId].driver = _driver;
        insuranceUseMapping[_insuranceUseId].dateUse = block.timestamp;

         return _insuranceUseId; 
    }

    function getThirdInsurance(uint _thirdInsuranceId) 
              public view returns (uint financialCommitment, uint physicalCommitment, 
                                   uint driverAccidentCommitment, string memory startDate, string memory endDate,
                                   string memory numberInsurance) {

           require(thirdInsuranceInfoMapping[_thirdInsuranceId].thirdInsuranceId == _thirdInsuranceId, 'The thirdInsuranceId is not of this specification');

           return (thirdInsuranceInfoMapping[_thirdInsuranceId].financialCommitment,thirdInsuranceInfoMapping[_thirdInsuranceId].physicalCommitment, 
                   thirdInsuranceInfoMapping[_thirdInsuranceId].driverAccidentCommitment, thirdInsuranceInfoMapping[_thirdInsuranceId].startDate, thirdInsuranceInfoMapping[_thirdInsuranceId].endDate,
                   thirdInsuranceInfoMapping[_thirdInsuranceId].numberInsurance); 


    }

    function getBodyInsurance(uint _bodyInsuranceId) 
             public view returns  (uint carVinId, uint ownerId, uint carValue, uint otherEquipment, string memory startDate, string memory endDate, string memory agentCode) {

          require(bodyInsuranceInfoMapping[_bodyInsuranceId].bodyInsuranceId == _bodyInsuranceId, 'The thirdInsuranceId is not of this specification');

           return (bodyInsuranceInfoMapping[_bodyInsuranceId].carVinId,bodyInsuranceInfoMapping[_bodyInsuranceId].ownerId, 
                   bodyInsuranceInfoMapping[_bodyInsuranceId].carValue, bodyInsuranceInfoMapping[_bodyInsuranceId].otherEquipment, 
                   bodyInsuranceInfoMapping[_bodyInsuranceId].startDate,bodyInsuranceInfoMapping[_bodyInsuranceId].endDate, 
                   bodyInsuranceInfoMapping[_bodyInsuranceId].agentCode);                                     

    }

    function getInsuranceUse(uint _insuranceUseId) public view returns(uint carVinId,uint insuranceType,uint ownerId,uint price,string memory driver){

            require(insuranceUseMapping[_insuranceUseId].insuranceUseId == _insuranceUseId, 'The insurance Use Id is not of this specification');

            return (insuranceUseMapping[_insuranceUseId].carVinId,insuranceUseMapping[_insuranceUseId].insuranceType,insuranceUseMapping[_insuranceUseId].ownerId,
                    insuranceUseMapping[_insuranceUseId].price,insuranceUseMapping[_insuranceUseId].driver);
    }
    // -------------Insurance Car -----------------------------------


    function addSmoothingPaintInfo ( uint _warrantyId, uint _companyId, uint _carVinId,uint8 _isColor,
                            string memory _spacePaint, string memory _spaceSmoothing,string memory _description,uint _kilometer
                          ) public returns (string memory) {

        smoothingPaintInfoMapping[_carVinId].warrantyId = _warrantyId;
        smoothingPaintInfoMapping[_carVinId].companyId = _companyId;
        smoothingPaintInfoMapping[_carVinId].carVinId = _carVinId;
        smoothingPaintInfoMapping[_carVinId].isColor = _isColor;
        smoothingPaintInfoMapping[_carVinId].spacePaint = _spacePaint;
        smoothingPaintInfoMapping[_carVinId].spaceSmoothing = _spaceSmoothing;
        smoothingPaintInfoMapping[_carVinId].kilometer = _kilometer;
        smoothingPaintInfoMapping[_carVinId].description = _description;

        return "Successfully."; 

    }

    function addWarrantyInfo (uint _companyId, uint _carVinId, uint8 _typeWarranty,
                                  string memory _startDate, string memory _endDate,uint _maxKilometer
                          ) public returns (string memory) {


        warrantyInfoMapping[_carVinId].companyId = _companyId;
        warrantyInfoMapping[_carVinId].carVinId = _carVinId;
        warrantyInfoMapping[_carVinId].typeWarranty = _typeWarranty;
        warrantyInfoMapping[_carVinId].startDate = _startDate;
        warrantyInfoMapping[_carVinId].endDate = _endDate;
        warrantyInfoMapping[_carVinId].maxKilometer = _maxKilometer;


        return "Successfully."; 

    }


    function addRepairsInfo (uint _warrantyId, uint _companyId, uint _carVinId,
                                uint _kilometer, string memory _serviceDate,string memory _reasonReferral, string memory _diagnosis,
                                uint8 _operation, string memory _namePiece, string memory _reasonReplacePiece, string memory _description
                          ) public returns (string memory) {

        repairsInfoMapping[_carVinId].warrantyId = _warrantyId;
        repairsInfoMapping[_carVinId].companyId = _companyId;
        repairsInfoMapping[_carVinId].carVinId = _carVinId;
        repairsInfoMapping[_carVinId].kilometer = _kilometer;
        repairsInfoMapping[_carVinId].serviceDate = _serviceDate;
        repairsInfoMapping[_carVinId].reasonReferral = _reasonReferral;
        repairsInfoMapping[_carVinId].diagnosis = _diagnosis;
        repairsInfoMapping[_carVinId].operation = _operation;
        repairsInfoMapping[_carVinId].namePiece = _namePiece;
        repairsInfoMapping[_carVinId].reasonReplacePiece = _reasonReplacePiece;
        repairsInfoMapping[_carVinId].description = _description;

        return "successfully."; 

    }


    function getSmoothingPaintInfo(uint _carVinId) public view returns ( uint warrantyId, uint companyId, uint carVinId,uint8 isColor,
                            string memory spacePaint, string memory spaceSmoothing,string memory description) {

         require(smoothingPaintInfoMapping[_carVinId].carVinId == _carVinId, 'No records have been registered');

            return (smoothingPaintInfoMapping[_carVinId].warrantyId,smoothingPaintInfoMapping[_carVinId].companyId,smoothingPaintInfoMapping[_carVinId].carVinId,
                    smoothingPaintInfoMapping[_carVinId].isColor,smoothingPaintInfoMapping[_carVinId].spacePaint,
                    smoothingPaintInfoMapping[_carVinId].spaceSmoothing,smoothingPaintInfoMapping[_carVinId].description);
    }

    function getWarrantyInfo (uint _carVinId)
                            public view returns(uint companyId, uint carVinId, uint8 typeWarranty,
                                                string memory startDate, string memory endDate,uint maxKilometer)
    {
        return (warrantyInfoMapping[_carVinId].companyId,warrantyInfoMapping[_carVinId].carVinId,warrantyInfoMapping[_carVinId].typeWarranty,
                warrantyInfoMapping[_carVinId].startDate,warrantyInfoMapping[_carVinId].endDate,warrantyInfoMapping[_carVinId].maxKilometer);
    }

    function getRepairsInfo(uint _carVinId)
             public view returns(uint warrantyId, uint companyId, uint carVinId,
                                 string memory serviceDate,string memory reasonReferral, string memory diagnosis,
                                 string memory namePiece)
    {
        require(repairsInfoMapping[_carVinId].carVinId == _carVinId, 'No records have been registered');

        return (repairsInfoMapping[_carVinId].warrantyId,repairsInfoMapping[_carVinId].companyId,repairsInfoMapping[_carVinId].carVinId,
               repairsInfoMapping[_carVinId].serviceDate,repairsInfoMapping[_carVinId].reasonReferral,repairsInfoMapping[_carVinId].diagnosis,
               repairsInfoMapping[_carVinId].namePiece);
    }
}