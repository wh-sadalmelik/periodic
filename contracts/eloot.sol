// SPDX-License-Identifier: MIT
pragma solidity 0.8.2;

import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/utils/Strings.sol";


contract Element is ERC721Enumerable, ReentrancyGuard, Ownable {
    using Strings for uint256;
    
    // 1
    string[] private non_metallice_elements = [
        "Hydrogen",
        "Carbon",
        "Nitrogen",
        "Oxygen",
        "Phosphorus",
        "Sulfur",
        "Selenium"
    ];

    // 2
    string[] private noble_gas = [
        "Helium",
        "Neon",
        "Argon",
        "Krypton",
        "Xenon",
        "Radon"
    ];

    // 3
    string[] private alkali_metal = [
        "Lithium",
        "Sodium",
        "Potassium",
        "Rubidium",
        "Caesium",
        "Francium"
    ];

    // 4
    string[] private alkaline_earth_metal = [
        "Beryllium",
        "Magnesium",
        "Calcium",
        "Strontium",
        "Barium",
        "Radium"
    ];

    // 5
    string[] private metalloid = [
        "Boron",
        "Silicon",
        "Germanium",
        "Arsenic",
        "Antimony",
        "Tellurium",
        "Polonium"
    ];

    // 6
    string[] private halogen = [
        "Fluorine",
        "Chlorine",
        "Bromine",
        "Iodine",
        "Astatine"
    ];
    
    // 7
    string[] private late_transition_metal = [
        "Aluminium",
        "Gallium",
        "Indium",
        "Tin",
        "Thallium",
        "Lead",
        "Bismuth"
    ];

    string[][7] commomElementArray = [non_metallice_elements, noble_gas, alkali_metal, alkaline_earth_metal, metalloid, halogen, late_transition_metal];

    // 8
    string[] private transition_element = [
        "Scandium",
        "Titanium",
        "Vanadium",
        "Chromium",
        "Manganese",
        "Iron",
        "Cobalt",
        "Nickel",
        "Copper",
        "Zinc",
        "Yttrium",
        "Zirconium",
        "Niobium",
        "Molybdenum",
        "Technetium",
        "Ruthenium",
        "Rhodium",
        "Palladium",
        "Silver",
        "Cadmium",
        "Hafnium",
        "Tantalum",
        "Tungsten",
        "Rhenium",
        "Osmium",
        "Iridium",
        "Platinum",
        "Gold",
        "Platinum"
    ];

    // 9
    string[] lanthanide = [
        "Cerium",
        "Praseodymium",
        "Neodymium",
        "Promethium",
        "Samarium",
        "Europium",
        "Gadolinium",
        "Terbium",
        "Dysprosium",
        "Holmium",
        "Erbium",
        "Thulium",
        "Ytterbium",
        "Lutetium"
    ];

    // 10
    string[] actinides = [
        "Actinium",
        "Thorium",
        "Protactinium",
        "Uranium",
        "Neptunium",
        "Plutonium",
        "Americium",
        "Curium",
        "Berkelium",
        "Californium",
        "Einstenium",
        "Fermium",
        "Mendelevium",
        "Nobelium",
        "Lawrencium"
    ];


    string[] state = [
        "Solid",
        "Liquid",
        "Gas",
        "Plasma"
    ];

    
    function random(string memory input) internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(msg.sender, input)));
    }

    function addState(string memory input, uint256 tokenId) internal view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked(tokenId, input)));
        uint256 greatness = rand % 50;
        string memory output = string(abi.encodePacked(state[rand % 2], ' Of ', input));

        if (greatness > 20 && greatness < 40) {
            output = string(abi.encodePacked(state[2], ' Of ', input));
        }

        if (greatness == 6) {
            output = string(abi.encodePacked(state[3], ' Of ', input));
        } 
        return output;
    }

    function _getAllElement(uint256 tokenId) internal view returns (string[8] memory output)  {
        uint256 rand = random(tokenId.toString());
        
        uint256 setIndex = 0;
        
        uint256 exceptIndex = rand % 7;
        for(uint256 i = 0; i < 7; i++) {
            if(i != exceptIndex) {
                string memory ret = commomElementArray[i][rand % commomElementArray[i].length];
                output[setIndex] = addState(ret, tokenId);
                setIndex++;
            }
        }

        output[6] = addState(transition_element[rand % transition_element.length], tokenId);
      
        string memory the9 = lanthanide[rand % lanthanide.length];
        string memory the10 = actinides[rand % actinides.length];

        uint256 is9_and10 = rand % 2;
        uint256 rand2 = random(string(abi.encodePacked(tokenId.toString(), msg.sender)));
        output[7] = is9_and10 == 1 ?
             (random(string(abi.encodePacked(the9, the10))) % 2 == 1 ? the9 : the10) :
             transition_element[rand2 % transition_element.length];
        output[7] = addState(output[7], tokenId);
        return output;
    }

    
    function claim(uint256 tokenId) public nonReentrant {
         require(tokenId >= 0 && tokenId < 6666, "claim Token ID invalid");
        _safeMint(_msgSender(), tokenId);
    }

    function ownerClaim(uint256 tokenId) public nonReentrant onlyOwner{
         require(tokenId > 6665 && tokenId < 6732, "ownerClaim Token ID invalid");
        _safeMint(owner(), tokenId); 
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory output) {
        string[17] memory parts;
        string[8] memory elements = _getAllElement(tokenId);

        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';

        parts[1] = elements[0];

        parts[2] = '</text><text x="10" y="40" class="base">';

        parts[3] = elements[1];

        parts[4] = '</text><text x="10" y="60" class="base">';

        parts[5] = elements[2];

        parts[6] = '</text><text x="10" y="80" class="base">';

        parts[7] = elements[3];

        parts[8] = '</text><text x="10" y="100" class="base">';

        parts[9] = elements[4];

        parts[10] = '</text><text x="10" y="120" class="base">';

        parts[11] = elements[5];

        parts[12] = '</text><text x="10" y="140" class="base">';

        parts[13] = elements[6];

        parts[14] = '</text><text x="10" y="160" class="base">';

        parts[15] = elements[7];

        parts[16] = '</text></svg>';

        output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
        output = string(abi.encodePacked(output, parts[9], parts[10], parts[11], parts[12], parts[13], parts[14], parts[15], parts[16]));
        
        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Element Bag #', tokenId.toString(), '", "description": "Our elements for Metaverse are chemical elements, that are randomly generated and stored on the blockchain. You can combine these elements in arbitrary ways.  Using scientific knowledge or your imagination, you can acquire new props by combining those elements, and some of these props has magic skills.  With these powerful elements, you can do whatever and go anywhere you want. (Explore new and wonderful life with us!)", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;
    }
     

    constructor() ERC721("element", "Element") Ownable() {}
}

/// [MIT License]
/// @title Base64
/// @notice Provides a function for encoding some bytes in base64
/// @author Brecht Devos <brecht@loopring.org>
library Base64 {
    bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    /// @notice Encodes some bytes to the base64 representation
    function encode(bytes memory data) internal pure returns (string memory) {
        uint256 len = data.length;
        if (len == 0) return "";

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((len + 2) / 3);

        // Add some extra buffer at the end
        bytes memory result = new bytes(encodedLen + 32);

        bytes memory table = TABLE;

        assembly {
            let tablePtr := add(table, 1)
            let resultPtr := add(result, 32)

            for {
                let i := 0
            } lt(i, len) {

            } {
                i := add(i, 3)
                let input := and(mload(add(data, i)), 0xffffff)

                let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
                out := shl(224, out)

                mstore(resultPtr, out)

                resultPtr := add(resultPtr, 4)
            }

            switch mod(len, 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }

            mstore(result, encodedLen)
        }

        return string(result);
    }
}
