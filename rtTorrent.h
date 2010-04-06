//
//  torrent.h
//  chocolate-rain
//
//  Created by Stephen Sugden on 10-04-03.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface rtTorrent : NSObject <XMLRPCConnectionDelegate> {
	NSString *sum;
	rtDaemon *daemon;
	NSString *name;
	int down_rate;
	int up_rate;
	int size_bytes;
	int bytes_done;
	int ratio;
	int started;
}

@property(readonly) NSString *sum;
@property(readonly) NSString *name;
@property(readonly) int down_rate;
@property(readonly) int up_rate;
@property(readonly) int size_bytes;
@property(readonly) int bytes_done;
@property(readonly) int ratio;
@property(readonly) int started;
@property(readonly) double percentDone;


- (id) initWithSHA1:(NSString *)hash andDaemon:(rtDaemon *)d;
- (void) refreshProperty:(NSString *)prop_name;
- (void) refreshAll;

// @XMLRPCConnectionDelegate protocol
- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response;
- (void)request: (XMLRPCRequest *)request didFailWithError: (NSError *)error;
- (void)request: (XMLRPCRequest *)request didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge;
- (void)request: (XMLRPCRequest *)request didCancelAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge;


@end
