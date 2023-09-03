package gnofundme

import (
	"std"
	"strconv"
	"time"
)

// PledgeID is a unique identifier for a campaign.
type PledgeID uint64

func (pid PledgeID) String() string {
	return strconv.Itoa(int(pid))
}

// Pledge represents a user's pledge to a campaign.
type Pledge struct {
	id     PledgeID
	amount std.Coins
	backer std.Address
	when   time.Time
}

// newPledge creates a new pledge.
func newPledge(id PledgeID, backer std.Address, amount std.Coins) *Pledge {
	return &Pledge{
		id:     id,
		amount: amount,
		backer: backer,
		when:   time.Now(),
	}
}
