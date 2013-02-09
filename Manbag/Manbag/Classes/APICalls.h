//
//  APICalls.h
//  Manbag
//
//  Created by Roy Marmelstein on 09/02/2013.
//  Copyright (c) 2013 Seedhack. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface APICalls : MKNetworkEngine

-(void)getFoursquare:(NSString *)searchTerm;

@end
