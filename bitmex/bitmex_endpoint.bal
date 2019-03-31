import ballerina/http;
import ballerina/io;

public type BitmexClient client object {
    
    http:Client bitmexClient;
    private AnnouncementClient announcementClient;
    private UserClient userClient;
    private OrderClient orderClient;
    private PositionClient positionClient;
    string apiKey;
    string apiSecret;

    public function __init(BitMexConfiguration bitmexConfig) {
        self.bitmexClient = new(bitmexConfig.uri, config = bitmexConfig.clientConfig);
        self.apiKey = bitmexConfig.apiKey;
        self.apiSecret = bitmexConfig.apiSecret;
        self.announcementClient = new(self.bitmexClient, self.apiKey, self.apiSecret);
        self.userClient = new(self.bitmexClient, self.apiKey, self.apiSecret);
        self.orderClient = new(self.bitmexClient, self.apiKey, self.apiSecret);
        self.positionClient = new(self.bitmexClient, self.apiKey, self.apiSecret);
    }

    // public remote function getTrade(string symbol, int count, boolean reverse) returns Trade[]|error;    

    public function getAnnouncementClient() returns AnnouncementClient {
        return self.announcementClient;
    }

    public function getUserClient() returns UserClient {
        return self.userClient;
    }

    public function getOrderClient() returns OrderClient {
        return self.orderClient;
    }

    public function getPositionClient() returns PositionClient {
        return self.positionClient;
    }
};

public type BitMexConfiguration record {
    string uri;
    string apiKey;
    string apiSecret;
    http:ClientEndpointConfig clientConfig = {};
};

// public remote function BitmexClient.getTrade(string symbol, int count, boolean reverse) returns (Trade[]|error) {

//     http:Client clientEndpoint = self.bitmexClient;
//     string path = GET_TRADE_PATH + "?symbol=" + symbol + "&count=" + count + "&reverse=" + reverse;
//     http:Request request = new;

//     io:println("Calling BitMex.getTrade()");
//     var httpResponse = clientEndpoint->get(path, message = request);
//     if (httpResponse is http:Response) {
//         int statusCode = httpResponse.statusCode;
//         var jsonPayload = httpResponse.getJsonPayload();
//         if (jsonPayload is json[]) {
//             if (statusCode == 200) {
//                 // int i = 0;
//                 Trade[]|error trades = Trade[].convert(jsonPayload);
//                 // foreach json j in jsonPayload {
//                 //     io:println(j);
//                 //     Trade|error trade = Trade.convert(j);
//                 //     io:println(trade);
//                 //     if (trade is Trade) {
//                 //         trades[i] = trade;
//                 //         i = i + 1;
//                 //     } else {
//                 //         error err = error(BITMEX_ERROR_CODE, { message: "Unexpected response format from the REST API" });
//                 //         return err; 
//                 //     }
//                 //     io:println("inter past");
//                 // }
//                 return trades;
//             } else {
//                 return setResponseError(statusCode, jsonPayload);
//             }          
//         } else {
//             error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while accessing the JSON payload of the response" });
//             return err;
//         }
//     } else {
//         error err = error(BITMEX_ERROR_CODE, { message: "Error occurred while invoking the REST API" });
//         return err;
//     }
// }