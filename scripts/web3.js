const Web3 = require('web3')
const { readFileSync } = require('fs')

const ip = readFileSync('../ip.txt', 'utf-8')
const web3 = new Web3(`http://${ip}:8545`)
// const web3 = new Web3(`https://rpc-mumbai.matic.today`)

function toEther(wei) {
	return web3.utils.fromWei(`${wei}`, 'ether')
}

module.exports.web3 = web3
module.exports.toEther = toEther
