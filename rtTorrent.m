//
//  torrent.m
//  chocolate-rain
//
//  Created by Stephen Sugden on 10-04-03.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "rtTorrent.h"


@implementation rtTorrent
@synthesize sum;
@synthesize name;
@synthesize down_rate;
@synthesize up_rate;
@synthesize size_bytes;
@synthesize bytes_done;
@synthesize ratio;

- (id) init
{
	[self dealloc];
	@throw [NSException exceptionWithName:@"BNRBadInitCall" 
								   reason:@"Torrent must be initialized with a SHA1 checksum and Daemon!" 
								 userInfo:nil];	
	return nil;
}

- (id) initWithSHA1:(NSString *)sha1sum
		  andDaemon:(rtDaemon *)d
{
	[super init];
	NSAssert( sha1sum != nil, @"sha1sum must be non-nil" );
	sum = sha1sum;
	daemon = d;
	name = @"";
	size_bytes = 0;
	bytes_done = 0;
	ratio = 0;
	up_rate = 0;
	down_rate = 0;
	[self refreshAll];
	return self;
}

- (void) refreshAll
{
	[daemon getProperty:@"name" forTorrent:self];
	[daemon getProperty:@"size_bytes" forTorrent:self];
	[daemon getProperty:@"bytes_done" forTorrent:self];
	[daemon getProperty:@"ratio" forTorrent:self];
	[daemon getProperty:@"up_rate" forTorrent:self];
	[daemon getProperty:@"down_rate" forTorrent:self];
}

- (void) refreshProperty:(NSString *) prop_name
{
	[daemon getProperty:prop_name forTorrent:self];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@...",[sum substringToIndex:6]],name];
}

// Called on ANY response from XMLRPC server
- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response
{
	DLog(@"Received response to request %@", [request method]);
	if ([[[request method] substringToIndex:5] compare: @"d.get_"]) {
		NSString *prop_name = [[request method] substringFromIndex:6];
		NSObject *value;
		if (![prop_name compare:@"name"]){
			value = [response object];
		} else {
			value = [NSNumber numberWithInt:[[response object] intValue]];
		}

		DLog(@"Setting %@ to %@ for %@",prop_name,value,self);
		[self setValue:value forKey:prop_name];
	}
	/*
	 else if ([request method] == @"d.start") {
	 [self hasStarted];
	 }
	 else if ([request method] == @"d.stop") {
	 [self hasStopped];
	 }
	 */
}

- (void)request: (XMLRPCRequest *)request didFailWithError: (NSError *)error
{
	DLog(@"Request %A failed with error: %A", request, error);
}

- (void)request: (XMLRPCRequest *)request didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge
{
	DLog(@"Challenge response not implemented");
}

- (void)request: (XMLRPCRequest *)request didCancelAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge
{
	DLog(@"Challenge response not implemented");
}
@end