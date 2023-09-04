package campaigns

import (
	"errors"
	"std"
	"time"

	"gno.land/p/demo/ufmt"
)

// maxPledgeReasonLength is the maximum length of a pledge reason.
const maxPledgeReasonLength = 140

// Pledge represents a user's pledge to a campaign.
type Pledge struct {
	id     PledgeID
	amount int64
	backer std.Address
	when   time.Time
	why    string
}

// newPledge creates a new pledge.
func newPledge(id PledgeID, backer std.Address, amount int64, why string) (*Pledge, error) {
	if amount <= 0 {
		return nil, errors.New(ufmt.Sprintf(
			"amount must be positive: %d", amount))
	}

	// NOTE: `why` can be empty.
	if len(why) > maxPledgeReasonLength {
		return nil, errors.New(ufmt.Sprintf(
			"pledge reason is too long: %d > %d", len(why), maxPledgeReasonLength))
	}

	return &Pledge{
		id:     id,
		amount: amount,
		backer: backer,
		when:   time.Now(),
		why:    why,
	}, nil
}

// render returns a Markdown-formatted representation of a pledge.
func (p *Pledge) render() string {
	return ufmt.Sprintf(
		"**%s** pledged **%d** to **%s** on **%s**:\n\n > %s",
		p.backer,
		p.amount,
		p.id,
		p.when,
		p.why,
	)
}
