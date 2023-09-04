package campaigns

import "strconv"

// CampaignID is a unique identifier for a campaign.
type CampaignID uint64

func (cid CampaignID) String() string {
	return strconv.Itoa(int(cid))
}

// CampaignStatus is the status of a campaign.
type CampaignStatus int64

func (s CampaignStatus) String() string {
	switch s {
	case Open:
		return "open"
	case Closed:
		return "closed"
	case Canceled:
		return "canceled"
	default:
		panic("unknown status")
	}
}

// PledgeID is a unique identifier for a campaign.
type PledgeID uint64

func (pid PledgeID) String() string {
	return strconv.Itoa(int(pid))
}
