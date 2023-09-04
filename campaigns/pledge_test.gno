package campaigns

import "testing"

func TestPledgeAmount(t *testing.T) {
	badAmounts := []int64{-1, 0}

	pid := PledgeID(1)
	for _, amount := range badAmounts {
		_, err := newPledge(pid, "", amount, "I love this campaign")
		if err == nil {
			t.Errorf("Expected error for amount %d", amount)
		}
	}
}
