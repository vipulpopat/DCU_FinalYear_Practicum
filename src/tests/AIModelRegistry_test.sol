// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "remix_tests.sol"; // this import is automatically injected by Remix.
import "hardhat/console.sol";
import "../contracts/3_AIModelRegistry.sol";


contract TestAIModelRegistry {
    AIModelRegistry public registry;

    function beforeEach() public {
        registry = new AIModelRegistry();
    }

    function testRegisterModel() public {
        address clientAddress = address(0x123);
        string memory modelType = "Model A";
        string memory hash1 = "hash1";
        string memory hash2 = "hash2";
        string memory hash3 = "hash3";

        registry.registerModel("cid1" , modelType, hash1, hash2, hash3);

        uint256 expectedCount = 1;
        Assert.equal(registry.modelCount(), expectedCount, "Model count should be 1");

        (address retrievedAddress, , string memory retrievedModelType, string memory retrievedHash1, string memory retrievedHash2, string memory retrievedHash3, uint256 retrievedTimestamp) = registry.getModelByIndex(0);

        Assert.equal(retrievedAddress, clientAddress, "Client address should match");
        Assert.equal(retrievedModelType, modelType, "Model type should match");
        Assert.equal(retrievedHash1, hash1, "Hash1 should match");
        Assert.equal(retrievedHash2, hash2, "Hash2 should match");
        Assert.equal(retrievedHash3, hash3, "Hash3 should match");
        Assert.equal(retrievedTimestamp, block.timestamp, "Timestamp should be current timestamp");
    }

    function testGetModelByIndex() public {
        // Register multiple models
        registry.registerModel("cid1", "Model A", "hash1", "hash2", "hash3");
        registry.registerModel("cid2", "Model B", "hash4", "hash5", "hash6");

        (address retrievedAddress, , string memory retrievedModelType, string memory retrievedHash1, string memory retrievedHash2, string memory retrievedHash3, uint256 retrievedTimestamp) = registry.getModelByIndex(1);

        Assert.equal(retrievedAddress, address(0x456), "Client address should match");
        Assert.equal(retrievedModelType, "Model B", "Model type should match");
        Assert.equal(retrievedHash1, "hash4", "Hash1 should match");
        Assert.equal(retrievedHash2, "hash5", "Hash2 should match");
        Assert.equal(retrievedHash3, "hash6", "Hash3 should match");
        Assert.equal(retrievedTimestamp, block.timestamp, "Timestamp should be current timestamp");
    }

    function testGetModelsByType() public {
        // Register multiple models with different types
        registry.registerModel("cid1", "Model A", "hash1", "hash2", "hash3");
        registry.registerModel("cid2", "Model B", "hash4", "hash5", "hash6");
        registry.registerModel("cid3", "Model A", "hash7", "hash8", "hash9");

        uint256[] memory modelIndexes = registry.getModelsByType("Model A");

        uint256[] memory expectedIndexes = new uint256[](2);
        expectedIndexes[0] = 0;
        expectedIndexes[1] = 2;

        Assert.equal(modelIndexes.length, expectedIndexes.length, "Model indexes array length should match");
        for (uint256 i = 0; i < modelIndexes.length; i++) {
            Assert.equal(modelIndexes[i], expectedIndexes[i], "Model index should match");
        }
    }

    function testRegisterMultipleModels() public {
        registry.registerModel("cid1", "Model A", "hash1", "hash2", "hash3");
        registry.registerModel("cid2", "Model B", "hash4", "hash5", "hash6");
        registry.registerModel("cid3", "Model A", "hash7", "hash8", "hash9");

        uint256 expectedCount = 3;
        Assert.equal(registry.modelCount(), expectedCount, "Model count should match");

        (address retrievedAddress1, , , , , ,) = registry.getModelByIndex(0);
        (address retrievedAddress2, , , , , ,) = registry.getModelByIndex(1);
        (address retrievedAddress3, , , , , ,) = registry.getModelByIndex(2);

        Assert.equal(retrievedAddress1, address(0x123), "Client address 1 should match");
        Assert.equal(retrievedAddress2, address(0x456), "Client address 2 should match");
        Assert.equal(retrievedAddress3, address(0x789), "Client address 3 should match");
    }

    function testRegisterModelWithSameType() public {
        registry.registerModel("cid1", "Model A", "hash1", "hash2", "hash3");
        registry.registerModel("cid2", "Model B", "hash4", "hash5", "hash6");
        registry.registerModel("cid3", "Model A", "hash7", "hash8", "hash9");
        registry.registerModel("cid4", "Model A", "hash10", "hash11", "hash12");

        uint256[] memory modelIndexes = registry.getModelsByType("Model A");

        uint256[] memory expectedIndexes = new uint256[](3);
        expectedIndexes[0] = 0;
        expectedIndexes[1] = 2;
        expectedIndexes[2] = 3;

        Assert.equal(modelIndexes.length, expectedIndexes.length, "Model indexes array length should match");
        for (uint256 i = 0; i < modelIndexes.length; i++) {
            Assert.equal(modelIndexes[i], expectedIndexes[i], "Model index should match");
        }
    }

    

}
