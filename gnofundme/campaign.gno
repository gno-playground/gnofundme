package gnofundme

import (
	"regexp"
	"std"
	"strconv"
	"time"

	"gno.land/p/demo/avl"
	"gno.land/p/demo/ufmt"
)

var reTitle = regexp.MustCompile(`^[a-z]+[_a-z0-9]{2,29}$`)

// CampaignID is a unique identifier for a campaign.
type CampaignID uint64

func (cid CampaignID) String() string {
	return strconv.Itoa(int(cid))
}

// Campaign represents a GoFundMe-like crowdfunding campaign.
//
// Like GoFundMe, the creator of the campaign is not required to meet their
// goal in order to receive the pledged funds: at the end of the specified
// duration, all funds are transferred to the creator.
//
// Also, notable, there is no intermediary between the creator and the backers.
// Pledged funds are transferred directly to the creator.
type Campaign struct {
	id            CampaignID  // The campaign's unique ID.
	creator       std.Address // The address of the campaign creator.
	title         string      // The title of the campaign.
	url           string      // The prefix of the campaign's URL.
	description   string      // A description of the campaign.
	goal          int         // The amount the campaign is trying to raise.
	pledged       int64       // The amount pledged to the campaign so far.
	start         time.Time   // The time the campaign was created.
	end           time.Time   // The time the campaign will end.
	pledges       avl.Tree    // PledgeID -> Pledge
	pledgeCounter uint64      // increments Pledge.id
	updatedAt     time.Time   // The time the campaign was last updated.
	isActive      bool        // Whether the campaign is active.
}

// newCampaign creates a new campaign.
func newCampaign(creator std.Address, id CampaignID, title, url, desc string, goal, days int) *Campaign {
	if !reTitle.MatchString(title) {
		panic("invalid tile: " + title)
	}

	// TODO: should we put restrictions on `title` and `description`?
	//
	// i.e., min/max length?
	if exists := gCampaignsByTitle.Has(title); exists {
		panic("campaign already exists")
	}

	start := time.Now()
	return &Campaign{
		id:          id,
		creator:     creator,
		title:       title,
		url:         url,
		description: desc,
		goal:        goal,
		pledged:     0,
		start:       start,
		end:         start.AddDate(0, 0, days),
	}
}

// addPledge adds a pledge to the campaign.
func (c *Campaign) addPledge(backer std.Address, amount int64, why string) PledgeID {
	c.pledged += amount

	pid := c.incGetPledgeID()
	key := pledgeIDKey(pid)

	sendCoins := std.Coins{std.Coin{Denom: "ugnot", Amount: amount}}

	banker := std.GetBanker(std.BankerTypeRealmSend)
	banker.SendCoins(backer, c.creator, sendCoins)

	c.pledges.Set(key, newPledge(pid, backer, amount, why))
	return pid
}

func (c *Campaign) update(title, description string) {
	if title != "" {
		c.title = title
	}
	if description != "" {
		c.description = description
	}
	c.updatedAt = time.Now()
}

// incGetPledgeID increments the pledge counter and returns the new value.
func (c *Campaign) incGetPledgeID() PledgeID {
	c.pledgeCounter++
	return PledgeID(c.pledgeCounter)
}

// hasPermission returns whether the given address has the given permission.
//
// TODO: should there be a 'delete' permission?
func (c *Campaign) hasPermission(addr std.Address, perm Permission) bool {
	if c.creator != addr {
		return false
	}
	switch perm {
	case EditPermission:
		return true
	default:
		return false
	}
}

// isExpired returns whether the campaign has expired.
func (c *Campaign) isExpired() bool {
	return time.Now().After(c.end)
}

// render returns a Markdown-formatted representation of the campaign.
//
// - The campaign's title
// - The campaign's description
// - The campaign's goal amount
// - The campaign's current amount pledged
// - The campaign's deadline
// - The campaign's creator
// - The campaign's status (open or closed)
// - The campaign's contributors (leaderboard-style?)
func (c *Campaign) render() string {
	status := "open"
	if c.isExpired() {
		status = "closed"
	}
	return ufmt.Sprintf(
		"# %s\n\n"+
			"%s\n\n"+
			"Goal: %d\n"+
			"Pledged: %d\n"+
			"Deadline: %s\n"+
			"Creator: %s\n"+
			"Status: %s\n",
		c.title,
		c.description,
		c.goal,
		c.pledged,
		c.end.Format("2006-01-02"),
		c.creator,
		status,
	)
}
