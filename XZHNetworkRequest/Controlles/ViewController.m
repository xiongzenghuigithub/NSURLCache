//
//  ViewController.m
//  XZHNetwork
//
//  Created by sfpay on 15/2/7.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import "ViewController.h"
#import "InfoViewModel.h"
#import "LanrenInfoViewModel.h"
#import "NSMutableArray+Queue.h"

@interface ViewController ()
@property (nonatomic, strong) UIButton *requestButton;
@end

@implementation ViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)initSignals {
    
    [[self.requestButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x)
    {
//        [InfoViewModel getLatestInfoListWithPage:3
//                                  SuccessComplet:^(id responseObj) {
//                                      
//                                  } ErrorComplet:^(NSNumber *errCode) {
//                                      
//                                  } FailComplet:^(NSError *error) {
//                                      
//                                  }];
        
        [LanrenInfoViewModel getAppClientWithSuccessCompet:^(id responseObject) {
            
//            [LanrenInfoViewModel indexInfoListForPagr:1 SuccessCompet:^(id responseObject) {
//                BFLog(@"responseObject = %@\n", responseObject);
//            } ErrorComplet:^(NSNumber *errorCode) {
//                
//            } FailComplet:^(NSError *error) {
//                
//            } UseCache:YES];
            
        } ErrorComplet:^(NSNumber *errorCode) {
            
        } FailComplet:^(NSError *error) {
            
        }];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubviews];
    [self initSignals];

}

- (void)initSubviews {
    _requestButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _requestButton.backgroundColor = [UIColor randomColor];
    [_requestButton setTitle:@"Request" forState:UIControlStateNormal];
    [self.view addSubview:_requestButton];
    
    
    UIView *superView = [self view];
    
    @weakify(superView);
    [_requestButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(superView);
        make.top.mas_equalTo(superView).offset(10);
        make.width.mas_equalTo(superView);
        make.left.mas_equalTo(superView.mas_left);
        make.height.mas_equalTo(@50);
    }];
}

- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    //1. 清除内存缓存
    
    //2. 清除本地文件缓存
    
}

@end
