import { Clarinet, Tx, Chain, Account } from "clarinet-sdk";
import { assertEquals } from "matchstick-as/assembly";

Clarinet.test({
  name: "register-collection: allows creator to register with valid percent",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    let deployer = accounts.get("deployer")!;
    let creator = deployer.address;
    let receiver = accounts.get("wallet_1")!.address;

    let block = chain.mineBlock([
      Tx.contractCall("royalty-distributor", "register-collection", [
        `'(principal "${creator}")`,
        `'(principal "${receiver}")`,
        "u10"
      ], creator),
    ]);

    block.receipts[0].result.expectOk().expectBool(true);
  },
});
