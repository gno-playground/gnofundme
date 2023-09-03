// Package gnofundme implements a GoFundMe-like crowdfunding platform.
//
//  1. A user creates a campaign by calling `CreateCampaign`.
//
//  2. Other users pledge funds to a campaign by calling `MakePledge`.
//
//  3. When a campaign ends, the creator can call the `Withdraw` to claim the
//     pledged funds.
//
// When rendered, the campaign page should display the following information:
//
// - [ ] The campaign's title
// - [ ] The campaign's description
// - [ ] The campaign's goal amount
// - [ ] The campaign's current amount pledged
// - [ ] The campaign's deadline
// - [ ] The campaign's creator
// - [ ] The campaign's status (open or closed)
// - [ ] The campaign's contributors (leaaerboard-style?)
package gnofundme
