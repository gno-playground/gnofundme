package gnofundme

import (
	"std"

	"gno.land/p/demo/ufmt"
)

// GetCampaignIDFromName returns the campaign ID associated with a
// user-specified campaign name.
func GetCampaignIDFromName(name string) (CampaignID, bool) {
	found, exists := gCampaignByName.Get(name)
	if !exists {
		return -1, false
	}
	return found.(*Campaign).id, true
}

// CreateCampaign creates a new campaign with a user-specified title,
// description, goal, and days.
func CreateCampaign(title, desc string, goal std.Coin, days int) CampaignID {
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

// MakePledge pledges a user-specified amount to a user-specified campaign.
func MakePledge(cid campaignIDKey, amount std.Coin) PledgeID {
	std.AssertOriginCall()

	if amount.IsNegative() {
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

// EditCampaign edits a user-specified campaign's title and/or description.
func EditCampaign(cid CampaignID, title, description string) {
	std.AssertOriginCall()
	if title == "" && description == "" {
		panic("both title and description cannot be empty")
	}

	campaign := getCampaign(cid)
	if campaign == nil {
		panic("campaign does not exist")
	}

	caller := std.GetOrigCaller()
	if !campaign.HasPermission(caller, EditPermission) {
		panic("unauthorized")
	}

	campaign.update(title, description)
}
