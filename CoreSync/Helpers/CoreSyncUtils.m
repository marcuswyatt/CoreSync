//
//  CoreSyncUtils.m
//  vWork
//
//  Created by Marcus Wyatt on 9/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import "CoreSyncUtils.h"


@implementation CoreSyncUtils

#pragma mark -
#pragma mark Helpers

+ (NSURL *)URLWithSite:(NSString *)site andFormat:(NSString *)format andParameters:(id)parameters {

    // Build query parameter string from supplied parameters
    NSMutableString *str = [NSMutableString stringWithString:site];

    // Add in format if exist
    if (format != nil) {
        [str appendString:@"."];
        [str appendString:format];
    }

    if (parameters != nil) {
        [str appendString:@"?"];

        // If parameters are just a string, add in directly
        if ([parameters isKindOfClass:[NSString class]])
            [str appendString:parameters];

        // If parameters are a dictionary, iterate and add each pair
        else if ([parameters isKindOfClass:[NSDictionary class]]) {
            BOOL first = YES;
            for (NSString *key in [(NSDictionary*)parameters allKeys]) {
                if (first) first = NO;
                else [str appendString:@"&"];
                [str appendString:[NSString stringWithFormat:@"%@=%@", key, [(NSDictionary*)parameters objectForKey:key]]];
            }
        }
    }

    return [NSURL URLWithString:str];
}

@end
