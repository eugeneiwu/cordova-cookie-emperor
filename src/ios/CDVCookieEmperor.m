#import "CDVCookieEmperor.h"

@implementation CDVCookieEmperor

 - (void)getCookieValue:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    NSString* urlString = [command.arguments objectAtIndex:0];
    __block NSString* cookieName = [command.arguments objectAtIndex:1];

    if (urlString != nil)
    {
        NSArray* cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:urlString]];
        __block NSString *cookieValue;

        [cookies enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSHTTPCookie *cookie = obj;

            if([cookie.name isEqualToString:cookieName])
            {
                cookieValue = cookie.value;
                *stop = YES;
            }
        }];

        if (cookieValue != nil)
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"cookieValue":cookieValue}];
        }
        else
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No cookie found"];
        }

    }
    else
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"URL was null"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

 - (void)setCookieValue:(CDVInvokedUrlCommand*)command
{
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

    CDVPluginResult* pluginResult = nil;
    // load the options
    NSDictionary* arguments = [command.arguments objectAtIndex:0];
    NSString* cookieName = [arguments objectForKey:@"name"];
    NSString* urlString = [arguments objectForKey:@"domain"];
    NSString* cookieValue = [arguments objectForKey:@"value"];
    NSString* cookiePath = [arguments objectForKey:@"path"];
    NSString* cookieExpire = [arguments objectForKey:@"expire"];
    
    NSURL *cookieURL = [NSURL URLWithString:urlString];
    
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    
    [cookieProperties setObject:cookieName forKey:NSHTTPCookieName];
    [cookieProperties setObject:cookieURL forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:cookieValue forKey:NSHTTPCookieValue];
    [cookieProperties setObject:cookiePath forKey:NSHTTPCookiePath];
    
    if ([cookieExpire length] > 0){
        [cookieProperties setObject:cookieExpire forKey:NSHTTPCookieExpires];
    }
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Set cookie executed"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)clearCookies:(CDVInvokedUrlCommand*)command
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }

    [[NSUserDefaults standardUserDefaults] synchronize];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
