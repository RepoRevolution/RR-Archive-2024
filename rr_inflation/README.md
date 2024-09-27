# rr_inflation
Inflation system to protect yours economy!

## Dependencies
The script is **drag and drop** designed to run in any environment where scripts are installed:
- [oxmysql](https://github.com/overextended/oxmysql) v.2.6.0+
- [ox_lib](https://github.com/overextended/ox_lib) v.3.0.0+

## Installation
Installation is **very simple**:
1. Extract the script to the `@server-data/resources` folder.
2. Add `ensure rr_inflation` on the top `server.cfg` configuration file.
3. Make your own configuration `config.lua`.
4. Start the server and enjoy the game!
**Warning!** On first start script saves start money data to calculate inflation, so you need to start this resource only if your start money was spawned on shared accounts, fe. police, ambulance.

### Shared - getInflation
Export to get inflation percent from client and server side. This example has a built-in check to see if the script is enabled, if not it returns a default value.
```lua
local inflationPercent = GetResourceState('rr_inflation') == 'started' and exports['rr_inflation']:getInflation() or 0.0
```

### Client NUI - getInflation
Callback to get inflation percent from user interface.
```js
var inflationPercent = 0.0
$.post(`https://rr_inflation/getInflation`, JSON.stringify(),
    function(inflation) {
        inflationPercent = inflation;
    }
);
```

### Shared - getPrice
Export to get price with inflation from client and server side. This example has a built-in check to see if the script is enabled, if not it returns a default value.
```lua
local examplePrice = GetResourceState('rr_inflation') == 'started' and exports['rr_inflation']:getPrice(defaultPrice) or defaultPrice
```

### Client NUI - getPrice
Callback to get price with inflation from user interface.
```js
var examplePrice = 0.0
$.post(`https://rr_inflation/getPrice`, JSON.stringify(defaultPrice),
    function(inflationPrice) {
        examplePrice = inflationPrice;
    }
);
```

### Server - addMoney
Adding money to your starting money. These exports are intended to protect the creation of money, fe. a bank robbery - the player receives a certain amount of cash, but this cash in real life exists before the player gets it out of the safe, so we add it to the initial money to protect inflation from running rampant.
```lua
exports['rr_inflation']:addMoney(amount)
```