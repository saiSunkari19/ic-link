module github.com/saiSunkari19/ic-link

go 1.13

require (
	github.com/btcsuite/btcd v0.0.0-20190807005414-4063feeff79a // indirect
	github.com/cosmos/cosmos-sdk v0.34.4-0.20200417201027-11528d39594c
	github.com/onsi/ginkgo v1.8.0 // indirect
	github.com/onsi/gomega v1.5.0 // indirect
	github.com/pkg/errors v0.9.1
	github.com/rcrowley/go-metrics v0.0.0-20190706150252-9beb055b7962 // indirect
	github.com/spf13/afero v1.2.2 // indirect
	github.com/spf13/cobra v1.0.0
	github.com/spf13/viper v1.6.3
	github.com/tendermint/go-amino v0.15.1
	github.com/tendermint/tendermint v0.33.3
	github.com/tendermint/tm-db v0.5.1
	golang.org/x/net v0.0.0-20190827160401-ba9fcec4b297 // indirect
)

//  replace github.com/tendermint/tendermint => ../../../github.com/tendermint/tendermint
// replace github.com/cosmos/cosmos-sdk => ../../../github.com/cosmos/cosmos-sdk
