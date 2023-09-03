package gnofundme

import (
	"std"
	"time"
)

// PledgeID is a unique identifier for a campaign.
type PledgeID uint64

// Pledge represents a user's pledge to a campaign.
type Pledge struct {
	id     PledgeID
	amount int
	backer std.Address
	when   time.Time
}

// newPledge creates a new pledge.
func newPledge(id PledgeID, backer std.Address, amount int) *Pledge {
	return &Pledge{
		id:     id,
		amount: amount,
		backer: backer,
		when:   time.Now(),
	}
}
