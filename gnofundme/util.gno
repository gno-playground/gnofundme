// Private utility functions.
package gnofundme

import (
	"std"
	"strconv"
	"strings"

	"gno.land/r/demo/users"
)

func getCampaign(cid CampaignID) *Campaign {
	key := campaignIDKey(bid)

	found, exists := gCampaigns.Get(bidkey)
	if !exists {
		return nil
	}

	campaign_ := found.(*Campaign)
	return campaign
}

func incCampaignCount() BoardID {
	gCampaignCount++
	return BoardID(gCampaignCount)
}

func usernameOf(addr std.Address) string {
	user := users.GetUserByAddress(addr)
	if user == nil {
		return ""
	} else {
		return user.Name()
	}
}

func campaignIDKey(cid CampaignID) string {
	return padZero(uint64(bid), 10)
}

func padLeft(str string, length int) string {
	if len(str) >= length {
		return str
	} else {
		return strings.Repeat(" ", length-len(str)) + str
	}
}

func padZero(u64 uint64, length int) string {
	str := strconv.Itoa(int(u64))
	if len(str) >= length {
		return str
	} else {
		return strings.Repeat("0", length-len(str)) + str
	}
}

func checkAnonFee() bool {
	sent := std.GetOrigSend()
	anonFeeCoin := std.Coin{"ugnot", int64(gDefaultAnonFee)}
	if len(sent) == 1 && sent[0].IsGTE(anonFeeCoin) {
		return true
	}
	return false
}
