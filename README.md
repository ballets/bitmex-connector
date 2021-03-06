# Ballerina BitMex Connector

The BitMex connector allows you to interact with BitMex through the BitMex Bot API. You can use it to develop BitMex Bots.

## Compatibility
| Ballerina Language Version | BitMex API version  |
| -------------------------- | -------------------- |
| 0.983.0                    | 4.1                  |


The following sections provide you with information on how to use the Ballerina BitMex connector.

- [Contribute To Develop](#contribute-to-develop)
- [Example](#example)

### Contribute To develop

Clone the repository by running the following command 
```shell
git clone https://github.com/raj-rajaratnam/ballerina-bitmex.git
```

##### Example

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
