.PHONY: build add

all: build

build:
	gno gnofundme/gnofundme

add:
	gnokey maketx addpkg \
	--pkgpath "gno.land/r/demo/gnofundme" \
	--pkgdir "/Users/jdkato/Documents/Code/Gno/gnofundme/gnofundme" \
	--deposit "100000000ugnot" --gas-fee "1000000ugnot" \
	--gas-wanted "5000000" --broadcast --chainid dev \
	--remote localhost:26657 \
	yourkey