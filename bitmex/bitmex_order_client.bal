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

    public remote function getOrders(GetOrderRequest getOrderRequest) returns Order[]|error;

    public remote function createOrder(Order ordr) returns Order|error;

    public remote function createOrders(Order[] orders) returns Order[]|error;

    public remote function cancelOrders(string orderID = "", string clOrdID = "", 
        string text = "") returns Order[]|error;

    public remote function cancelAllOrders(string symbol = "", string filter = "", 
        string text = "") returns Order[]|error;

    public remote function updateOrder(Order ordr) returns Order|error;
};

public remote function OrderClient.getOrders(GetOrderRequest getOrderRequest) returns Order[]|error {

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

public remote function OrderClient.createOrder(Order ordr) returns Order|error {

    http:Client clientEndpoint = self.orderClient;
    string path = ORDER_BASE_PATH;
    string verb = POST;
    json payload = {};

    var orderJson = json.convert(ordr);
    if (orderJson is json) {
        payload = orderJson;
    }

    http:Request request = new;
    request.setJsonPayload(payload, contentType = "application/json");

    io:println(payload.toString());

    constructRequestHeaders(request, verb, self.apiKey, self.apiSecret, path, payload.toString());

    string correlationId = system:uuid();

    string msg = string `[id: ${correlationId}]. Calling ${verb} ${path}`;
    log:printInfo(msg);

    var httpResponse = clientEndpoint->post(path, request);

    json|error jsonPayload = validateResponse(httpResponse, correlationId);
    if (jsonPayload is json) {
        Order|error ord  = Order.convert(jsonPayload);
        if (ord is Order) {
            msg = string `[id: ${correlationId}]. order: ${io:sprintf("%s", ord)}`;
            log:printDebug(msg);
            return ord;
        } else {
            msg = string `[id: ${correlationId}]. ordError: ${<string> ord.detail().message}`;
            log:printError(msg, err = ord);
            error err = error(BITMEX_ERROR_CODE, { message: "Unexpected response format from the REST API" });
            return err;                
        }
    } else {
        return jsonPayload;
    }
}

public remote function OrderClient.createOrders(Order[] orders) returns Order[]|error {

    http:Client clientEndpoint = self.orderClient;
    string path = ORDER_BULK_PATH;
    string verb = POST;

    json[] ordersJson = [];
    int i = 0;
    foreach Order ord in orders {
        var orderJson = json.convert(ord);
        if (orderJson is json) {
            ordersJson[i] = orderJson;
        }
        i = i + 1;
    }

    json payload = {"orders":ordersJson};

    http:Request request = new;
    request.setJsonPayload(payload, contentType = "application/json");

    constructRequestHeaders(request, verb, self.apiKey, self.apiSecret, path, payload.toString());

    string correlationId = system:uuid();

    string msg = string `[id: ${correlationId}]. Calling ${verb} ${path}`;
    log:printInfo(msg);

    var httpResponse = clientEndpoint->post(path, request);

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

public remote function OrderClient.cancelOrders(string orderID = "", string clOrdID = "", 
        string text = "") returns Order[]|error {

    http:Client clientEndpoint = self.orderClient;
    string path = ORDER_BASE_PATH;
    string verb = DELETE;
    string data = "";
    http:Request request = new;

    json payload = {};
    if (orderID != "") {
        payload.orderID = orderID;
    }
    if (clOrdID != "") {
        payload.clOrdID = clOrdID;
    }
    if (text != "") {
        payload.text = text;
    }

    data = payload.toString();
    request.setJsonPayload(payload, contentType = "application/json");
  
    constructRequestHeaders(request, verb, self.apiKey, self.apiSecret, path, data);

    string correlationId = system:uuid();

    string msg = string `[id: ${correlationId}]. Calling ${verb} ${path}`;
    log:printInfo(msg);

    var httpResponse = clientEndpoint->delete(path, request);

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

public remote function OrderClient.cancelAllOrders(string symbol = "", string filter = "", 
        string text = "") returns Order[]|error {

    http:Client clientEndpoint = self.orderClient;
    string path = ORDER_ALL_PATH;
    string verb = DELETE;
    string data = "";
    http:Request request = new;

    if (symbol != "" || filter != "" || text != "") {
        json payload = {};
        if (symbol != "") {
            payload.symbol= symbol;
        }
        if (filter != "") {
            payload.filter = filter;
        }
        if (text != "") {
            payload.text = text;
        }
        data = payload.toString();
        request.setJsonPayload(payload, contentType = "application/json");
    }
    
    constructRequestHeaders(request, verb, self.apiKey, self.apiSecret, path, data);

    string correlationId = system:uuid();

    string msg = string `[id: ${correlationId}]. Calling ${verb} ${path}`;
    log:printInfo(msg);

    var httpResponse = clientEndpoint->delete(path, request);

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

public remote function OrderClient.updateOrder(Order ordr) returns (Order|error) {

    http:Client clientEndpoint = self.orderClient;
    string path = ORDER_BASE_PATH;
    string verb = PUT;
    json payload = {};

    var orderJson = json.convert(ordr);
    if (orderJson is json) {
        payload = orderJson;
    }

    http:Request request = new;
    request.setJsonPayload(payload, contentType = "application/json");

    constructRequestHeaders(request, verb, self.apiKey, self.apiSecret, path, payload.toString());

    string correlationId = system:uuid();

    string msg = string `[id: ${correlationId}]. Calling ${verb} ${path}`;
    log:printInfo(msg);

    var httpResponse = clientEndpoint->put(path, request);

    json|error jsonPayload = validateResponse(httpResponse, correlationId);
    if (jsonPayload is json) {
        Order|error ord  = Order.convert(jsonPayload);
        if (ord is Order) {
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