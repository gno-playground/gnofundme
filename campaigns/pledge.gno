package campaigns

import (
	"std"
	"time"

	"gno.land/p/demo/ufmt"
)

// Pledge represents a user's pledge to a campaign.
type Pledge struct {
	id     PledgeID
	amount int64
	backer std.Address
	when   time.Time
	why    string
}

// newPledge creates a new pledge.
func newPledge(id PledgeID, backer std.Address, amount int64, why string) *Pledge {
	return &Pledge{
		id:     id,
		amount: amount,
		backer: backer,
		when:   time.Now(),
		why:    why,
	}
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
