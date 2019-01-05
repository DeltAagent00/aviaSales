//
//  TicketTableViewCell.h
//  AviaSales
//
//  Created by Alex on 03/01/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

#import "APIManager.h"
#import "CoreDataHelper.h"
#import "NSString+Localize.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *airlineLogoView;
@property (nonatomic, strong) Ticket *ticket;
@property (nonatomic, strong) FavoriteTicket *favoriteTicket;

@end

NS_ASSUME_NONNULL_END
