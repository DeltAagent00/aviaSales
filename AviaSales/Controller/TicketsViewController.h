//
//  TicketsViewControllerTableViewController.h
//  AviaSales
//
//  Created by Alex on 03/01/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

#import "TicketViewCell.h"
#import "NotificationCenter.h"
#import "NSString+Localize.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketsViewController : UITableViewController

- (instancetype)initWithTickets:(NSArray *)tickets;
- (instancetype)initFavoriteTicketsController;

@end

NS_ASSUME_NONNULL_END
