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

  event NewEpicNFTMinted(address sender, uint256 tokenId);

	constructor() ERC721 ("SquareNFT", "SQUARE") {
		console.log("This is my NFT contract. Woah!");
	}
	function makeAnEpicNFT(string memory firstWord, string memory secondWord, string memory thirdWord) public {
    console.log(_tokenIds.current());
    _tokenIds.increment();
		uint256 newItemId = _tokenIds.current() - 1;
    console.log(newItemId);
    console.log(_tokenIds.current());


		string memory combinedWord = string(abi.encodePacked(firstWord, secondWord, thirdWord));

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

    emit NewEpicNFTMinted(msg.sender, newItemId);
	}

  function tokenCounter() public view returns (uint256) {
    return _tokenIds.current();
  }


}