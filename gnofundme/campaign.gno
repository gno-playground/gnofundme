package gnofundme

import (
	"std"
	"time"
)

// Campaign represents a GoFundMe-like crowdfunding campaign.
//
// Notably, like GoFundMe, the creator of the campaign is not required to
// meet their goal in order to receive the pledged funds: at the end of the
// specified duration, all funds are transferred to the creator.
type Camapign struct {
	Creator std.Address // The address of the campaign creator.
	Goal    int         // The amount the campaign creator is trying to raise.
	Pledged int         // The amount pledged to the campaign so far.
	Start   time.Date   // The date the campaign was created.
	End     time.Date   // The date the campaign will end.
}
