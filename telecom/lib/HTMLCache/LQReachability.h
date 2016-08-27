

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

//typedef enum
//{
//  NotReachable = 0,
//  ReachableViaWiFi,
//  ReachableViaWWAN
//} LQNetworkStatus;
#define kReachabilityChangedNotification @"kNetworkReachabilityChangedNotification"

@interface LQReachability : NSObject
{
  BOOL localWiFiRef;
  SCNetworkReachabilityRef reachabilityRef;
}

//reachabilityWithHostName- Use to check the reachability of a particular host name. 
+ (LQReachability *)reachabilityWithHostName:(NSString *)hostName;

//reachabilityWithAddress- Use to check the reachability of a particular IP address. 
+ (LQReachability *)reachabilityWithAddress:(const struct sockaddr_in *)hostAddress;

//reachabilityForInternetConnection- checks whether the default route is available.  
//  Should be used by applications that do not connect to a particular host
+ (LQReachability *)reachabilityForInternetConnection;

//reachabilityForLocalWiFi- checks whether a local wifi connection is available.
+ (LQReachability *)reachabilityForLocalWiFi;

//Start listening for reachability notifications on the current run loop
- (BOOL)startNotifier;
- (void)stopNotifier;

- (NetworkStatus)currentReachabilityStatus;
//WWAN may be available, but not active until a connection has been established.
//WiFi may require a connection for VPN on Demand.
- (BOOL)connectionRequired;
@end


