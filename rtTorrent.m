//
//  torrent.m
//  chocolate-rain
//
//  Created by Stephen Sugden on 10-04-03.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "rtTorrent.h"



@implementation rtTorrent

+ (void) initialize
{
	NSMutableDictionary *stringProperty = [[NSMutableDictionary alloc] init];
	[stringProperty setObject:@"" forKey:@"value"];
	[stringProperty setObject:[NSDate date] forKey:@"updateNext"];
	NSMutableDictionary *numericProperty = [[NSMutableDictionary alloc] init];
	[numericProperty setObject:[NSNumber numberWithInt:0] forKey:@"value"];
	[numericProperty setObject:[NSDate date] forKey:@"updateNext"];
	defaultProperties = [[NSMutableDictionary alloc] init];
	[defaultProperties setObject:[numericProperty copy] forKey:@"size_bytes"];
	[defaultProperties setObject:[numericProperty copy] forKey:@"bytes_done"];
	[defaultProperties setObject:[numericProperty copy] forKey:@"down_rate"];
	[defaultProperties setObject:[numericProperty copy] forKey:@"up_rate"];
	[defaultProperties setObject:[numericProperty copy] forKey:@"ratio"];
	[defaultProperties setObject:[numericProperty copy] forKey:@"peers_complete"];
	[defaultProperties setObject:[numericProperty copy] forKey:@"peers_connected"];
	[defaultProperties setObject:[numericProperty copy] forKey:@"state"];
	[defaultProperties setObject:[stringProperty copy] forKey:@"name"];
	[defaultProperties setObject:[stringProperty copy] forKey:@"directory"];
	[numericProperty release];
	[stringProperty release];
}

@synthesize sum;
@synthesize state_known;

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
	state_known = 0;
	properties = [[NSMutableDictionary alloc] init];
	for(NSString *name in [defaultProperties keyEnumerator]){
		[properties setObject:[[NSMutableDictionary alloc] initWithDictionary:[defaultProperties objectForKey:name] copyItems:YES] 
					   forKey: name];
	}
	return self;
}

- (void) refreshProperty:(NSString *) prop_name
{
	[daemon getProperty:prop_name forTorrent:self];
}

- (double) percentDone
{
	double bytes_done = [[self valueForKey:@"bytes_done"] doubleValue];
	double size_bytes = [[self valueForKey:@"size_bytes"] doubleValue];
	return bytes_done / size_bytes;
}

-(id) valueForUndefinedKey:(NSString *)key
{
	// Check if key exists in properties dictionary
	NSMutableDictionary *property = [properties objectForKey:key];
	//Check if value is stale, there should be a lot more heuristics involved in the below block
	if([[NSDate date] compare:[property objectForKey:@"updateNext"]] == NSOrderedDescending) {
		if ([key compare:@"name"] == NSOrderedSame || [key compare:@"size_bytes"] == NSOrderedSame) {
			[property setObject:[NSDate distantFuture] forKey:@"updateNext"];	
		} else {
			[property setObject:[NSDate dateWithTimeIntervalSinceNow:10] forKey:@"updateNext"];
		}
		[self refreshProperty:key];
	}
	//Return value
	return [property objectForKey:@"value"];
}

- (NSString *)description
{
	NSString *sumString = [NSString stringWithFormat:@"%@...",[sum substringToIndex:6]];
	NSString *name = [self valueForKey:@"name"];
	return [NSString stringWithFormat:@"%@ %@",sumString,name];
}

// Called on ANY response from XMLRPC server
- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response
{
	DLog(@"Received response to request %@", [request method]);
	if ([[[request method] substringToIndex:5] compare: @"d.get_"]) {
		NSString *prop_name = [[request method] substringFromIndex:6];
		NSObject *value;
		if ([prop_name compare:@"state"]){
			state_known = 1;
		}
		value = [response object];
		NSLog(@"Setting %@ to %@ for %@",prop_name,value,self);
		NSMutableDictionary *property = [properties objectForKey:prop_name];
		[self willChangeValueForKey:prop_name];
		[property setObject:value forKey:@"value"];
		[self didChangeValueForKey:prop_name];
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
