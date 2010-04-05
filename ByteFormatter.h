//
//  ByteFormatter.h
//  chocolate-rain
//
//  Created by Stephen Sugden on 10-04-04.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ByteFormatter : NSFormatter {
	NSArray *suffixes;
}
-(NSString *)stringForObjectValue:(id)object;
-(BOOL)getObjectValue:(id *)obj forString:(NSString *)string errorDescription:(NSError **)error;
-(NSAttributedString *)attributedStringForObjectValue:(id)obj withDefaultAttributes:(NSDictionary *)attrs;

@end
