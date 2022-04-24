const { args, CheckOptionExist } = require('./utils')
CheckOptionExist('file', 'pass')
const web3 = require('./web3').web3
const { readFileSync } = require('fs')
const file = readFileSync(`../geth/data/keystore/${args.file}`, 'utf-8')
const json = JSON.parse(file)
const decrypt = web3.eth.accounts.decrypt(json, args.pass.toString())
console.log(decrypt)
