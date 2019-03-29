Connects to BitMex from Ballerina. 

# Module Overview

The BitMex connector allows you to interact with BitMex through the BitMex REST API. You can use it to develop BitMex Bots.

## Compatibility
|                    |    Version     |  
|:------------------:|:--------------:|
| Ballerina Language |   0.990.2      |
| BitMex API         |   2.1          |

## Example

```ballerina
import ballerina/io;
import raj/bitmex;

bitmex:Client bitmexClient = new({
    uri: config:getAsString("bitmex.uri", default = ""),
    apiKey: config:getAsString("bitmex.apiKey", default = ""),
    apiSecret: config:getAsString("bitmex.apiSecret", default = "")
});

public function main(string... args) {
    io:println(getPrice("XBTUSD"));
}

function getPrice(string symbol) returns float? {
    bitmex:Trade[]|error trades = bitmexClient->getTrade(symbol, 1, true);
    if (trades is bitmex:Trade[]) {
        int|float price = trades[0].price;
        if (price is int) {
            return <float> price;
        } else {
            return price;
        }
    } else {
        return null;
    }
}
```