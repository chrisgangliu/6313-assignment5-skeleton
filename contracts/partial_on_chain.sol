import "./abstractFSM.sol";

contract partial_on_chain is actorFSM {

    constructor() public {


owner = ownerAccounts['partial_on_chain'];
addToTransitions("INIT", "Gateway_0c2ssha","","");
addToTransitions("Gateway_0c2ssha", "SUCCESS","","");
State memory INIT = State({
    STATEID: "INIT",
    TYPE: "crosschain",
    conditions: "",
    LEVEL: 0,
    OUTPUTDATA: "",
    INPUTDATA: ""
});
states.push(INIT);
State memory Gateway_0c2ssha = State({
    STATEID: "Gateway_0c2ssha",
    TYPE: "crosschain",
    conditions: "",
    LEVEL: 2,
    OUTPUTDATA: "",
    INPUTDATA: ""
});
states.push(Gateway_0c2ssha);
State memory SUCCESS = State({
    STATEID: "SUCCESS",
    TYPE: "crosschain",
    conditions: "",
    LEVEL: 4,
    OUTPUTDATA: "",
    INPUTDATA: ""
});
states.push(SUCCESS);

        // ipfsAddr = ipfsActorAddresses['actor'];


    }
//<editable>
//</editable>
}