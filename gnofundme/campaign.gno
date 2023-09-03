package gnofundme

import (
	"std"
	"strconv"
	"time"

	"gno.land/p/demo/avl"
)

// CampaignID is a unique identifier for a campaign.
type CampaignID uint64

func (cid CampaignID) String() string {
	return strconv.Itoa(int(cid))
}

// Campaign represents a GoFundMe-like crowdfunding campaign.
//
// Notably, like GoFundMe, the creator of the campaign is not required to
// meet their goal in order to receive the pledged funds: at the end of the
// specified duration, all funds are transferred to the creator.
type Campaign struct {
	id            CampaignID  // The campaign's unique ID.
	creator       std.Address // The address of the campaign creator.
	title         string      // The title of the campaign.
	prefix        string      // The prefix of the campaign's URL.
	description   string      // A description of the campaign.
	goal          int         // The amount the campaign is trying to raise.
	pledged       int         // The amount pledged to the campaign so far.
	start         time.Time   // The time the campaign was created.
	end           time.Time   // The time the campaign will end.
	pledges       avl.Tree    // PledgeID -> Pledge
	pledgeCounter uint64      // increments Pledge.id
}

// newCampaign creates a new campaign.
func newCampaign(creator std.Address, id CampaignID, title, prefix, desc string, goal, days int) *Campaign {
	// TODO: should we put restrictions on `title` and `description`?
	//
	// i.e., min/max length?
	if exists := gCampaigns.Has(id); exists {
		panic("campaign already exists")
	}

	start := time.Now()
	return &Campaign{
		id:          id,
		creator:     creator,
		title:       title,
		prefix:      prefix,
		description: desc,
		goal:        goal,
		pledged:     0,
		start:       start,
		end:         start.AddDate(0, 0, days),
	}
}

// addPledge adds a pledge to the campaign.
func (c *Campaign) addPledge(backer std.Address, amount int) PledgeID {
	c.pledged += amount

	pid := c.incGetPledgeID()
	key := pledgeIDKey(pid)

	c.pledges.Set(key, newPledge(pid, user, amount))
	return pid
}

// incGetPledgeID increments the pledge counter and returns the new value.
func (c *Campaign) incGetPledgeID() PledgeID {
	c.pledgeCounter++
	return PledgeID(c.pledgeCounter)
}
