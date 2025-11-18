// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VotingSystem {
    enum PollState {
        NotStarted,
        Running,
        Finished
    }

    PollState public pollState;

    string[] public candidates;
    mapping(string => uint256) public votes;
    mapping(address => bool) public hasVoted;

    event PollStarted();
    event Voted(address voter, string candidate);
    event PollEnded();

    cconstructor(string[] memory _candidates) {
        candidates = _candidates;
        pollState = PollState.NotStarted;
    }

    function startPoll() external {
        require(pollState == PollState.NotStarted, "Already started");
        pollState = PollState.Running;
        emit PollStarted();
    }

    function vote(string calldata _candidate) external {
        require(pollState == PollState.Running, "Poll not running");
        require(!hasVoted[msg.sender], "Already voted");

        bool exists = false;
        for (uint256 i = 0; i < candidates.length; i++) {
            if (
                keccak256(bytes(candidates[i])) == keccak256(bytes(_candidate))
            ) {
                exists = true;
                break;
            }
        }
        require(exists, "Invalid candidate");

        votes[_candidate]++;
        hasVoted[msg.sender] = true;

        emit Voted(msg.sender, _candidate);
    }

    function endPoll() external {
        require(pollState == PollState.Running, "Not running");
        pollState = PollState.Finished;
        emit PollEnded();
    }

    function getCandidates() external view returns (string[] memory) {
        return candidates;
    }
}

//Concepts used in this contract:
//1. Enums: Define the different states of the poll (NotStarted, Running, Finished).
//2. Mappings: Track votes for each candidate and whether an address has voted.
//3. Events: Log significant actions (PollStarted, Voted, PollEnded).

//Here are some keywords defined used in this contract:
//1. Enums: A user-defined type that consists of a set of named values. In this contract, 'PollState' is an enum that defines the various states of the voting poll.
//2. Mappings: A data structure that associates keys with values. Here, 'votes' maps candidate names to their vote counts, and 'hasVoted' tracks whether an address has already voted.
//3. Events: Mechanisms to log information on the blockchain. The 'PollStarted', 'Voted', and 'PollEnded' events log key actions taken during the voting process.
//4. Access Control: Functions like 'startPoll', 'vote', and 'endPoll' include require statements to ensure they are called only in appropriate poll states, enforcing the correct flow of the voting process.

    
