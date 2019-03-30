// Base path
final string BASE_PATH = "/api/v1";


final string GET_TRADE_PATH = BASE_PATH + "/trade";
final string GET_POSITION_PATH = BASE_PATH + "/position";
final string SET_LEVERAGE_PATH = BASE_PATH + "/position/leverage";

// Announcement API resources
final string ANNOUNCEMENT_BASE_PATH = BASE_PATH + "/announcement";
final string ANNOUNCEMENT_URGENT_PATH = ANNOUNCEMENT_BASE_PATH + "/urgent";

// User API resources
final string USER_BASE_PATH = BASE_PATH + "/user";
final string MARGIN_PATH = USER_BASE_PATH + "/margin";

// Order API resources
final string ORDER_BASE_PATH = BASE_PATH + "/order";
final string ORDER_BULK_PATH = ORDER_BASE_PATH + "/bulk";
final string ORDER_ALL_PATH = ORDER_BASE_PATH + "/all";

//string constants
final string POST = "POST";
final string PUT = "PUT";
final string GET = "GET";
final string DELETE = "DELETE";

// Error Codes
final string BITMEX_ERROR_CODE = "(raj/bitmex)BitMexError";