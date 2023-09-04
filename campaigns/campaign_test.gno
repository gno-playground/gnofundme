package campaigns

import "testing"

var testCampaign, _ = newCampaign(
	"",
	CampaignID(1),
	"My Campaign",
	"Really cool campaign.",
	"test",
	150,
	30,
)

func TestCampaignActions(t *testing.T) {
	pid, err := testCampaign.addPledge("", -1, "I love this campaign!")
	if err == nil {
		t.Errorf("expected error for negative pledge amount")
	}

	pid, err = testCampaign.addPledge("", 0, "I love this campaign!")
	if err == nil {
		t.Errorf("expected error for zero pledge amount")
	}
}

func TestTitleCampaign(t *testing.T) {
	badTitles := []string{
		" ",
		"",
		"1234567890123456789012345678901234567890123456789012345678901234567890",
	}

	cid := CampaignID(1)
	for _, title := range badTitles {
		_, err := newCampaign("", cid, title, "test", "test", 1, 1)
		if err == nil {
			t.Errorf("expected error for title %q", title)
		}
	}
}

func TestDescriptionCampaign(t *testing.T) {
	badDescriptions := []string{" ", ""}

	cid := CampaignID(1)
	for _, description := range badDescriptions {
		_, err := newCampaign("", cid, "test", "test", description, 1, 1)
		if err == nil {
			t.Errorf("expected error for description %q", description)
		}
	}
}

func TestDurationCampaign(t *testing.T) {
	badDurations := []int{0, -1, 69}

	cid := CampaignID(1)
	for _, duration := range badDurations {
		_, err := newCampaign("", cid, "test", "test", "test", 1, duration)
		if err == nil {
			t.Errorf("expected error for duration %d", duration)
		}
	}
}

func TestGoalCampaign(t *testing.T) {
	badGoals := []int{0, -1, 70}

	cid := CampaignID(1)
	for _, goal := range badGoals {
		_, err := newCampaign("", cid, "test", "test", "test", goal, 1)
		if err == nil {
			t.Errorf("expected error for goal %d", goal)
		}
	}
}
