//
//  PlaceViewController.h
//  AviaSales
//
//  Created by Alex on 05/12/2018.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "NSString+Localize.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum PlaceType {
    PlaceTypeArrival,
    PlaceTypeDeparture
} PlaceType;

@protocol PlaceViewControllerDelegate <NSObject>
- (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType;
@end

@interface PlaceViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) id<PlaceViewControllerDelegate>delegate;
- (instancetype)initWithType:(PlaceType)type;

@end

NS_ASSUME_NONNULL_END
