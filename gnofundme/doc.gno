// Package gnofundme implements a GoFundMe-like crowdfunding platform.
//
//  1. A user creates a campaign by calling `CreateCampaign`.
//
//  2. Other users pledge funds to a campaign by calling `MakePledge`.
//
//  3. When a campaign ends, the creator can call the `Withdraw` to claim the
//     pledged funds.
package gnofundme
