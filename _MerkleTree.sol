//SPDX-License-Identifier: GPL-3.0 
pragma solidity ^0.8.0; 

contract Tree {
    bytes32[] public hashes;
    string[4] heroes = ["Leo","Raf","Don","Mikey"];

    constructor(){
        for(uint i = 0; i<heroes.length; i++) {
            hashes.push(keccak256(abi.encodePacked(heroes[i])));
        }
        uint n = heroes.length;
        uint offset = 0;
        while (n > 0) {
            for(uint i = 0; i < n-1; i+=2) {
                bytes32 newHash = keccak256(abi.encodePacked(hashes[i+offset],hashes[i+offset+1]));
                hashes.push(newHash);
            }
            offset += n;
            n=n / 2;
        }
    }
    function getRoot() public view returns(bytes32){
        return hashes[hashes.length - 1];
    }
    function verify(bytes32 root, bytes32 leaf, uint index,bytes32[] memory proof) public pure returns(bool){
        bytes32 hash = leaf;
        for (uint i = 0; i < proof.length; i++){
            bytes32 proofEl = proof[i];
            if (index % 2 == 0) {
                hash = keccak256(abi.encodePacked(hash,proofEl));
            }
            else {
                hash = keccak256(abi.encodePacked(proofEl,hash));
            }
            index = index / 2;
        }
        return hash == root;
    }
}
//0x22b4e4cd5b0437c22ecc85c3230d0879f8d88de9163c2b6214cc99934f2c1231 - Root
//0x71e7470295b800dcd927da2c9a31422d569a87af36866632ddfd668da485f1ca - Leaf
//["0x2870ec60d059ad7150274e4785beb16983cdb83ca27a2c9b947aa9fe9cd1f189","0x74911c760f5be4396789accbdcf3ecc0d4c1151687eb624bfd926f69c51b36de"]