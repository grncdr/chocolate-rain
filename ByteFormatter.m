//
//  ByteFormatter.m
//  chocolate-rain
//
//  Created by Stephen Sugden on 10-04-04.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ByteFormatter.h"


@implementation ByteFormatter

-(id)init
{
	self = [super init];
	suffixes = [NSArray arrayWithObjects:@"B",@"KB",@"MB",@"GB",@"TB",@"PB",nil];
	return self;
}

-(NSString *)stringForObjectValue:(id)object
{
	if (![object respondsToSelector:@selector(doubleValue)]) {
		return @"Err!";
	}
	
	double val = [object doubleValue];
	int i = 0;
	while (val > 999) {
		val = val / 1024.0;
		i++;
	}
	return [NSString stringWithFormat:@"%.2f%@",val,[suffixes objectAtIndex:i]];
}

-(BOOL)getObjectValue:(id *)obj forString:(NSString *)string errorDescription:(NSError **)error
{
	// This might be worth implementing at some point
	return FALSE;
}

-(NSAttributedString *)attributedStringForObjectValue:(id)obj withDefaultAttributes:(NSDictionary *)attrs
{
	return [[NSAttributedString alloc] initWithString:[self stringForObjectValue:obj] attributes:attrs];
}

@end
