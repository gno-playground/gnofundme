package campaigns

import (
	"strings"

	"gno.land/p/demo/ufmt"
)

// Render returns a Markdown-formatted representation of the GnoFundMe realm.
func Render(path string) string {
	// root landing page
	//
	// /r/demo/gnofundme
	if path == "" {
		return renderRealm()
	}

	parts := strings.Split(path, "/")
	switch len(parts) {
	case 1:
		// campaign landing page
		//
		// /r/demo/gnofundme/campaigns:TITLE
		//
		// title == campaigns:TITLE
		return renderCampaign(parts[0])

		// TODO: render pledge page?
	}

	return ufmt.Sprintf("unrecognized path, '%s'", path)
}

// renderRealm returns a Markdown-formatted representation of the GnoFundMe
// realm.
//
// TODO: show the status (open/closed)?
func renderRealm() string {
	str := "These are all the campaigns of this realm:\n\n"
	gCampaigns.Iterate("", "", func(key string, value interface{}) bool {
		campaign := value.(*Campaign)
		str += " * [" + campaign.url + "](" + campaign.url + ")\n"
		return false
	})
	return str
}

// renderCampaign returns a Markdown-formatted representation of the GnoFundMe
// campaign.
func renderCampaign(title string) string {
	found, ok := gCampaignsByTitle.Get(title)
	if !ok {
		return ufmt.Sprintf("campaign not found, '%s'", title)
	}
	return found.(*Campaign).render()
}
