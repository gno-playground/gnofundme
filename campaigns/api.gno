package campaigns

import (
	"std"

	"gno.land/p/demo/ufmt"
)

// GetCampaignIDFromTitle returns the campaign ID associated with a
// user-specified campaign name.
func GetCampaignIDFromTitle(name string) (CampaignID, bool) {
	found, exists := gCampaignsByTitle.Get(name)
	if !exists {
		return 0, false
	}
	return found.(*Campaign).id, true
}

// Launch creates a new campaign with a user-specified title, description,
// goal, and days.
func Launch(title, desc string, goal, days int) CampaignID {
	std.AssertOriginCall()

	caller := std.GetOrigCaller()
	if usernameOf(caller) == "" {
		panic("unauthorized")
	}

	url := "/r/demo/campaigns:" + title
	cid := incCampaignCount()

	campaign, err := newCampaign(caller, cid, title, url, desc, goal, days)
	if err != nil {
		panic(err)
	}
	cidkey := campaignIDKey(cid)

	gCampaigns.Set(cidkey, campaign)
	gCampaignsByTitle.Set(title, campaign)

	return cid
}

// MakePledge pledges a user-specified amount to a user-specified campaign.
func MakePledge(cid CampaignID, amount int64, why string) PledgeID {
	std.AssertOriginCall()

	caller := std.GetOrigCaller()
	if usernameOf(caller) == "" {
		if !checkAnonFee() {
			panic(ufmt.Sprintf(
				"please register, %d (minimum fee) is required if anonymous",
				gDefaultAnonFee,
			))
		}
	}

	campaign := getCampaign(cid)
	if campaign == nil {
		panic("campaign does not exist")
	}

	pid, err := campaign.addPledge(caller, amount, why)
	if err != nil {
		panic(err)
	}

	return pid
}

// EditCampaign edits a user-specified campaign's title and/or description.
func EditCampaign(cid CampaignID, title, description string) {
	std.AssertOriginCall()

	campaign := getCampaign(cid)
	if campaign == nil {
		panic("campaign does not exist")
	}

	caller := std.GetOrigCaller()
	if !campaign.hasPermission(caller) {
		panic("unauthorized")
	}

	err := campaign.update(title, description)
	if err != nil {
		panic(err)
	}
}

// WithdrawFunds withdraws the funds from a user-specified campaign.
func WithdrawFunds(cid CampaignID) {
	std.AssertOriginCall()

	campaign := getCampaign(cid)
	if campaign == nil {
		panic("campaign does not exist")
	}

	caller := std.GetOrigCaller()
	if !campaign.hasPermission(caller) {
		panic("unauthorized")
	}

	err := campaign.withdrawFunds()
	if err != nil {
		panic(err)
	}
}

func CancelCampaign(cid CampaignID) {
	std.AssertOriginCall()

	campaign := getCampaign(cid)
	if campaign == nil {
		panic("campaign does not exist")
	}

	caller := std.GetOrigCaller()
	if !campaign.hasPermission(caller) {
		panic("unauthorized")
	}

	err := campaign.cancel()
	if err != nil {
		panic(err)
	}
}
