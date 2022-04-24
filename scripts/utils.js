const args = require('minimist')(process.argv.splice(2))

function CheckOptionExist(...options) {
	options.forEach((option) => {
		if (!(option in args)) {
			console.log(args)
			throw new Error(`Option --"${option}" is absent`)
		}
	})
}

module.exports = { args, CheckOptionExist }
