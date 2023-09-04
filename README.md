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
            <a href="https://github.com/jdkato/gnofundme/assets/8785025/75b30313-2ada-4c27-9bed-ed16fd12ab65">
                <img src="https://github.com/jdkato/gnofundme/assets/8785025/75b30313-2ada-4c27-9bed-ed16fd12ab65" width="100%">
            </a>
        </td>
        <td width="50%">
            <a href="https://github.com/jdkato/gnofundme/assets/8785025/cde6a801-33af-45df-b286-517b0f1f9748">
                <img src="https://github.com/jdkato/gnofundme/assets/8785025/cde6a801-33af-45df-b286-517b0f1f9748" width="100%">
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