// User types
public type User record {
    int? id;
    int? ownerId;
    string? firstname;
    string? lastname;
    string username;
    string email;
    string? phone;
    string? created;
    string? lastUpdated;
    UserPreferences preferences;
    string? TFAEnabled;
    string? affiliateID;
    string? pgpPubKey;
    string? country;
    string? geoipCountry;
    string? geoipRegion;
    string? typ;
};

public type UserPreferences record {
    boolean? alertOnLiquidations?;
    boolean? animationsEnabled?;
    string? announcementsLastSeen?;
    int? chatChannelID?;
    string? colorTheme?;
    string? currency?;
    boolean? debug?;
    string[]? disableEmails?;
    string[]? disablePush?;
    string[]? hideConfirmDialogs?;
    boolean? hideConnectionModal?;
    boolean? hideFromLeaderboard?;
    boolean? hideNameFromLeaderboard?;
    string[]? hideNotifications?;
    string? locale?;
    string[]? msgsSeen?;
    string? orderBookType?;
    boolean? orderClearImmediate?;
    boolean? orderControlsPlusMinus?;
    boolean? showLocaleNumbers?;
    string[]? sounds?;
    boolean? strictIPCheck?;
    boolean? strictTimeout?;
    string? tickerGroup?;
    boolean? tickerPinned?;
    string? tradeLayout?;
};

public type Margin record {
    int account = 0;
    string currency;
    int? riskLimit?;
    string? prevState?;
    string? state?;
    string? action?;
    int? amount?;
    int? pendingCredit?;
    int? pendingDebit?;
    int? confirmedDebit?;
    int? prevRealisedPnl?;
    int? prevUnrealisedPnl?;
    int? grossComm?;
    int? grossOpenCost?;
    int? grossOpenPremium?;
    int? grossExecCost?;
    int? grossMarkValue?;
    int? riskValue?;
    int? taxableMargin?;
    int? initMargin?;
    int? maintMargin?;
    int? sessionMargin?;
    int? targetExcessMargin?;
    int? varMargin?;
    int? realisedPnl?;
    int? unrealisedPnl?;
    int? indicativeTax?;
    int? unrealisedProfit?;
    int? syntheticMargin?;
    int? walletBalance?;
    int? marginBalance?;
    int|float? marginBalancePcnt?;
    int|float? marginLeverage?;
    int|float? marginUsedPcnt?;
    int? excessMargin?;
    int|float? excessMarginPcnt?;
    int? availableMargin?;
    int? withdrawableMargin?;
    string? timestamp?;
    int? grossLastValue?;
    int|float? commission?;
};

// Order types
public type GetOrderRequest record {
    string symbol = "";
    string filter = "";
    string columns = "";
    int count = 0;
    int ^"start" = 0;
    boolean reverse = false;
    string startTime = "";
    string endTime = "";
};

public type Order record {
    string? orderID?;
    string? origClOrdID?;
    string? clOrdID?;
    string? clOrdLinkID?;
    int? account?;
    string? symbol?;
    string? side?;
    int? simpleOrderQty?;
    int? orderQty?;
    int|float? price?;
    int? displayQty?;
    int|float? stopPx?;
    int? pegOffsetValue?;
    string? pegPriceType?;
    string? currency?;
    string? settlCurrency?;
    string? ordType?;
    string? timeInForce?;
    string? execInst?;
    string? contingencyType?;
    string? exDestination?;
    string? ordStatus?;
    string? triggered?;
    boolean? workingIndicator?;
    string? ordRejReason?;
    int? simpleLeavesQty?;
    int? leavesQty?;
    int? simpleCumQty?;
    int? cumQty?;
    int|float? avgPx?;
    string? multiLegReportingType?;
    string? text?;
    string? transactTime?;
    string? timestamp?;
};

public type Trade record {
    string timestamp;
    string symbol;
    string side;
    int size;
    int|float price;
    string tickDirection;
    string trdMatchID;
    int grossValue;
    int|float homeNotional;
    int|float foreignNotional;
};

public type Position record {
    int account = 0;
    string symbol?;
    string currency?;
    int currentQty = 0;
    float|int? avgEntryPrice;
    float|int? liquidationPrice;
    boolean isOpen = false;
    float|int leverage = 0;
};

// Announcement types
public type Announcement record {
    int id;
    string link;
    string title;
    string content;
    string date;
};

public type Event record {
    string ^"table";
    string action;
    Data[] data;
};

public type Data record {
    string timestamp;
    string symbol;
    string side;
    float|int size;
    float|int price;
    string tickDirection;
    string trdMatchID;
    float|int grossValue;
    float|int homeNotional;
    float|int foreignNotional;
};