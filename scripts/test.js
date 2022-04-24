const web3 = require('./web3').web3
const { writeFileSync } = require('fs')
const data = require('../bin/contracts/MaxCoin.json')

async function Deploy() {
	let address = (await web3.eth.getAccounts())[0]
	await web3.eth.personal.unlockAccount(address, '1111', 9999999)
	let contract = new web3.eth.Contract(data.abi)
	let hash
	await contract.deploy({ data: data.bytecode }).send({ from: address }, function (err, thash) {
		hash = thash
	})
	let receipt = await web3.eth.getTransactionReceipt(hash)
	writeFileSync('./data.json', JSON.stringify({ conAddr: receipt.contractAddress, abi: data.abi }))
}

Deploy()
