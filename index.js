var Web3 = require('web3');

//-----------------------------------------------------------
// STEP 1: - record the deployed smart contract addresses to actor
//-----------------------------------------------------------
console.log(">>>> STEP 1: - record the deployed smart contract addresses to actor.<<<<");

var actorToSmartContractAddr = {};
var actorToSmartContractAbi = {};
var actorToSmartContractUrl = {};
// for instance: actorToSmartContract['S1_buyer']="<smart contract address>";
// for instance: actorToSmartContractAbi['S1_buyer']="<smart contract abi>";
// for instance: actorToSmartContractAbi['S1_buyer']="<smart contract url>";


//-----------------------------------------------------------
// STEP 2: - record all the states / tasks of BPMN
// (hint: 1. the state ID should match the state ID in smart contract;
//        2. add a property such as "actorName".)
//-----------------------------------------------------------
console.log(">>>> STEP 2: - record all the states / tasks of BPMN.<<<<");
var states = [];
// for instance:
// var INIT = State({
//    STATEID: "INIT",
//    actorName: "partial_on_chain",
//    OUTPUTDATA: "",
//    INPUTDATA: ""
//});

// var Prepare_Purchase_Document = State({
//    STATEID: "Prepare_Purchase_Document",
//    actorName: "S1_buyer",
//    OUTPUTDATA: "",
//    INPUTDATA: ""
//});
// states.add(INIT); states.add(Prepare_Purchase_Document);

//-----------------------------------------------------------
// STEP 3: - draw the path from start to the end of BPMN diagram
//-----------------------------------------------------------
console.log(">>>> STEP 3: - draw the path from start to the end of BPMN diagram.<<<<");
var transitions = [];
// for instance:
// transitions.add(['INIT','Prepare_Purchase_Document']);


//-----------------------------------------------------------
// STEP 4: - define the funtcion to look up the next task / state by id
//-----------------------------------------------------------
console.log(">>>> STEP 4: - define the funtcion to look up the next task / state by id.<<<<");
// for instance:
function lookUpNextTask(currentID) {
  // 4.1 : look at the next step from transitions of step 3:
  transitions.forEach(pair => {
    if (pair[0] == currentID) {
      return pair[1];
    }
  });

}

//-----------------------------------------------------------
// STEP 5: - look up the info of task / state by id
//-----------------------------------------------------------
console.log(">>>> STEP 5: - look up the info of task / state by id.<<<<");
// for instance:
function lookTaskInfo(currentID) {
  // 4.1 : look at the next step from transitions of step 3:
  states.forEach(state => {
    if (state['STATEID'] == currentID) {
      return state;
    }
  });

}

//-----------------------------------------------------------
// STEP 6: - create function to call resvStateChanges of each smart contract as necessary
// function resvStateChanges(
//   string memory transactionId,
//   string memory stateid,
//   string memory newStateid,
//   string memory input,
//   string memory encyptedMsg
// )
//-----------------------------------------------------------
var callFuncOnLocalGanacheOrPublic = async function (url, abi, contractAddr, transactionId, currentId, newStateid, extraInput, encyptedMsg) {
  // let web3 = new Web3("http://localhost:8545");
  return new Promise(async (resolve, reject) => {
    var web3 = new Web3(new Web3.providers.HttpProvider(url));
    const accounts = await web3.eth.getAccounts();
    web3.eth.defaultAccount = accounts[0];
    console.log(web3.eth.defaultAccount);
    // var CoursetroContract = new web3.eth.Contract(abi);
    // var Coursetro = CoursetroContract.at(contractAddr);
    var myContract = new web3.eth.Contract(abi, contractAddr, { from: web3.eth.defaultAccount })
    // function store(uint256 num)
    myContract.methods.store(num)
      .send({ from: web3.eth.defaultAccount })
      .then(function (recippt) {
        console.log("recippt:", JSON.stringify(recippt, null, 4))
        resolve(recippt);
      }).
      catch(error => {
        console.log(error)
        reject(error);
      }
      )

  });
}

//-----------------------------------------------------------
// STEP 7: - simulate work flow to execute task start to the end
//-----------------------------------------------------------
// for instance:

function recursiveCalls(stateid) {
  var start = lookTaskInfo(stateid);
  var url = actorToSmartContractUrl[start['actorName']]
  var abi = actorToSmartContractAbi[start['actorName']]
  var contractAddr = actorToSmartContractAddr[start['actorName']]
  var newStateid = lookUpNextTask(stateid)
  callFuncOnLocalGanacheOrPublic(url, abi, contractAddr, transactionId, stateid, newStateid, extraInput, encyptedMsg).then(function (recippt) {
    console.log("recippt:", JSON.stringify(recippt, null, 4))

    setTimeout(function () {
      // if (newState == -1) {
      recursiveCalls(newStateid);

      // }
    }, 500);
  }).
    catch(error => {
      console.log(error)
    }
    )
}


//-----------------------------------------------------------
// STEP 8 invocation: - invoke the simulation of step 7
//-----------------------------------------------------------
// for instance:
recursiveCalls('INIT');