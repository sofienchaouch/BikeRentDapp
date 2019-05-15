pragma solidity ^0.5.0;

contract BikeRent{

    //owner address
    address payable  private  _owner;

    //constructor initialise owner address
    /* owner can initialise users to be authenticated  / users are aleardy created by the the admin */
    constructor() public{
        _owner = msg.sender;
     //   add_user(0x14723a09acff6d2a60dcdf7aa4aff308fddc160c,1,"sofien","13009753","sofien.chaouch@gmail.com","55432015");

    }

    //structures

    // define user struct  X
    struct User {
        address  user_address;
        uint id ;
        string name;
        string cin;
        string mail;
        string phone_number;
        uint Bike_Rented_id;
        uint personal_Bike_id;
        uint keyfirst ;
        uint keysecond ;

    }
    /*config des contarinte _ pénalité extra */
    //defien bike struct
    struct Bike {
        uint id ;
        string location ;
        bool for_rent;
        uint price;
        string bike_type;
        address payable owner;
        bool locked;
        //rent mesurments
        address renter;
        uint max_time ;
        uint begin_rent_time;
        uint payed;
        uint key;

    }


    //Modifiers

    // Modifier Only contract owner can do this
    modifier onlyOwner() {
        require(
            msg.sender == _owner

        );
        _;
    }

    //user can open the lock if he have the correct key
    modifier HaveKey(uint bike_id){
        require(id_to_bike[bike_id].key ==  address_to_user[msg.sender].keyfirst || id_to_bike[bike_id].key == address_to_user[msg.sender].keysecond);
        _;
    }

    //ARRAYS AND MAPPINGS

 //   Bike[] public   for_rent;
    address[]  public  users ;
    uint[] public  bikes_id  ;
    mapping (address => User) public  address_to_user;
 //   mapping (uint => User) public id_to_user;
//    mapping (address => Bike) public  owner_to_bike ;
    mapping (uint => Bike)  public  id_to_bike;
 //   mapping (uint => Bike ) public  Bikes_For_Rent  ;


    //events

    event NewUser(uint usr_id , string usr_name);
    event NewBike(uint id , address Bike_owner_addr );
    event user_removed(address addr);
    event bike_For_rent(uint bike_id ,bool state , string location ,address owner_addr);
    event Bike_removed(uint bike_id);
    event Bike_rent_removed(uint bike_id);



    //fonctions

    // adding users function only by the contract owner
    function add_user(
        address  _user_address,
        uint _id ,
        string memory _name,
        string memory  _cin,
        string memory _mail,
        string memory _phone_number
        )
        public onlyOwner {
        User memory usr = User(_user_address,_id,_name,_cin,_mail,_phone_number,0,0,0,0);
        address_to_user[_user_address] = usr;
        users.push(_user_address);
        emit NewUser(_id,_name);

    }



    // adding bike only one allowed per user / owner can add more than one
    function add_Bike(
        uint  _id ,
        string memory _position ,
        bool _for_rent,
        uint  _price,
        string memory _bike_type



        ) public {
        if (msg.sender!= _owner && address_to_user[msg.sender].personal_Bike_id != 0){
            revert();
        }else{
            Bike memory bike = Bike(_id,_position,_for_rent,_price,_bike_type,msg.sender,false,address(0),0,0,generate_Key(),0);
         //   bikes.push(bike);
        //    owner_to_bike[msg.sender] = bike;
            address_to_user[msg.sender].personal_Bike_id = _id;
            id_to_bike[_id]=bike;
            bikes_id.push(_id);
            emit NewBike(_id,msg.sender);
        }


    }


    // remove users function only allowed for the contract owner
    function Remove_user(address user_to_remove) public  onlyOwner{
        delete address_to_user[user_to_remove];
      /*  for (uint i = 0 ; i< users.length; i++ ){
            if (users[i].user_address == user_to_remove){
                for (uint j = i ; j < users.length - 1; j++) {
                    users[j] = users[j + 1];
                    delete users[users.length - 1];
                    users.length--;
                }
                break;
            }
        }*/
        emit user_removed(user_to_remove);
    }

    //remove bike from the platform
    function delete_Bike(uint id) public  {
        if(msg.sender == id_to_bike[id].owner){
            delete id_to_bike[id];
       //     delete owner_to_bike[msg.sender];
       /*   for (uint i = 0 ; i< bikes.length; i++ ){
                if (bikes[i].id == id){
                    for (uint j = i ; j < bikes.length - 1; j++) {
                        bikes[j] = bikes[j + 1];
                        delete bikes[bikes.length - 1];
                        bikes.length--;
                    }
                    break;
                }
            }*/
            emit Bike_removed(id);
        }
    }


    // user can modifie only  his mail and phone in his account
    function edit_profile(string memory _mail, string memory _phone ) public {
        address_to_user[msg.sender].mail = _mail;
        address_to_user[msg.sender].phone_number = _phone;

    }



    //user post his bike for rent
    function user_post_bike_for_rent() public{
       // id_to_bike[address_to_user[msg.sender].personal_Bike_id].for_rent = true ;
        id_to_bike[address_to_user[msg.sender].personal_Bike_id].for_rent = true ;
        Bike storage bike = id_to_bike[address_to_user[msg.sender].personal_Bike_id];
       // Bikes_For_Rent[bike.id]=bike;
        emit bike_For_rent(bike.id,bike.for_rent,bike.location,msg.sender);
    }


    // admin can  post post more than one bike by the bike_id
    function admin_post_bike_for_rent(uint _bike_id) public onlyOwner{
        id_to_bike[_bike_id].for_rent = true ;
        Bike storage bike =  id_to_bike[_bike_id];
     //   Bikes_For_Rent[bike.id] = bike ;
        emit bike_For_rent(_bike_id,bike.for_rent,bike.location,_owner);
    }


    //user remove make his bike out of service for rent
    function user_remove_From_rent() public{
       // delete Bikes_For_Rent[address_to_user[msg.sender].personal_Bike_id];
        id_to_bike[address_to_user[msg.sender].personal_Bike_id].for_rent = false ;
        emit Bike_removed(address_to_user[msg.sender].personal_Bike_id);
    }

    // admin remove make his bikes out of service
    function admin_remove_From_rent(uint id) public onlyOwner {
        if (id_to_bike[id].owner != _owner){
            revert();
        }else{
            id_to_bike[id].for_rent = false ;
        //    delete Bikes_For_Rent[id];
        /*  for (uint i = 0 ; i< for_rent.length; i++ ){
                if (for_rent[i].id == id){
                    for (uint j = i ; j < for_rent.length - 1; j++) {
                        for_rent[j] = for_rent[j + 1];
                        delete for_rent[for_rent.length - 1];
                        for_rent.length--;
                    }
                    break;
                }
            }*/
            emit Bike_rent_removed(id);
        }

    }




   //user  rent a bike
   //**************** require msg.sender exist
   function Rent_Bike(uint b_id , uint max_hour)  external payable    {
        require (msg.value == id_to_bike[b_id].price*max_hour &&  id_to_bike[b_id].for_rent == true);

        id_to_bike[b_id].renter = msg.sender;
        id_to_bike[b_id].payed = id_to_bike[b_id].price*max_hour;
        id_to_bike[b_id].begin_rent_time = now ;
        address_to_user[msg.sender].Bike_Rented_id = b_id;
        if(id_to_bike[b_id].owner == _owner ){
            _owner.transfer(msg.value);

        }else{
            _owner.transfer(msg.value*10/100);
            id_to_bike[b_id].owner.transfer(msg.value*80/100);
        }
        uint key = generate_Key();
        id_to_bike[b_id].key = key ;
        id_to_bike[b_id].max_time = max_hour;
        address_to_user[msg.sender].keysecond = key ;


    }


    //renter stop and end his renting operation
   function stop_rent(string memory new_location) public payable{
        Bike storage bike = id_to_bike[address_to_user[msg.sender].Bike_Rented_id];
        if(bike.owner == _owner){
            if(now - bike.begin_rent_time >  bike.max_time){
                _owner.transfer ( bike.price* ( (now - bike.begin_rent_time) ) - msg.value );
            }else{
                msg.sender.transfer ( msg.value - bike.price*(now - bike.begin_rent_time) );

            }

        }else{
            if(now - bike.begin_rent_time >  bike.max_time){
                if(keccak256(abi.encodePacked(new_location)) == keccak256(abi.encodePacked(bike.location))){
                    _owner.transfer (2* bike.price* ( (now - bike.begin_rent_time) - bike.max_time)*10/100);
                    bike.owner.transfer( 2*bike.price* ( (now - bike.begin_rent_time) - bike.max_time)*80/100);
                }else{
                    _owner.transfer (3* bike.price* ( (now - bike.begin_rent_time) - bike.max_time)*10/100);
                    bike.owner.transfer( 3*bike.price* ( (now - bike.begin_rent_time) - bike.max_time)*80/100);
                }

            }else{
                if(keccak256(abi.encodePacked(new_location)) == keccak256(abi.encodePacked(bike.location))){
                    msg.sender.transfer ( bike.price* ( bike.max_time - (now - bike.begin_rent_time) ));
                }

            }
        }

        id_to_bike[address_to_user[msg.sender].Bike_Rented_id].for_rent = true;
        id_to_bike[address_to_user[msg.sender].Bike_Rented_id].renter = address(0);
        id_to_bike[address_to_user[msg.sender].Bike_Rented_id].locked = true;
        id_to_bike[address_to_user[msg.sender].Bike_Rented_id].max_time = 0;
        id_to_bike[address_to_user[msg.sender].Bike_Rented_id].begin_rent_time = 0;
        id_to_bike[address_to_user[msg.sender].Bike_Rented_id].payed = 0;
        id_to_bike[address_to_user[msg.sender].Bike_Rented_id].location = new_location;
        address_to_user[msg.sender].Bike_Rented_id = 0 ;
        uint key = generate_Key();
        address_to_user[bike.owner].keyfirst = key ;
        id_to_bike[address_to_user[msg.sender].Bike_Rented_id].key = key ;


    }


    // require key
    function openLock(uint b_id) public  HaveKey(b_id) {
        id_to_bike[b_id].locked = false;
    }

    //require key
    function closeLock(uint b_id) public HaveKey(b_id){
        id_to_bike[b_id].locked = true;

    }

    function destruct_contract() public  onlyOwner{
        selfdestruct(_owner) ;
    }

    function generate_Key() public view returns (uint) {
        uint randomnumber = uint(keccak256(abi.encodePacked(now, msg.sender))) % 900;
        randomnumber = randomnumber + 100;
        return randomnumber;
    }




}
