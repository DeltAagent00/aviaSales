//
//  FavoriteTicket+CoreDataProperties.h
//  
//
//  Created by Alex on 03/01/2019.
//
//

#import "FavoriteTicket+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface FavoriteTicket (CoreDataProperties)

+ (NSFetchRequest<FavoriteTicket *> *)fetchRequest;

@property (nonatomic) int16_t flightNumber;
@property (nonatomic) int64_t price;
@property (nullable, nonatomic, copy) NSString *to;
@property (nullable, nonatomic, copy) NSString *from;
@property (nullable, nonatomic, copy) NSString *airline;
@property (nullable, nonatomic, copy) NSDate *returnDate;
@property (nullable, nonatomic, copy) NSDate *expires;
@property (nullable, nonatomic, copy) NSDate *departure;
@property (nullable, nonatomic, copy) NSDate *created;

@end

NS_ASSUME_NONNULL_END
