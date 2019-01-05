//
//  ViewController.m
//  AviaSales
//
//  Created by Alex on 30/11/2018.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "MainViewController.h"


@interface MainViewController ()<PlaceViewControllerDelegate>

@property (nonatomic, strong) UIView *placeContainerView;
@property (nonatomic, strong) UIButton *departureButton;
@property (nonatomic, strong) UIButton *arrivalButton;
@property (nonatomic) SearchRequest searchRequest;
@property (nonatomic, strong) UIButton *searchButton;

@end

@implementation MainViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self presentFirstViewControllerIfNeeded];
}

- (void)presentFirstViewControllerIfNeeded {
    BOOL isFirstStart = [[NSUserDefaults standardUserDefaults] boolForKey:@"first_start"];
    if (!isFirstStart) {
        FirstViewController *firstViewController = [[FirstViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        [self presentViewController:firstViewController animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[DataManager sharedInstance] loadData];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.title = [@"search_tab" localize];
    
    _placeContainerView = [[UIView alloc] initWithFrame:CGRectMake(20.0, 160.0, [UIScreen mainScreen].bounds.size.width - 40.0, 170.0)];
    _placeContainerView.backgroundColor = [UIColor whiteColor];
    _placeContainerView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
    _placeContainerView.layer.shadowOffset = CGSizeZero;
    _placeContainerView.layer.shadowRadius = 20.0;
    _placeContainerView.layer.shadowOpacity = 1.0;
    _placeContainerView.layer.cornerRadius = 6.0;
    
    _departureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_departureButton setTitle:[@"main_from" localize] forState: UIControlStateNormal];
    _departureButton.tintColor = [UIColor blackColor];
    _departureButton.frame = CGRectMake(10.0, 20.0, _placeContainerView.frame.size.width - 20.0, 60.0);
    _departureButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    _departureButton.layer.cornerRadius = 4.0;
    [_departureButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.placeContainerView addSubview:_departureButton];
    
    _arrivalButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_arrivalButton setTitle:[@"main_to" localize] forState: UIControlStateNormal];
    _arrivalButton.tintColor = [UIColor blackColor];
    _arrivalButton.frame = CGRectMake(10.0, CGRectGetMaxY(_departureButton.frame) + 10.0, _placeContainerView.frame.size.width - 20.0, 60.0);
    _arrivalButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
     _arrivalButton.layer.cornerRadius = 4.0;
    [_arrivalButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.placeContainerView addSubview:_arrivalButton];
    
    [self.view addSubview: _placeContainerView];
    
    _searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_searchButton setTitle:[@"main_search" localize] forState:UIControlStateNormal];
    _searchButton.tintColor = [UIColor whiteColor];
    _searchButton.frame = CGRectMake(30.0, CGRectGetMaxY(_placeContainerView.frame) + 30, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0);
    _searchButton.backgroundColor = [UIColor blackColor];
    _searchButton.layer.cornerRadius = 8.0;
    _searchButton.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    [self.view addSubview:_searchButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadedSuccessfully) name:kDataManagerLoadDataDidComplete object:nil];
    
    [_searchButton addTarget:self action:@selector(searchButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)searchButtonDidTap:(UIButton *)sender {
    if (_searchRequest.origin && _searchRequest.destionation) {
        [[ProgressView sharedInstance] show:^{
            [[APIManager sharedInstance] ticketsWithRequest:self->_searchRequest withCompletion:^(NSArray *tickets) {
                [[ProgressView sharedInstance] dismiss:^{
                    if (tickets.count > 0) {
                        TicketsViewController *ticketsViewController = [[TicketsViewController alloc] initWithTickets:tickets];
                        [self.navigationController showViewController:ticketsViewController sender:self];
                    } else {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[@"error" localize] message:[@"tickets_not_found" localize] preferredStyle: UIAlertControllerStyleAlert];
                        [alertController addAction:[UIAlertAction actionWithTitle:[@"close" localize] style:(UIAlertActionStyleDefault) handler:nil]];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                }];
            }];
        }];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[@"error" localize] message:[@"not_set_place_arrival_or_departure" localize] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:[@"close" localize] style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


//- (void)loadDataComplete {
////    self.view.backgroundColor = [UIColor yellowColor];
//    [self.tableView reloadData];
//}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete object:nil];
}

- (void)dataLoadedSuccessfully {
    [[APIManager sharedInstance] cityForCurrentIP:^(City *city) {
        [self setPlace:city withDataType:DataSourceTypeCity andPlaceType:PlaceTypeDeparture forButton:self->_departureButton];
    }];
}


//- (void)createLabel {
//    CGRect labelFrame = CGRectMake(40.0, 40.0, [UIScreen mainScreen].bounds.size.width - 80.0, [UIScreen mainScreen].bounds.size.height - 80.0);
//    UILabel *label = [[UILabel alloc] initWithFrame: labelFrame];
//    label.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightBold];
//    label.textColor = [UIColor darkGrayColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = @"Hello, World!";
//    [self.view addSubview: label];
//}
//
//- (void)createButton {
//    CGRect frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100.0, [UIScreen mainScreen].bounds.size.height/2 - 25.0, 200.0, 50.0);
//    UIButton *button = [UIButton buttonWithType: UIButtonTypeSystem];
//    [button setTitle:@"ИЗМЕНИТЬ ЦВЕТ" forState:UIControlStateNormal];
//    button.backgroundColor = [UIColor blueColor];
//    button.tintColor = [UIColor whiteColor];
//    button.frame = frame;
//    [button addTarget:self action:@selector(changeColorButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//}
//
//- (void)createTextField {
//    CGRect frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100.0, [UIScreen mainScreen].bounds.size.height/2 - 25.0, 200.0, 50.0);
//    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
//    textField.borderStyle = UITextBorderStyleRoundedRect;
//    textField.placeholder = @"Введите значение...";
//    textField.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightLight];
//    [self.view addSubview: textField];
//}
//
//- (void)createSegmentedControl {
//    CGRect frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100.0, [UIScreen mainScreen].bounds.size.height/2 - 25.0, 200.0, 50.0);
//    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Первый", @"Второй"]];
//    segmentedControl.frame = frame;
//    segmentedControl.tintColor = [UIColor blackColor];
//    segmentedControl.selectedSegmentIndex = 0;
//    [self.view addSubview:segmentedControl];
//}

// Метод, который будет вызван при нажатии на кнопку
//- (void)changeColorButtonDidTap:(UIButton *)sender
//{
//    if ([self.view.backgroundColor isEqual: [UIColor whiteColor]]) {
//        self.view.backgroundColor = [UIColor redColor];
//    } else {
//        self.view.backgroundColor = [UIColor whiteColor];
//    }
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [DataManager.sharedInstance.countries count];
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
//    if (!cell) {
//        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
//    }
//    Country *country = DataManager.sharedInstance.countries[indexPath.row];
//    cell.leftLabel.text = country.name;
//    cell.rightLabel.text = country.code;
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
////    [DataManager.sharedInstance.countries removeObjectAtIndex:indexPath.row]; хз почему он не видит интерфейс для удаления элемента
////    [tableView deleteRowsAtIndexPaths:@[indNo visibleexPath] withRowAnimation:UITableViewRowAnimationFade];
//}

- (void)placeButtonDidTap:(UIButton *)sender {
    PlaceViewController *placeViewController;
    if ([sender isEqual:_departureButton]) {
        placeViewController = [[PlaceViewController alloc] initWithType: PlaceTypeDeparture];
    } else {
        placeViewController = [[PlaceViewController alloc] initWithType: PlaceTypeArrival];
    }
    placeViewController.delegate = self;
    [self.navigationController pushViewController: placeViewController animated:YES];
}
#pragma mark - PlaceViewControllerDelegate

- (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType {
    [self setPlace:place withDataType:dataType andPlaceType:placeType forButton: (placeType == PlaceTypeDeparture) ? _departureButton : _arrivalButton ];
}

- (void)setPlace:(id)place withDataType:(DataSourceType)dataType andPlaceType:(PlaceType)placeType forButton:(UIButton *)button {
    NSString *title;
    NSString *iata;
    if (dataType == DataSourceTypeCity) {
        City *city = (City *)place;
        title = city.name;
        iata = city.code;
    }
    else if (dataType == DataSourceTypeAirport) {
        Airport *airport = (Airport *)place;
        title = airport.name;
        iata = airport.cityCode;
    }
    if (placeType == PlaceTypeDeparture) {
        _searchRequest.origin = iata;
    } else {
        _searchRequest.destionation = iata;
    }
    [button setTitle: title forState: UIControlStateNormal];
}

@end
