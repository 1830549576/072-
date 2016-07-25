#ifndef APIConnection_h
#define APIConnection_h

#import <Foundation/Foundation.h>

#define JSONObject NSMutableDictionary
#define JSONArray NSMutableArray

@interface JSONObject (SafeJSONAccess)

- (id)opt:              (NSString *)key;
- (NSString *)optString:(NSString *)key;
- (int)optInt:			(NSString *)key;
- (long)optLong:		(NSString *)key;
- (float)optFloat:		(NSString *)key;
- (double)optDouble:	(NSString *)key;
- (BOOL)optBOOL:		(NSString *)key;

- (JSONObject *)optJSONObject:	(NSString *)key;
- (JSONArray *)optJSONArray:	(NSString *)key;

- (id)opt:              (NSString *)key		defaultValue:(id)defaultValue;
- (NSString *)optString:(NSString *)key		defaultValue:(NSString *)defaultValue;
- (int)optInt:			(NSString *)key		defaultValue:(int)defaultValue;
- (long)optLong:		(NSString *)key		defaultValue:(long)defaultValue;
- (float)optFloat:		(NSString *)key		defaultValue:(float)defaultValue;
- (double)optDouble:	(NSString *)key		defaultValue:(double)defaultValue;
- (BOOL)optBOOL:		(NSString *)key		defaultValue:(BOOL)defaultValue;

@end

@interface JSONArray (SafeJSONAccess)

- (id)opt:              (int)index;
- (NSString *)optString:(int)index;
- (int)optInt:			(int)index;
- (long)optLong:		(int)index;
- (float)optFloat:		(int)index;
- (double)optDouble:	(int)index;
- (BOOL)optBOOL:		(int)index;

- (JSONObject *)optJSONObject:	(int)index;
- (JSONArray *)optJSONArray:	(int)index;

- (id)opt:              (int)index		defaultValue:(id)defaultValue;
- (NSString *)optString:(int)index		defaultValue:(NSString *)defaultValue;
- (int)optInt:			(int)index		defaultValue:(int)defaultValue;
- (long)optLong:		(int)index		defaultValue:(long)defaultValue;
- (float)optFloat:		(int)index		defaultValue:(float)defaultValue;
- (double)optDouble:	(int)index		defaultValue:(double)defaultValue;
- (BOOL)optBOOL:		(int)index		defaultValue:(BOOL)defaultValue;

@end

typedef enum {

	LOGIN_SCREEN_SHOWN      = 1,
	CONNECTING_1            = 2,
	SERVERINFO_REQ          = 3,
	LOGIN_SCREEN_ENABLED    = 4,
	CONNECTING_2            = 5,
	INITIAL_LOGIN           = 6,
	IN_SESSION              = 7,
	CONNECTING_3            = 8,
	SESSION_LOGIN           = 9,
	CONNECTING_4            = 10,
	REGISTRATION            = 11,
	CONNECTING_5            = 12,
    
} ConnStates;

@interface APIConnection : NSObject;

    // public accessible variable, this class is implemented as a singleton

    @property NSString* wsURL;

    @property ConnStates state;
    @property ConnStates from_state;

    // if this present, it will go ahead and do the registration
    @property JSONObject* registration;

    @property JSONObject* server_info;
    @property JSONObject* user_info;
    @property JSONObject* user_data;

    // client info set by client app
    @property JSONObject* client_info;

    // string key/value settings, "true" and "false" and number is rpresented as string as well
    @property JSONObject* user_pref;

    // response json structure received from server and saved here, and processed immediately by observer

    // A notification center delivers notifications to observers synchronously. In other words,
    // the postNotification: methods do not return until all observers have received and
    // processed the notification. To send notifications asynchronously use NSNotificationQueue.
    @property JSONObject* response;

    @property JSONObject* last_req;

    // treat this request as priority
    @property JSONObject* this_req;

    - (void)connect;
    - (void)credential:(NSString*)name withPasswd:(NSString*)passwd;
    - (void)credentialx:(JSONObject*)cred;
    - (BOOL)send:(JSONObject*)req;
    - (BOOL)send_str:(NSString*)req;
    - (NSString*)version;
    - (BOOL)is_logged_in;
    - (void)log_add:(NSString*)logstr;

    // notifcation will fire on these names
    @property (readonly) NSString* stateChangedNotification;
    @property (readonly) NSString* responseReceivedNotification;

    // called when sdk does a logsend, send extra info here
    @property (nonatomic, copy) NSString* (^log_extra) (void);
    
    // utilities
    - (BOOL)isScreenOff;
    - (void)playRingTone:(BOOL)p;
    - (int)ios_app_version;
    - (int)getUnixTime;

@end

#endif
