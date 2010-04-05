//
//  rtDaemon.h
//  chocolate-rain
//
//  Created by Stephen Sugden on 10-04-03.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMLRPC/XMLRPCConnectionDelegate.h>


@interface rtDaemon : NSObject {
	XMLRPCConnectionManager *manager;
	NSURL *url;
}

-(void) getProperty:(NSString *)prop_name forTorrent:(rtTorrent *) t;
-(void) requestMethod:(NSString *)method withParameter:(id)parameter andDelegate:(id<XMLRPCConnectionDelegate>)delegate;
-(void) observeValueForKeyPath:(NSString *)path 
					  ofObject:(id)obj
						change:(NSDictionary *)change
					   context:(void *)context;
@end
