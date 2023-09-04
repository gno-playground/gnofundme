.PHONY: build add create auth

build:
	gno build /Users/jdkato/Documents/Code/Gno/gno/examples/gno.land/r/demo/campaigns

create:
	gnokey maketx addpkg \
	--pkgpath "gno.land/r/demo/campaigns" \
	--pkgdir "$(PWD)/campaigns" \
	--deposit "100000000ugnot" --gas-fee "1000000ugnot" \
	--gas-wanted "5000000" --broadcast --chainid dev \
	--remote localhost:26657 \
	jdkey

add:
	gnokey maketx call \
	--pkgpath "gno.land/r/demo/campaigns" --func "Launch" \
	--args "gnols" --args "An implementation of the Language Server Protocol (LSP) for the Gno programming language." --args "150" --args "30" \
	--gas-fee "1000000ugnot" --gas-wanted "5000000" \
	--broadcast --chainid dev --remote localhost:26657 \
	--send "200000000ugnot" \
	jdkey


pledge:
	gnokey maketx call \
	--pkgpath "gno.land/r/demo/campaigns" --func "MakePledge" \
	--args "init" --args "100" --args "pledge_reason" \
	--gas-fee "1000000ugnot" --gas-wanted "2000000" \
	--broadcast --chainid dev --remote localhost:26657 \
	--send "200000000ugnot" \
	jdkey


auth:
	gnokey maketx call \
	--pkgpath "gno.land/r/demo/users" --func "Register" \
	--args "" --args "jdkato" --args "noprofile" \
	--gas-fee "1000000ugnot" --gas-wanted "2000000" \
	--broadcast --chainid dev --remote localhost:26657 \
	--send "200000000ugnot" \
	jdkey