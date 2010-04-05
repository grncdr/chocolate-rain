//
//  torrent_view.m
//  chocolate-rain
//
//  Created by Stephen Sugden on 10-04-03.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "rtView.h"


@implementation rtView

@synthesize daemon;
@synthesize torrents;

-(id) init
{
	self = [super init];

	return self;
}

-(void) prepareContent
{
	NSLog(@"Asked to prepare content in rtView");
	[viewSelector selectItemWithTitle:@"Incomplete"];
	[self viewSelectionDidChange:nil];
}

- (NSArray *)values
{
	return torrents;
}

-(NSArray *)torrentsAtIndexes:(NSIndexSet *)is;
{
	return [torrents objectsAtIndexes:is];
}

@end
