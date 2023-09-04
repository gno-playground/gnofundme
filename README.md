# GnoFundMe

A [Gno][1] smart contract ("realm") implementing campaign-based crowdfunding:
a individual creates a campaign with a purpose and funding goal, and other 
individuals can pledge donatations to it.

## Interact with the blockchain

See [Getting Started with Gno][2] for more information.

### Publish the contract

```shell
gnokey maketx addpkg \
    --pkgpath "gno.land/r/demo/campaigns" \
    --pkgdir "$(PWD)/campaigns" \
    --deposit "100000000ugnot" --gas-fee "1000000ugnot" \
    --gas-wanted "4000000" --broadcast --chainid dev \
    --remote localhost:26657 \
    YOUR_KEY
```

### Launch a campaign

```shell
gnokey maketx call \
    --pkgpath "gno.land/r/demo/campaigns" --func "Launch" \
    --args "a_title" --args "some_description" --args "100" --args "30" \
    --gas-fee "1000000ugnot" --gas-wanted "2000000" \
    --broadcast --chainid dev --remote localhost:26657 \
    --send "200000000ugnot" \
    YOUR_KEY
```

### Pledge to a campaign

```shell
gnokey maketx call \
    --pkgpath "gno.land/r/demo/campaigns" --func "MakePledge" \
    --args "a_title" --args --args "100" --args "pledge_reason" \
    --gas-fee "1000000ugnot" --gas-wanted "2000000" \
    --broadcast --chainid dev --remote localhost:26657 \
    --send "200000000ugnot" \
    YOUR_KEY
```

[1]: https://gno.land/
[2]: https://github.com/gnolang/getting-started