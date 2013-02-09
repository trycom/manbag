//
//  NSDictionary_RMJsonDict.h
//  BonjourBonjour
//
//  Created by Roy Marmelstein on 06/02/2013.
//  Copyright (c) 2013 Roy Marmelstein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(JSONCategories)
-(NSString*)toJSONString;
-(NSData*)toJSON;
@end

@implementation NSDictionary(JSONCategories)

-(NSData*)toJSON
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

-(NSString*)toJSONString
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return [[NSString alloc] initWithData:result
                                 encoding:NSUTF8StringEncoding];;
}


@end