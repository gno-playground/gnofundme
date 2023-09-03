package gnofundme

import (
	"std"

	"gno.land/p/demo/ufmt"
)

// CreateCampaign creates a new campaign with a user-specified title,
// description, goal, and days.
func CreateCampaign(title, desc string, goal, days int) CampaignID {
	std.AssertOriginCall()

	caller := std.GetOrigCaller()
	if usernameOf(caller) == "" {
		panic("unauthorized")
	}

	prefix := "/r/demo/campaigns:" + title
	cid := incCampaignCount()

	campaign := newCampaign(cid, title, prefix, desc, goal, days)
	cidkey := campaignIDKey(cid)

	gCampaigns.Set(cidkey, campaign)
	gCampaignsByTitle.Set(title, campaign)

	return cid
}

// Pledge pledges a user-specified amount to a user-specified campaign.
func Pledge(cid campaignIDKey, amount int) *Pledge {
	std.AssertOriginCall()

	if amount < 0 {
		panic("negative amount")
	}

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

	return campaign.addPledge(caller, amount)
}
