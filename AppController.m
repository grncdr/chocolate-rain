//
//  chocolate_rainAppDelegate.m
//  chocolate-rain
//
//  Created by Stephen Sugden on 10-04-03.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"

@implementation AppController

@synthesize window;
@synthesize daemon;
@synthesize torrents;

+ (void)initialize
{
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
	[defaultValues setObject:@"http://localhost/RPC2" forKey:@"url"];
	[defaultValues setObject:@"/" forKey:@"remoteRoot"];
	[defaultValues setObject:[NSNumber numberWithInt:1] forKey:@"browseRemote"];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
	[[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:defaultValues];
}

- (id)init 
{
	self = [super init];
	daemon = [[rtDaemon alloc] init];
	torrents = [[NSMutableArray alloc] init];	
	return self;
}

-(NSUInteger) countOfTorrents
{ 
	return [torrents count];
}

-(rtTorrent *) objectInTorrentsAtIndex:(NSInteger)i;
{
	return [torrents objectAtIndex:i];
}

-(IBAction) showPreferencePanel: (id) sender
{
	if (!preferenceController) {
		preferenceController = [[NSWindowController alloc] initWithWindowNibName:@"Preferences"];
	}
	[preferenceController showWindow:self];
}

-(IBAction) stopSelected: (id) sender
{
	DLog(@"Not implemented");
}

-(IBAction) startSelected: (id) sender
{
	DLog(@"Not Implemented");
}


-(IBAction) viewDidChange: (id) sender
{
	DLog(@"Selected view %@", [viewSelector titleOfSelectedItem]);
	[torrents removeAllObjects];
	[daemon requestMethod:@"download_list" 
				withParameter:[[viewSelector titleOfSelectedItem] lowercaseString] 
				  andDelegate:self];
}

////// XMLRPCConnectionDelegate methods
// Called on ANY response from XMLRPC server
- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response
{
	NSArray *hashList = [response object];
	DLog(@"Received hashlist:\n%@", hashList);
	for(NSString *hash in hashList)
	{
		if (![self haveHash:hash]) {
			[torrentList addObject:[[rtTorrent alloc] initWithSHA1:hash andDaemon:daemon]];
		}
	}
	[self didChangeValueForKey:@"torrents"];
	DLog(@"Set torrents:\n%@", torrents);
}

- (BOOL)haveHash:(NSString *)hash
{
	for(rtTorrent *t in torrents){
		if (t.sum == hash) {
			return TRUE;
		}
	}
	return FALSE;
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
