package gnofundme

// Render returns a Markdown-formatted representation of the GnoFundMe realm.
//
// Information to display:
//
// - [ ] The campaign's title
// - [ ] The campaign's description
// - [ ] The campaign's goal amount
// - [ ] The campaign's current amount pledged
// - [ ] The campaign's deadline
// - [ ] The campaign's creator
// - [ ] The campaign's status (open or closed)
// - [ ] The campaign's contributors (leaderboard-style?)
func Render(path string) string {
	if path == "" {
		str := "These are all the campaigns of this realm:\n\n"
		gCampaigns.Iterate("", "", func(key string, value interface{}) bool {
			campaign := value.(*Campaign)
			str += " * [" + campaign.url + "](" + campaign.url + ")\n"
			return false
		})
		return str
	}
	return "TODO"
}
