//
//  CatImageObject.h
//  Cats
//
//  Created by Mar Koss on 2017-10-23.
//  Copyright © 2017 Mar Koss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatImageObject : NSObject

@property (nonatomic, strong) NSDictionary *imageInfo;

- (instancetype)initWithImageInfo:(NSDictionary*)info;

@property (strong, nonatomic) NSString *farm;
@property (strong, nonatomic) NSString *server;
@property (strong, nonatomic) NSString *catImageId;
@property (strong, nonatomic) NSString *secret;
@property (strong, nonatomic) NSString *catImageStr;
@property (strong, nonatomic) NSString *title;

@end
