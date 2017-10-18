#include "AppDelegate.h"
#import <Flutter/Flutter.h>
#include "GeneratedPluginRegistrant.h"

@import UserNotifications;
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
  FlutterMethodChannel* channel = [FlutterMethodChannel
                                          methodChannelWithName:@"samples.flutter.io/userNotifications"
                                          binaryMessenger:controller];

  [channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
    if ([@"requestAuthorization" isEqualToString:call.method]) {
      [self registerAuthorization];
      result(nil);
    } else if ([@"scheduleNotification" isEqualToString:call.method]) {
      NSDateComponents* date = [[NSDateComponents alloc] init];
      date.hour = ((NSNumber*)call.arguments[@"hour"]).intValue;
      date.minute = ((NSNumber*)call.arguments[@"minute"]).intValue;
        
      [self scheduleNotification:date];
      result(nil);
    } else {
      result(FlutterMethodNotImplemented);
    }
  }];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)registerAuthorization {
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (!error) {
                                  NSLog(@"request authorization succeeded!");
                              }
                          }];
}

- (void)scheduleNotification:(NSDateComponents *)dateComponent {
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:@"Hello!" arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:@"Hello_message_body"
                                                         arguments:nil];
    content.sound = [UNNotificationSound defaultSound];

    UNCalendarNotificationTrigger* trigger = [UNCalendarNotificationTrigger
                                              triggerWithDateMatchingComponents:dateComponent repeats:YES];

    UNNotificationRequest* request = [UNNotificationRequest
                                      requestWithIdentifier:@"MorningAlarm" content:content trigger:trigger];

    // Schedule the notification.
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}
@end
