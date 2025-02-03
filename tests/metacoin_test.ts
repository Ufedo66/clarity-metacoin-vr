import { Clarinet, Chain, Account, types } from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Ensure that token minting works",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get('deployer')!;
    const wallet1 = accounts.get('wallet_1')!;
    
    let block = chain.mineBlock([
      Tx.contractCall('metacoin', 'mint', 
        [types.uint(1000), types.principal(wallet1.address)], 
        deployer.address
      )
    ]);
    
    assertEquals(block.receipts.length, 1);
    assertEquals(block.height, 2);
    
    let balance = chain.callReadOnlyFn(
      'metacoin', 
      'get-balance', 
      [types.principal(wallet1.address)], 
      deployer.address
    );
    assertEquals(balance.result, types.ok(types.uint(1000)));
  },
});
