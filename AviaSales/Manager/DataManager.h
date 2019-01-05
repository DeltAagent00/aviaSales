//
//  DataManager.h
//  AviaSales
//
//  Created by Alex on 30/11/2018.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "Country.h"
#import "City.h"
#import "Airport.h"
#import "Ticket.h"

#define kDataManagerLoadDataDidComplete @"DataManagerLoadDataDidComplete"

typedef enum DataSourceType {
    DataSourceTypeCountry,
    DataSourceTypeCity,
    DataSourceTypeAirport
} DataSourceType;

@interface DataManager : NSObject

+ (instancetype)sharedInstance;
- (void)loadData;
- (City *) cityForIATA:(NSString *)iata;
- (City *)cityForLocation:(CLLocation *)location;

@property (nonatomic, strong, readonly) NSArray *countries;
@property (nonatomic, strong, readonly) NSArray *cities;
@property (nonatomic, strong, readonly) NSArray *airports;

@end
