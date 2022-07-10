contract partial_on_chain is actorFSM, TABSERC20 {

    constructor() public {
balanceOf[address(0xEE69ed07b62Ef7Fce9aE72048d3bb6dD64Ab35E7)]=10000;

balanceOf[address(0x0388CeE553325BCbc64512E2c460C5f539522d1E)]=10000;

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