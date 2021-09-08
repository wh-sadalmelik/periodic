// Load dependencies
const { expect } = require("chai");
// Load compiled artifacts
const Element = artifacts.require("Element");

contract("Element", function () {
  let eloot = {};
  beforeEach(async function () {
    // 为每个测试部署一个新的Element合约
    eloot = await Element.deployed();
  });

  // 测试用例
  it("claim 0", async () => {
    await eloot.claim(0);
  });

  // it("claim 6666", async () => {
  //   await eloot.claim(6666);
  // });

  it("ownerClaim 6666", async () => {
    await eloot.ownerClaim(6666);
  });
});
