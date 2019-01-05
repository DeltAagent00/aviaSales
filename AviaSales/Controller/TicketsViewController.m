//
//  TicketsViewControllerTableViewController.m
//  AviaSales
//
//  Created by Alex on 03/01/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

#import "TicketsViewController.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"

@interface TicketsViewController ()

@property (nonatomic, strong) NSArray *tickets;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITextField *dateTextField;

@end

@implementation TicketsViewController {
    BOOL isFavorites;
    TicketViewCell *notificationCell;
}

-(instancetype)initFavoriteTicketsController {
    self = [super init];
    if (self) {
        isFavorites = YES;
        self.tickets = [NSArray new];
        self.title = [@"favorites_tab" localize];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
    }
    return self;
}

- (instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (self)
    {
        _tickets = tickets;
        self.title = [@"tickets_title" localize];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
        
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        _datePicker.minimumDate = [NSDate date];
        
        _dateTextField = [[UITextField alloc] initWithFrame:self.view.bounds];
        _dateTextField.hidden = YES;
        _dateTextField.inputView = _datePicker;
        
        UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
        [keyboardToolbar sizeToFit];
        UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonDidTap:)];
        keyboardToolbar.items = @[flexBarButton, doneBarButton];
        
        _dateTextField.inputAccessoryView = keyboardToolbar;
        [self.view addSubview:_dateTextField];
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (isFavorites) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        _tickets = [[CoreDataHelper sharedInstance] favorites];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tickets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketCellReuseIdentifier forIndexPath:indexPath];
    if (isFavorites) {
        cell.favoriteTicket = [_tickets objectAtIndex:indexPath.row];
    } else {
        cell.ticket = [_tickets objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isFavorites) {
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[@"actions_with_tickets" localize] message:[@"actions_with_tickets_describe" localize] preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favoriteAction;
    Ticket *ticket = [_tickets objectAtIndex:indexPath.row];
    
    if ([[CoreDataHelper sharedInstance] isFavorite:ticket]) {
        favoriteAction = [UIAlertAction actionWithTitle:[@"remove_from_favorite" localize] style:UIAlertActionStyleDestructive handler:^(UIAlertAction *_Nonnull action) {
                [[CoreDataHelper sharedInstance] removeFromFavorite:ticket];
        }];
    } else {
        favoriteAction = [UIAlertAction actionWithTitle:[@"add_to_favorite" localize] style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            [[CoreDataHelper sharedInstance] addToFavorite:ticket];
        }];
    }
    UIAlertAction *notificationAction = [UIAlertAction actionWithTitle:[@"remind_me" localize] style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        self->notificationCell = [tableView cellForRowAtIndexPath:indexPath];
        [self->_dateTextField becomeFirstResponder];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[@"close" localize] style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:favoriteAction];
    [alertController addAction:notificationAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)doneButtonDidTap:(UIBarButtonItem *)sender
{
    if (_datePicker.date && notificationCell) {
        NSString *message = [NSString stringWithFormat:@"%@ - %@ %@ %@ %@", notificationCell.ticket.from, notificationCell.ticket.to, [@"by" localize], notificationCell.ticket.price, [@"rub" localize]];
        
        NSURL *imageURL;
        
        if (notificationCell.airlineLogoView.image) {
            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/%@.png", notificationCell.ticket.airline]];
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                UIImage *logo = notificationCell.airlineLogoView.image;
                NSData *pngData = UIImagePNGRepresentation(logo);
                [pngData writeToFile:path atomically:YES];
                
            }
            imageURL = [NSURL fileURLWithPath:path];
        }
        
        Notification notification = NotificationMake([@"ticket_reminder" localize], message, _datePicker.date, imageURL);
        [[NotificationCenter sharedInstance] sendNotification:notification];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[@"success" localize] message:[NSString stringWithFormat:@"%@ - %@", [@"notification_will_be_sent" localize], _datePicker.date] preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[@"close" localize] style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    _datePicker.date = [NSDate date];
    notificationCell = nil;
    [self.view endEditing:YES];
}


@end
