import ballerina/http;
import ballerina/io;
import ballerina/log;
import ballerina/system;

public type OrderClient client object {
    
    private http:Client orderClient;
    private string apiKey;
    private string apiSecret;

    public function __init(http:Client bitmexClient, string apiKey, string apiSecret) {
        self.orderClient = bitmexClient;
        self.apiKey = apiKey;
        self.apiSecret = apiSecret;
    }

    public remote function getOrder(GetOrderRequest getOrderRequest) returns Order[]|error;
};

public remote function OrderClient.getOrder(GetOrderRequest getOrderRequest) returns Order[]|error {

    http:Client clientEndpoint = self.orderClient;
    string path = ORDER_BASE_PATH;
    string uriParams = "";

    if (getOrderRequest.symbol != "") {
        uriParams = string `${uriParams}&symbol=${getOrderRequest.symbol}`;
    }

    if (getOrderRequest.filter != "") {
        uriParams = string `${uriParams}&filter=${getOrderRequest.filter}`;
    }

    if (getOrderRequest.columns != "") {
        uriParams = string `${uriParams}&columns=${getOrderRequest.columns}`;
    }

    if (getOrderRequest.count != 0) {
        uriParams = string `${uriParams}&count=${getOrderRequest.count}`;
    }

    if (getOrderRequest.^"start" != 0) {
        uriParams = string `${uriParams}&count=${getOrderRequest.^"start"}`;
    }

    if (getOrderRequest.reverse != false) {
        uriParams = string `${uriParams}&reverse=${getOrderRequest.reverse}`;
    }

    if (getOrderRequest.startTime != "") {
        uriParams = string `${uriParams}&startTime=${getOrderRequest.startTime}`;
    }

    if (getOrderRequest.endTime != "") {
        uriParams = string `${uriParams}&endTime=${getOrderRequest.endTime}`;
    }

    // string path = ORDER_BASE_PATH + "?filter=%7B%22open%22%3A%20true%7D&count=100&reverse=false";

    if (uriParams != "") {
        path = string `${path}?${uriParams.substring(1,uriParams.length())}`;
    }

    string verb = GET;
    string data = "";
    http:Request request = new;
    
    constructRequestHeaders(request, verb, self.apiKey, self.apiSecret, path, data);

    string correlationId = system:uuid();

    string msg = string `[id: ${correlationId}]. Calling ${verb} ${path}`;
    log:printInfo(msg);

    var httpResponse = clientEndpoint->get(path, message = request);

    json|error jsonPayload = validateResponse(httpResponse, correlationId);
    if (jsonPayload is json) {
        Order[]|error ord  = Order[].convert(jsonPayload);
        if (ord is Order[]) {
            msg = string `[id: ${correlationId}]. order: ${io:sprintf("%s", ord)}`;
            log:printDebug(msg);
            return ord;
        } else {
            msg = string `[id: ${correlationId}]. orderError: ${<string> ord.detail().message}`;
            log:printError(msg, err = ord);

            error err = error(BITMEX_ERROR_CODE, { message: "Unexpected response format from the REST API" });
            return err;                
        }
    } else {
        return jsonPayload;
    }

}