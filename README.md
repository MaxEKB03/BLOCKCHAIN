# BLOCKCHAIN

### Test Project to learn blockchain technology

`npm i` - to install modules

### requires:

file `ip.txt` on main directory with only ip

### npm-scripts:

`npm run geth-init`

`npm run get-ip` - to create file `ip.txt`

`npm run new-account`

`npm run geth-run` - need account to mine

`npm run geth-console`

### scripts

web3.js:

`module.exports.web3 = web3`

`module.exports.toEther = toEther`

utils.js:

`module.exports = { args, CheckOptionExist }`

### more intresting:

deploy.js - `node ./deploy.js --con <ContractName>`

export.js - `node ./export.js --file <file name from keystore> --pass <password of account>`

import.js - `node ./import.js --key <private key> --pass <new password>`
