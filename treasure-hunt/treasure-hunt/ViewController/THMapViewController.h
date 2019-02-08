//
//  THMapViewController.h
//  treasure-hunt
//
//  Created by De MicheliStefano on 07.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THMapViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (void)drawMap;

@end

NS_ASSUME_NONNULL_END
