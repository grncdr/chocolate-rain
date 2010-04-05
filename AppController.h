//
//  chocolate_rainAppDelegate.h
//  chocolate-rain
//
//  Created by Stephen Sugden on 10-04-03.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppController : NSObject <XMLRPCConnectionDelegate> {
    NSWindow *window;
	rtDaemon *daemon;
	// List of torrents currently being displayed
	NSMutableArray *torrents;
	IBOutlet NSArrayController *torrentList;
	IBOutlet NSPopUpButton *viewSelector;
	NSWindowController *preferenceController;
}

-(IBAction) showPreferencePanel:(id) sender;
-(IBAction) stopSelected: (id) sender;
-(IBAction) startSelected: (id) sender;
-(IBAction) viewDidChange:(id) sender;
//-(IBAction) loadTorrent:(id) sender;

-(rtTorrent *) objectInTorrentsAtIndex: (NSInteger)i;
-(NSUInteger) countOfTorrents;

-(BOOL) haveHash:(NSString *)hash;

// @XMLRPCConnectionDelegate protocol
- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response;
- (void)request: (XMLRPCRequest *)request didFailWithError: (NSError *)error;
- (void)request: (XMLRPCRequest *)request didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge;
- (void)request: (XMLRPCRequest *)request didCancelAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge;


@property (assign) IBOutlet NSWindow *window;
@property (readonly) rtDaemon *daemon;
@property (readonly) NSArray *torrents;


@end
