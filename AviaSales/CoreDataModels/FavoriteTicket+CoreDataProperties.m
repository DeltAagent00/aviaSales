//
//  FavoriteTicket+CoreDataProperties.m
//  
//
//  Created by Alex on 03/01/2019.
//
//

#import "FavoriteTicket+CoreDataProperties.h"

@implementation FavoriteTicket (CoreDataProperties)

+ (NSFetchRequest<FavoriteTicket *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
}

@dynamic flightNumber;
@dynamic price;
@dynamic to;
@dynamic from;
@dynamic airline;
@dynamic returnDate;
@dynamic expires;
@dynamic departure;
@dynamic created;

@end
