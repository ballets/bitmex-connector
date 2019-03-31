import ballerina/http;
import ballerina/io;
import ballerina/log;
import ballerina/system;

public type TradeClient client object {
    
    private http:Client tradeClient;
    private string apiKey;
    private string apiSecret;

    public function __init(http:Client bitmexClient, string apiKey, string apiSecret) {
        self.tradeClient = bitmexClient;
        self.apiKey = apiKey;
        self.apiSecret = apiSecret;
    }

    public remote function getTrade(string symbol, int count, boolean reverse) returns Trade[]|error;
};

public remote function TradeClient.getTrade(string symbol, int count, boolean reverse) returns (Trade[]|error) {

    http:Client clientEndpoint = self.tradeClient;
    string path = GET_TRADE_PATH + "?symbol=" + symbol + "&count=" + count + "&reverse=" + reverse;
    string verb = GET;
    http:Request request = new;

    string correlationId = system:uuid();

    string msg = string `[id: ${correlationId}]. Calling ${verb} ${path}`;
    log:printInfo(msg);
    
    var httpResponse = clientEndpoint->get(path, message = request);

    json|error jsonPayload = validateResponse(httpResponse, correlationId);
    if (jsonPayload is json) {
        Trade[]|error trades = Trade[].convert(jsonPayload);
        if (trades is Trade[]) {
            msg = string `[id: ${correlationId}]. trade: ${io:sprintf("%s", trades)}`;
            log:printDebug(msg);
            return trades;
        } else {
            msg = string `[id: ${correlationId}]. tradeError: ${<string> trades.detail().message}`;
            log:printError(msg, err = trades);
            error err = error(BITMEX_ERROR_CODE, { message: "Unexpected response format from the REST API" });
            return err;                
        }
    } else {
        return jsonPayload;
    }
}