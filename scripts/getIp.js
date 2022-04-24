let address,
	ifaces = require('os').networkInterfaces()

let { writeFileSync } = require('fs')

for (var dev in ifaces) {
	ifaces[dev].filter((details) =>
		details.family === 'IPv4' && details.internal === false ? (address = details.address) : undefined
	)
}

writeFileSync('ip.txt', address)
