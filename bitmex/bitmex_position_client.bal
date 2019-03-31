import ballerina/http;
import ballerina/io;
import ballerina/log;
import ballerina/system;

public type PositionClient client object {
    
    private http:Client positionClient;
    private string apiKey;
    private string apiSecret;

    public function __init(http:Client bitmexClient, string apiKey, string apiSecret) {
        self.positionClient = bitmexClient;
        self.apiKey = apiKey;
        self.apiSecret = apiSecret;
    }

    public remote function getPositions() returns Position[]|error;

    public remote function setLeverage(string symbol, float leverage) returns error?;
};

public remote function PositionClient.getPositions() returns Position[]|error {

    http:Client clientEndpoint = self.positionClient;
    string path = GET_POSITION_PATH;
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
        Position[]|error positions  = Position[].convert(jsonPayload);
        if (positions is Position[]) {
            msg = string `[id: ${correlationId}]. position: ${io:sprintf("%s", positions)}`;
            log:printDebug(msg);
            return positions;
        } else {
            msg = string `[id: ${correlationId}]. positionError: ${<string> positions.detail().message}`;
            log:printError(msg, err = positions);
            error err = error(BITMEX_ERROR_CODE, { message: "Unexpected response format from the REST API" });
            return err;                
        }
    } else {
        return jsonPayload;
    }
}

public remote function PositionClient.setLeverage(string symbol, float leverage) returns error? {

    http:Client clientEndpoint = self.positionClient;
    string path = SET_LEVERAGE_PATH;
    string verb = POST;

    json payload = {"symbol":symbol,"leverage":leverage};

    http:Request request = new;
    request.setJsonPayload(payload, contentType = "application/json");

    constructRequestHeaders(request, verb, self.apiKey, self.apiSecret, path, payload.toString());

    string correlationId = system:uuid();

    string msg = string `[id: ${correlationId}]. Calling ${verb} ${path}`;
    log:printInfo(msg);

    var httpResponse = clientEndpoint->post(path, request);

    json|error jsonPayload = validateResponse(httpResponse, correlationId);
    if (jsonPayload is json) {
        return ();
    } else {
        return jsonPayload;
    }
}