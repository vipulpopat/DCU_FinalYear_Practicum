// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract AIModelRegistry {
    struct AIModel {
        address clientAddress;
        string clientIdentifier;
        string modelType;
        string hash1;
        string hash2;
        string hash3;
        uint256 timestamp;
    }

    mapping(uint256 => AIModel) public models;
    uint256 public modelCount;

    function registerModel(
        string memory _clientIdentifier,
        string memory _modelType,
        string memory _hash1,
        string memory _hash2,
        string memory _hash3
    )
        public
    {
        uint256 currentTimestamp = block.timestamp;
        AIModel memory newModel = AIModel(msg.sender, _clientIdentifier, _modelType, _hash1, _hash2, _hash3, currentTimestamp);
        models[modelCount] = newModel;
        modelCount++;
    }

    function getModelByIndex(uint256 _index)
        public
        view
        returns (
            address,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            uint256
        )
    {
        require(_index < modelCount, "Invalid index");

        AIModel memory model = models[_index];
        return (model.clientAddress, model.clientIdentifier, model.modelType, model.hash1, model.hash2, model.hash3, model.timestamp);
    }

    function getModelsByType(string memory _modelType) public view returns (uint256[] memory) {
        uint256 matchingModelCount = 0;

        // Count the number of models that match the given model type
        for (uint256 i = 0; i < modelCount; i++) {
            AIModel memory model = models[i];
            if (compareStrings(model.modelType, _modelType)) {
                matchingModelCount++;
            }
        }

        // Create an array to store the matching model indexes
        uint256[] memory matchingModelIndexes = new uint256[](matchingModelCount);
        uint256 currentIndex = 0;

        // Store the matching model indexes in the array
        for (uint256 i = 0; i < modelCount; i++) {
            AIModel memory model = models[i];
            if (compareStrings(model.modelType, _modelType)) {
                matchingModelIndexes[currentIndex] = i;
                currentIndex++;
            }
        }

        return matchingModelIndexes;
    }

     function getAIModelByClientIdentifier(string memory _clientIdentifier)
        public
        view
        returns (
            address,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            uint256
        )
    {
        for (uint256 i = 0; i < modelCount; i++) {
            AIModel memory model = models[i];
            if (compareStrings(model.clientIdentifier, _clientIdentifier)) {
                return (
                    model.clientAddress,
                    model.clientIdentifier,
                    model.modelType,
                    model.hash1,
                    model.hash2,
                    model.hash3,
                    model.timestamp
                );
            }
        }

        revert("No model found with the given client identifier");
    }

    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }
}
