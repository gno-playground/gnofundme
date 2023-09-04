# GnoFundMe

A [Gno][1] smart contract ("realm") implementing campaign-based crowdfunding:
an individual creates a campaign with a purpose and funding goal, and other 
individuals can pledge donations to it.

<table>
    <tr>
        <th>Campaign Landing Page</th>
        <th>Campaign Details Page</th>
    </tr>
    <tr>
        <td width="50%">
            <a href="https://github.com/jdkato/gnofundme/assets/8785025/30eb99c0-d16e-45c5-b63a-20c213b1f79e">
                <img src="https://github.com/jdkato/gnofundme/assets/8785025/30eb99c0-d16e-45c5-b63a-20c213b1f79e" width="100%">
            </a>
        </td>
        <td width="50%">
            <a href="https://github.com/jdkato/gnofundme/assets/8785025/690f13b9-2bd4-4d36-a304-08b7ea19e99d">
                <img src="https://github.com/jdkato/gnofundme/assets/8785025/690f13b9-2bd4-4d36-a304-08b7ea19e99d" width="100%">
            </a>
        </td>
    </tr>
</table>

## Interact with the blockchain

See [Getting Started with Gno][2] for more information.

### Publish the contract

```shell
gnokey maketx addpkg \
    --pkgpath "gno.land/r/demo/campaigns" \
    --pkgdir "$(PWD)/campaigns" \
    --deposit "100000000ugnot" --gas-fee "1000000ugnot" \
    --gas-wanted "5000000" --broadcast --chainid dev \
    --remote localhost:26657 \
    YOUR_KEY
```

### Launch a campaign

```shell
gnokey maketx call \
    --pkgpath "gno.land/r/demo/campaigns" --func "Launch" \
    --args "a_title" --args "some_description" --args "100" --args "30" \
    --gas-fee "1000000ugnot" --gas-wanted "5000000" \
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
