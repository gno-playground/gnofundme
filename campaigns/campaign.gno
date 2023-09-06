package campaigns

import (
	"errors"
	"regexp"
	"std"
	"strings"
	"time"

	"gno.land/p/demo/avl"
	"gno.land/p/demo/ufmt"
)

// reTitle is the regular expression for a campaign's title.
var reTitle = regexp.MustCompile(`^[a-z]+[_a-z0-9]{2,29}$`)

// maxDescriptionLength is the maximum length of a campaign's description.
//
// This is shown in the campaign's Markdown representation.
const maxDescriptionLength = 200

// maxDurationDays is the maximum number of days a campaign can run.
const maxDurationDays = 60

// minGoal is the minimum amount a campaign can try to raise.
const minGoal = 100

// Campaign represents a crowdfunding campaign.
//
// Notably, like GoFundMe, the creator of the campaign is not required to meet
// their goal in order to receive the pledged funds: at the end of the
// specified duration, all funds are transferred to the creator.
//
// If the creator cancels the campaign before it ends, all funds are returned
// to the backers.
type Campaign struct {
	id            CampaignID     // The campaign's unique ID.
	creator       std.Address    // The address of the campaign creator.
	title         string         // The title of the campaign.
	url           string         // The prefix of the campaign's URL.
	description   string         // A description of the campaign.
	goal          int            // The amount the campaign is trying to raise.
	pledged       int64          // The amount pledged to the campaign so far.
	start         time.Time      // The time the campaign was created.
	end           time.Time      // The time the campaign will end.
	pledges       *avl.Tree      // PledgeID -> Pledge
	pledgeCounter uint64         // increments Pledge.id
	updatedAt     time.Time      // The time the campaign was last updated.
	status        CampaignStatus // Whether the campaign is active.
	withdrawn     bool           // Whether the funds have been withdrawn.
}

// newCampaign creates a new campaign.
func newCampaign(creator std.Address, id CampaignID, title, url, desc string, goal, days int) (*Campaign, error) {
	if !reTitle.MatchString(title) {
		return nil, errors.New(ufmt.Sprintf(
			"invalid title: `%s`", title))
	}

	if exists := gCampaignsByTitle.Has(title); exists {
		return nil, errors.New(ufmt.Sprintf(
			"campaign with title `%s` already exists", title))
	}

	desc = strings.TrimSpace(desc)
	if len(desc) > maxDescriptionLength {
		return nil, errors.New(ufmt.Sprintf(
			"description too long: %d > %d", len(desc), maxDescriptionLength))
	} else if len(desc) == 0 {
		return nil, errors.New("description cannot be empty")
	}

	if goal < minGoal {
		return nil, errors.New(ufmt.Sprintf(
			"goal must be positive: %d", goal))
	}

	if days <= 0 || days > maxDurationDays {
		return nil, errors.New(ufmt.Sprintf(
			"duration '%d' must be between 1 and %d days", maxDurationDays, days))
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
		status:      Open,
		pledges:     avl.NewTree(),
	}, nil
}

// addPledge adds a pledge to the campaign.
//
// The funds are transferred from the backer to the package's address.
func (c *Campaign) addPledge(backer std.Address, amount int64, why string) (PledgeID, error) {
	if c.isExpired() {
		return 0, errors.New("campaign has expired")
	}

	if c.status != Open {
		return 0, errors.New("campaign is not open")
	}

	pid := c.incGetPledgeID()
	key := pledgeIDKey(pid)

	pledge, err := newPledge(pid, backer, amount, why)
	if err != nil {
		return 0, err
	}
	c.pledged += amount

	sendCoins := std.Coins{std.Coin{Denom: "ugnot", Amount: amount}}
	pkgaddr := std.GetOrigPkgAddr()

	banker := std.GetBanker(std.BankerTypeRealmSend)
	banker.SendCoins(backer, pkgaddr, sendCoins)

	c.pledges.Set(key, pledge)
	return pid, nil
}

// withdrawFunds withdraws the funds from the campaign.
func (c *Campaign) withdrawFunds() error {
	if c.isActive() {
		return errors.New("campaign is active")
	}

	if c.withdrawn {
		return errors.New("funds have already been withdrawn")
	}

	sendCoins := std.Coins{std.Coin{Denom: "ugnot", Amount: c.pledged}}
	pkgaddr := std.GetOrigPkgAddr()

	banker := std.GetBanker(std.BankerTypeRealmSend)
	banker.SendCoins(pkgaddr, c.creator, sendCoins)

	c.withdrawn = true
	return nil
}

// update updates the campaign's title and/or description.
func (c *Campaign) update(title, description string) error {
	if title == "" && description == "" {
		return errors.New("no fields to update")
	}

	if !c.isActive() {
		return errors.New("campaign is not active")
	}

	if title != "" {
		c.title = title
	}

	if description != "" {
		c.description = description
	}

	c.updatedAt = time.Now()
	return nil
}

// incGetPledgeID increments the pledge counter and returns the new value.
func (c *Campaign) incGetPledgeID() PledgeID {
	c.pledgeCounter++
	return PledgeID(c.pledgeCounter)
}

// hasPermission returns whether the address has permission to perform an
// action on the campaign.
func (c *Campaign) hasPermission(addr std.Address) bool {
	return c.creator == addr
}

// isExpired returns whether the campaign has expired.
func (c *Campaign) isExpired() bool {
	return time.Now().After(c.end)
}

// isActive returns whether the campaign is active.
func (c *Campaign) isActive() bool {
	return !c.isExpired() && c.status == Open
}

// cancel cancels the campaign and returns all funds to the backers.
func (c *Campaign) cancel() error {
	if !c.isActive() {
		return errors.New("campaign is not active")
	}
	c.status = Canceled
	return c.refund()
}

// refund returns all funds to the backers.
func (c *Campaign) refund() error {
	if c.withdrawn {
		return errors.New("funds have already been withdrawn")
	}

	c.pledges.Iterate("", "", func(key string, value interface{}) bool {
		p := value.(*Pledge)

		sendCoins := std.Coins{std.Coin{Denom: "ugnot", Amount: p.amount}}
		pkgaddr := std.GetOrigPkgAddr()

		banker := std.GetBanker(std.BankerTypeRealmSend)
		banker.SendCoins(pkgaddr, p.backer, sendCoins)

		return true
	})

	c.withdrawn = true
	return nil
}

// render returns a Markdown-formatted representation of the campaign.
//
// TODO: The campaign's contributors (leaderboard-style?)
func (c *Campaign) render() string {
	return ufmt.Sprintf(
		"# %s\n\n"+
			"> %s\n\n"+
			"* Goal: %d\n"+
			"* Pledged: %d\n"+
			"* Deadline: %s\n"+
			"* Creator: `%s`\n"+
			"* Status: `%s`\n",
		c.title,
		c.description,
		c.goal,
		c.pledged,
		c.end.Format("2006-01-02"),
		c.creator,
		c.status.String(),
	)
}
