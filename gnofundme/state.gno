package gnofundme

import (
	"gno.land/p/demo/avl"
)

var (
	gCampaigns        avl.Tree    // id -> *Campaign
	gCampaignCount    int         // increments Campaign.id
	gCampaignsByTitle avl.Tree    // title -> *Campaign
	gDefaultAnonFee   = 100000000 // minimum fee required if anonymous
)
