package gnofundme

import (
	"std"
	"strconv"
)

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
