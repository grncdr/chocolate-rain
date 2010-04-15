//
//  rtDaemon.m
//  chocolate-rain
//
//  Created by Stephen Sugden on 10-04-03.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "rtDaemon.h"


@implementation rtDaemon

-(id) init 
{
	self = [super init];
	id defaults = [NSUserDefaultsController sharedUserDefaultsController];
	[defaults addObserver:self forKeyPath:@"values.url" options:0 context:nil];
	manager = [XMLRPCConnectionManager sharedManager];
	return self;
}
		   
-(void) observeValueForKeyPath:(NSString *)path 
					  ofObject:(id)obj
						change:(NSDictionary *)change
					   context:(void *)context
{
	url = [NSURL URLWithString:
		   [[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"url"]];
}

-(void) requestMethod:(NSString *)method
		withParameter:(id) parameter
		  andDelegate:(id<XMLRPCConnectionDelegate>)delegate
{
	XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL:url];
	[request setMethod:method withParameter:parameter];
	[manager spawnConnectionWithXMLRPCRequest:request delegate:delegate];
	[request release];
}

-(void) getProperty:(NSString *)property
		 forTorrent:(rtTorrent *)torrent
{
	[self requestMethod:[NSString stringWithFormat:@"d.get_%@", property]
		  withParameter:torrent.sum
			andDelegate:torrent];
}

@end
