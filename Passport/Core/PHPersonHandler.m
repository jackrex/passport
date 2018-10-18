//
//  PHPersonHandler.m
//  Passport
//
//  Created by jackrex on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

#import "PHPersonHandler.h"
#import "PHPerson.h"

static PHPersonHandler *_handler = nil;

@implementation PHPersonHandler

+(PHPersonHandler *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *b = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/Photos.framework"];
        if (![b load]) {
            NSLog(@"Error"); // maybe throw an exception
        } else {
            id data = [NSClassFromString(@"PHPerson") valueForKey:@"identifierCode"];
            NSLog(data);
            _handler = [[PHPersonHandler alloc] init];
        }
    });
    return _handler;
}

@end
