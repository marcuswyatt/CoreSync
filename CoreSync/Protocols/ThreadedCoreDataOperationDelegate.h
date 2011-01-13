//
//  ThreadedCoreDataOperationDelegate.h
//  vWork
//
//  Created by Marcus Wyatt on 11/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ThreadedCoreDataOperationDelegate

@optional

- (void)jsonDeserializationFailed:(NSError *)error;


@end
