//
//  torrent.h
//  chocolate-rain
//
//  Created by Stephen Sugden on 10-04-03.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

NSMutableDictionary *defaultProperties;

@interface rtTorrent : NSObject <XMLRPCConnectionDelegate> {
	NSString *sum;
	rtDaemon *daemon;
	NSMutableDictionary *properties;
	NSString *detailedStatusLine;
	int state_known;
}

@property(readonly) NSString *sum;
@property int state_known;
@property(readonly) double percentDone;

- (id) initWithSHA1:(NSString *)hash andDaemon:(rtDaemon *)d;
- (void) refreshProperty:(NSString *)prop_name;
- (id) valueForUndefinedKey:(NSString *)key;

// @XMLRPCConnectionDelegate protocol
- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response;
- (void)request: (XMLRPCRequest *)request didFailWithError: (NSError *)error;
- (void)request: (XMLRPCRequest *)request didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge;
- (void)request: (XMLRPCRequest *)request didCancelAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge;


@end
