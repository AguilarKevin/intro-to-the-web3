// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";


contract MyEpicNFT is ERC721URIStorage {

	using Counters for Counters.Counter;
	Counters.Counter private _tokenIds;


  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 350 350'><style>.base { fill: black; font-weight:bold; letter-spacing: -0.085em; font-family: arial; font-size: 180% }</style><defs><linearGradient id='myGradient' gradientTransform='rotate(90)'><stop offset='5%'  stop-color='#fc00ff' /><stop offset='95%' stop-color='#00dbde' /></linearGradient></defs><rect width='100%' height='100%' fill='url(#myGradient)'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  string[] firstWords = ["Lxrd", "STXP", "$TFU", "Mxrbid", "Hxpe", "Chaxs", 'Crash'];
  string[] secondWords = ["Hexada", "Starshot", "Andromeda", "Cannis", "Attack", "Chxke"];
  string[] thirdWords = ["Invaders", "Candy", "Love", "Hate", "Heart", "Leeches"];

  event NewEpicNFTMinted(address sender, uint256 tokenId);

	constructor() ERC721 ("SquareNFT", "SQUARE") {
		console.log("This is my NFT contract. Woah!");
	}

	function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {

    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));

    rand = rand % firstWords.length;
    return firstWords[rand];
  }

  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

	// A function our user will hit to get their NFT.
	function makeAnEpicNFT() public {
		uint256 newItemId = _tokenIds.current();

    // We go and randomly grab one word from each of the three arrays.
    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);

		string memory combinedWord = string(abi.encodePacked(first, second, third));

    string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));

		console.log(finalSvg);

    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combinedWord,
                    '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    _safeMint(msg.sender, newItemId);

    _setTokenURI(newItemId, finalTokenUri);

    _tokenIds.increment();

    emit NewEpicNFTMinted(msg.sender, newItemId);
	}

}