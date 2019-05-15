pragma solidity >=0.4.0 <0.7.0;

contract simpleIOT {
    uint bikerent = 10 ;
    uint bikesell = 10 ;
    bool public for_Rent ;
    bool public  Rented ;
    bool public Locked ;   
    uint bike_id = 1;

    event bikeRented(bool returnValue , uint id);
    function   getRent (uint8 x ,uint id) public  returns (bool){
        if (x==bikerent){
            emit bikeRented(true, id);
            return true ;
        }
    }
    
    event rentStop(bool returnValue , uint id);
    function stopRent (uint id) public  returns (bool){
        
        emit rentStop(true ,  id);
        return true ;
        
    }
    
    event postRent(bool returnValue , uint id) ;
    function forRent (uint id) public  returns (bool){
        
        emit postRent(true, id);
        return true ;
        
    }
    
    
    event removeRent(bool returnValue , uint id );
    function remove_from_rent (uint id) public  returns (bool){
        
        emit removeRent(true ,  id);
        return true ;
        
    }
    
    event lock_open(bool returnValue , uint id );
    function openLock (uint id) public  returns (bool){
        
        emit lock_open(true ,  id);
        return true ;
        
    }
    
    event lock_close(bool returnValue , uint id );
    function closeLock (uint id) public  returns (bool){
        
        emit lock_open(true ,  id);
        return true ;
        
    }
    
    
}