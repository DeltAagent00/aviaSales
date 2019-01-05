//
//  APIManager.h
//  AviaSales
//
//  Created by Alex on 03/01/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

#import "DataManager.h"
#import "MapPrice.h"

NS_ASSUME_NONNULL_BEGIN

#define AirlineLogo(iata) [NSURL URLWithString:[NSString stringWithFormat:@"https://pics.avs.io/200/200/%@.png", iata]];

typedef struct SearchRequest {
    __unsafe_unretained NSString *origin;
    __unsafe_unretained NSString *destionation;
    __unsafe_unretained NSDate *departDate;
    __unsafe_unretained NSDate *returnDate;
} SearchRequest;

@interface APIManager : NSObject

+ (instancetype)sharedInstance;
- (void)cityForCurrentIP:(void(^)(City *city))completion;
- (void)ticketsWithRequest:(SearchRequest)request withCompletion:(void (^)(NSArray *tickets))completion;
- (void)mapPricesFor:(City *)origin withCompletion:(void (^)(NSArray *prices))completion;

@end

NS_ASSUME_NONNULL_END
