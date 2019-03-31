import ballerina/http;
import ballerina/io;

public type BitmexClient client object {
    
    http:Client bitmexClient;
    private AnnouncementClient announcementClient;
    private UserClient userClient;
    private OrderClient orderClient;
    private PositionClient positionClient;
    private TradeClient tradeClient;
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
        self.tradeClient = new(self.bitmexClient, self.apiKey, self.apiSecret);
    }

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

    public function getTradeClient() returns TradeClient {
        return self.tradeClient;
    }
};

public type BitMexConfiguration record {
    string uri;
    string apiKey;
    string apiSecret;
    http:ClientEndpointConfig clientConfig = {};
};