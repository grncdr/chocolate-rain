//
//  SpeedFormatter.m
//  chocolate-rain
//
//  Created by Stephen Sugden on 10-04-04.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SpeedFormatter.h"

@implementation SpeedFormatter
-(NSString *)stringForObjectValue:(id)object
{
	return [NSString stringWithFormat:@"%@/s",[super stringForObjectValue:object]];
}
@end
