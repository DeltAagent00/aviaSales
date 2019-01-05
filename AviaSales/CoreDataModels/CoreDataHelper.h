//
//  CoreDataHelper.h
//  AviaSales
//
//  Created by Alex on 03/01/2019.
//  Copyright © 2019 Alex. All rights reserved.
//
#import <CoreData/CoreData.h>
#import "DataManager.h"
#import "FavoriteTicket+CoreDataProperties.h"
#import "FavoriteTicket+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataHelper : NSObject

+(instancetype)sharedInstance;

-(BOOL)isFavorite:(Ticket *)ticket;
-(NSArray *)favorites;
-(void)addToFavorite:(Ticket *)ticket;
-(void)removeFromFavorite:(Ticket *)ticket;

@end

NS_ASSUME_NONNULL_END
