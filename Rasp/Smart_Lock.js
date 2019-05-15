var Web3 = require('web3');
const Gpio = require('pigpio').Gpio;
const motor = new Gpio(4, {mode: Gpio.OUTPUT});
/*if (typeof web3 !== 'undefined'){
    web3 = new Web3(web3.currentProviser);
}
else{
    web3 = new Web3(new Web3.providers.WebsocketProvider('https://ropsten.infura.io/v3/f5d73387417c4ab580f668afc4915762'));
}*/

//var web3 = new Web3(new Web3.providers.HttpProvider('https://ropsten.infura.io/v3/f5d73387417c4ab580f668afc4915762'));
/*const RINKEBY_WSS = "wss://rinkeby.infura.io/ws/v3/f5d73387417c4ab580f668afc4915762";
var provider = new Web3.providers.WebsocketProvider(RINKEBY_WSS);
var web3 = new Web3(provider);*/
let web3 = new Web3(
  // Replace YOUR-PROJECT-ID with a Project ID from your Infura Dashboard
  new Web3.providers.WebsocketProvider("wss://ropsten.infura.io/ws/v3/f5d73387417c4ab580f668afc4915762")
);

//var web3 = new Web3('https://ropsten.infura.io/v3/f5d73387417c4ab580f668afc4915762');
var Gpio = require('onoff').Gpio;
var green = new Gpio(16,'out');
var red = new Gpio(26,'out');
var coinbase = web3.eth.coinbase;
var ABIString =  
[
	{
		"constant": true,
		"inputs": [],
		"name": "Locked",
		"outputs": [
			{
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "id",
				"type": "uint256"
			}
		],
		"name": "forRent",
		"outputs": [
			{
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "id",
				"type": "uint256"
			}
		],
		"name": "remove_from_rent",
		"outputs": [
			{
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "x",
				"type": "uint8"
			},
			{
				"name": "id",
				"type": "uint256"
			}
		],
		"name": "getRent",
		"outputs": [
			{
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "for_Rent",
		"outputs": [
			{
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "id",
				"type": "uint256"
			}
		],
		"name": "stopRent",
		"outputs": [
			{
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "Rented",
		"outputs": [
			{
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "returnValue",
				"type": "bool"
			},
			{
				"indexed": false,
				"name": "id",
				"type": "uint256"
			}
		],
		"name": "bikeRented",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "returnValue",
				"type": "bool"
			},
			{
				"indexed": false,
				"name": "id",
				"type": "uint256"
			}
		],
		"name": "rentStop",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "returnValue",
				"type": "bool"
			},
			{
				"indexed": false,
				"name": "id",
				"type": "uint256"
			}
		],
		"name": "postRent",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "returnValue",
				"type": "bool"
			},
			{
				"indexed": false,
				"name": "id",
				"type": "uint256"
			}
		],
		"name": "removeRent",
		"type": "event"
	}
]

//var ABI = JSON.parse(ABIString);
var ContractAddress = '0xac746bfaeb037cb900abf016765bb75d64b61626';
web3.eth.defaultAccount = web3.eth.accounts[0];
const simpleiot = web3.eth.Contract(ABIString,ContractAddress);
console.log("hello");
const id = 1;
/*if (true === web3.isConnected() ){
	console.log("connected");
}*/

console.log(web3.eth.getNodeInfo()+"");

var event1 = simpleiot.events.postRent({filter : {id :1}, }, function (error, result){
	
	if(!error){
		green.writeSync(1);
		console.log("greenon")
	}
			
	
}) ;

var event2 = simpleiot.events.removeRent({}, function (error, result){
	
	if(!error){
		green.writeSync(0);
		console.log("greenoff")
	}
			
	
}) ;
var event3 = simpleiot.events.bikeRented({}, function (error, result){
	
	if(!error){
		red.writeSync(1);
		console.log("redon")
	}
			
	
}) ;
var event4 = simpleiot.events.rentStop({}, function (error, result){
	
	if(!error){
		red.writeSync(0);
		console.log("redoff")
	}
			
	
}) ;

var event5 = simpleiot.events.lock_open({}, function (error, result){
	
	if(!error){
		motor.servoWrite(1500);
		console.log("lock_open")
	}
			
	
}) ;

var event5 = simpleiot.events.lock_close({}, function (error, result){
	
	if(!error){
		motor.servoWrite(0);
		console.log("lock_close")
	}
			
	
}) ;
