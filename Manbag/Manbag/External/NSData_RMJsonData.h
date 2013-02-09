//
//  NSData_RMJsonData.h
//  BonjourBonjour
//
//  Created by Roy Marmelstein on 06/02/2013.
//  Copyright (c) 2013 Roy Marmelstein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(JSONCategories)
-(id)toObject;
@end

@implementation NSData(JSONCategories)

-(id)toObject
{
    NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:self
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

@end
