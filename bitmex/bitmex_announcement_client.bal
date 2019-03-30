import ballerina/http;
import ballerina/io;
import ballerina/log;
import ballerina/system;

public type AnnouncementClient client object {
    
    private http:Client announcementClient;
    private string apiKey;
    private string apiSecret;

    public function __init(http:Client bitmexClient, string apiKey, string apiSecret) {
        self.announcementClient = bitmexClient;
        self.apiKey = apiKey;
        self.apiSecret = apiSecret;
    }

    public remote function announcement() returns Announcement[]|error; 
    public remote function announcementUrgent() returns Announcement[]|error;
};

public remote function AnnouncementClient.announcement() returns Announcement[]|error {
    
    http:Client clientEndpoint = self.announcementClient;
    string path = ANNOUNCEMENT_BASE_PATH;
    string verb = GET;
    string data = "";
    http:Request request = new;

    string correlationId = system:uuid();

    string msg = string `[id: ${correlationId}]. Calling ${verb} ${path}`;
    log:printInfo(msg);

    var httpResponse = clientEndpoint->get(path, message = request);

    json|error jsonPayload = validateResponse(httpResponse, correlationId);
    if (jsonPayload is json) {
        Announcement[]|error announcement = Announcement[].convert(jsonPayload);
        
        if (announcement is Announcement[]) {
            msg = string `[id: ${correlationId}]. announcement: ${io:sprintf("%s", announcement)}`;
            log:printDebug(msg);
            return announcement;
        } else {
            msg = string `[id: ${correlationId}]. announcementError: ${<string> announcement.detail().message}`;
            log:printError(msg, err = announcement);
            error err = error(BITMEX_ERROR_CODE, { message: "Unexpected response format from the REST API" });
            return err;                
        }
    } else {
        return jsonPayload;
    }
}

public remote function AnnouncementClient.announcementUrgent() returns Announcement[]|error {
    
    http:Client clientEndpoint = self.announcementClient;
    string path = ANNOUNCEMENT_URGENT_PATH;
    string verb = GET;
    string data = "";
    http:Request request = new;

    string correlationId = system:uuid();

    string msg = string `[id: ${correlationId}]. Calling ${verb} ${path}`;
    log:printInfo(msg);

    var httpResponse = clientEndpoint->get(path, message = request);

    json|error jsonPayload = validateResponse(httpResponse, correlationId);
    if (jsonPayload is json) {
        Announcement[]|error announcement = Announcement[].convert(jsonPayload);
        if (announcement is Announcement[]) {
            msg = string `[id: ${correlationId}]. announcement: ${io:sprintf("%s", announcement)}`;
            log:printDebug(msg);
            return announcement;
        } else {
            msg = string `[id: ${correlationId}]. announcementError: ${<string> announcement.detail().message}`;
            log:printError(msg, err = announcement);
            error err = error(BITMEX_ERROR_CODE, { message: "Unexpected response format from the REST API" });
            return err;                
        }
    } else {
        return jsonPayload;
    }
}