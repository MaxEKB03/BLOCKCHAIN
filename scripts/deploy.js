const { args, CheckOptionExist } = require('./utils')
CheckOptionExist('con')
const web3 = require('./web3').web3
const data = require(`../bin/contracts/${args.con}.json`)
const { writeFileSync } = require('fs')

Deploy()

async function Deploy() {
	let hash, receipt

	const address = (await web3.eth.getAccounts())[0]
	await web3.eth.personal.unlockAccount(address, '1111')
	let contract = new web3.eth.Contract(data.abi)
	await contract.deploy({ data: data.bytecode }).send({ from: address }, function (err, thash) {
		hash = thash
	})
	receipt = await web3.eth.getTransactionReceipt(hash)
	console.log(receipt.contractAddress)
	writeFileSync(
		`../build/deployed/${args.con}.json`,
		JSON.stringify({ conAddr: receipt.contractAddress, conName: args.con, abi: data.abi, data: data.bytecode })
	)
}
