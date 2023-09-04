package gnofundme

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

// CreateCampaign creates a new campaign with a user-specified title,
// description, goal, and days.
func CreateCampaign(title, desc string, goal, days int) CampaignID {
	std.AssertOriginCall()

	caller := std.GetOrigCaller()
	if usernameOf(caller) == "" {
		panic("unauthorized")
	}

	url := "/r/demo/campaigns:" + title
	cid := incCampaignCount()

	campaign := newCampaign(caller, cid, title, url, desc, goal, days)
	cidkey := campaignIDKey(cid)

	gCampaigns.Set(cidkey, campaign)
	gCampaignsByTitle.Set(title, campaign)

	return cid
}

// MakePledge pledges a user-specified amount to a user-specified campaign.
func MakePledge(cid CampaignID, amount int64, why string) PledgeID {
	std.AssertOriginCall()

	if amount <= 0 {
		panic("amount must be positive")
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
	} else if campaign.isExpired() {
		panic("campaign has expired")
	}

	return campaign.addPledge(caller, amount, why)
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
	} else if campaign.isExpired() {
		panic("campaign has expired")
	}

	caller := std.GetOrigCaller()
	if !campaign.hasPermission(caller, EditPermission) {
		panic("unauthorized")
	}

	campaign.update(title, description)
}
