const { args, CheckOptionExist } = require('./utils')
CheckOptionExist('key', 'pass')
const web3 = require('./web3').web3
;(async () => {
	console.log(await web3.eth.personal.importRawKey(args.key, args.pass.toString()))
})()
