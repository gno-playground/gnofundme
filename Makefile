.PHONY: build add create

build:
	gno build $(PWD)/gnofundme

create:
	gnokey maketx addpkg \
	--pkgpath "gno.land/r/demo/gnofundme" \
	--pkgdir "$(PWD)/gnofundme" \
	--deposit "100000000ugnot" --gas-fee "1000000ugnot" \
	--gas-wanted "4000000" --broadcast --chainid dev \
	--remote localhost:26657 \
	jdkey

add:
	gnokey maketx call \
	--pkgpath "gno.land/r/demo/gnofundme" --func "CreateCampaign" \
	--args "init" --args "The first campaign" --args "100" --args "30" \
	--gas-fee "1000000ugnot" --gas-wanted "2000000" \
	--broadcast --chainid dev --remote localhost:26657 \
	--send "200000000ugnot" \
	jdkey

