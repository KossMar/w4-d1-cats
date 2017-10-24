//
//  CatImageObject.m
//  Cats
//
//  Created by Mar Koss on 2017-10-23.
//  Copyright © 2017 Mar Koss. All rights reserved.
//

#import "CatImageObject.h"

@implementation CatImageObject

- (instancetype)initWithImageInfo:(NSDictionary*)info {
    self = [super init];
    if (self) {
        
        _farm = [info valueForKey:@"farm"];
        _server = [info valueForKey:@"server"];
        _catImageId = [info valueForKey:@"id"];
        _secret = [info valueForKey:@"secret"];
        _title = [info valueForKey:@"title"];
        _catImageStr = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", self.farm, self.server, self.catImageId, self.secret];
    }
    return self;
}

@end
