// SPDX-License-Identifier: MIT

pragma solidity 0.8.22;

contract Dvoting {
    address[] private voters; // Array to store addresses of registered voters

    // Struct to define a proposal
    struct Proposal {
        uint256 ID; // Unique identifier for the proposal
        string Descr; // Description of the proposal
        uint256 Timestamp; // Timestamp when the proposal was created
        uint256 votecount; // Number of votes received by the proposal
        address ProposalSender; // Address of the sender who proposed the proposal
    }

    // Event emitted when a new proposal is added
    event proposalAdded(uint256 ID, string Descr);

    // Event emitted when a voter is deregistered
    event VoterDeregistered(address indexed voter);

    // Array to store all proposals
    Proposal[] public Proposals;

    // Mapping to check if an address is already registered
    mapping(address => bool) private isAlreadyRegister;

    // Mapping to check if an address has already proposed a proposal
    mapping(address => bool) private hasProposed;

    // Mapping to check if an address has already voted
    mapping(address => bool) private hasVoted;

    // Variables to store proposal and voting periods
    uint256 public proposalStartTime;
    uint256 public proposalEndTime;
    uint256 public votingStartTime;
    uint256 public votingEndTime;

    // Modifier to restrict functions to only registered voters
    modifier onlyRegister {
        require(isAlreadyRegister[msg.sender], "Register voter only.");
        _;
    }

    // Modifier to restrict voting to voters who haven't already voted
    modifier notAlreadyvoted {
        require(!hasVoted[msg.sender], "Voter has already voted.");
        _;
    }

    // Modifier to check if the current time is within the proposal submission period
    modifier proposaltimeout {
        require(block.timestamp >= proposalStartTime && block.timestamp <= proposalEndTime, "Proposal submission period has ended.");
        _;
    }

    // Modifier to check if the current time is within the voting period
    modifier votingtimeout {
        require(block.timestamp >= votingStartTime && block.timestamp <= votingEndTime, "Voting period has ended.");
        _;
    }

    // Constructor to initialize proposal and voting periods
    constructor(uint256 _proposalDuration, uint256 _votingDuration) {
        proposalStartTime = block.timestamp;
        proposalEndTime = proposalStartTime + _proposalDuration;
        votingStartTime = proposalEndTime + 1;
        votingEndTime = votingStartTime + _votingDuration;
    }

    // Function to register a voter
    function getRegister() public {
        require(!isAlreadyRegister[msg.sender], "Already register.");
        voters.push(msg.sender);
        isAlreadyRegister[msg.sender] = true;
    }

    // Function to propose a new proposal
    function propose(uint256 _proposalNo, string memory _proposalDes) public onlyRegister proposaltimeout {
        require(!hasProposed[msg.sender], "Already proposed.");
        Proposals.push(Proposal(_proposalNo, _proposalDes, block.timestamp, 0, msg.sender));
        hasProposed[msg.sender] = true;
        emit proposalAdded(_proposalNo, _proposalDes);
    }

    // Function for a voter to vote on a proposal
    function vote(uint256 ProposalId) external onlyRegister votingtimeout {
        require(ProposalId < Proposals.length);
        Proposals[ProposalId].votecount++;
        hasVoted[msg.sender] = true;
    }

    // Function to get the total number of proposals
    function getProposalscount() external view returns(uint256 count) {
       return count = Proposals.length;
    }

    // Function to determine the winning proposal
    function Winner() external view returns(address winner) {
        uint256 maxVotes = 0;
        for(uint256 i = 0; i < Proposals.length; i++) {
            if(maxVotes < Proposals[i].votecount) {
                maxVotes = Proposals[i].votecount;
                return winner = Proposals[i].ProposalSender;
            }
        }
    }

    // Function to deregister a voter
    function deregister() public onlyRegister {
        require(isAlreadyRegister[msg.sender], "Not register.");
        isAlreadyRegister[msg.sender] = false;
        emit VoterDeregistered(msg.sender);
    }
}
