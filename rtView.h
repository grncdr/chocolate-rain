//
//  torrent_view.h
//  chocolate-rain
//
//  Created by Stephen Sugden on 10-04-03.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppController.h"
#import <XMLRPC/XMLRPCConnectionDelegate.h>

@interface rtView : NSObject{

}

@property(readonly) rtDaemon *daemon;


-(void)prepareContent;
-(NSArray *)values;
@end
