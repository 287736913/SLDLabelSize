//
//  ViewController.m
//  ScrollLabel
//
//  Created by 王明磊 on 2018/6/25.
//  Copyright © 2018年 王明磊. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

#define maxCompactHeight 45


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self addSubViews];
    [self layoutSubViews];
}

- (void)addSubViews {
    self.view.backgroundColor = [UIColor grayColor];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];

    NSString *string = @" 1\n 2\n 3\n 4\n 5\n 6\n 7\n 8";
    NSLog(@"%@",string);
    _label = [[UILabel alloc] init];
    _label.text = string;
    _label.tintColor = [UIColor blackColor];
    _label.numberOfLines = 2;
    _label.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_label];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(spread)];
    _label.userInteractionEnabled = YES;
    [_label addGestureRecognizer:tapGesture];

}

- (void)layoutSubViews {
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0).offset(10);
        make.right.mas_equalTo(0).offset(-20);
        make.bottom.mas_equalTo(self.view).offset (-300);
        make.height.mas_equalTo(40);
    }];
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView.mas_bottom).offset(30);
        make.width.equalTo(self.scrollView).offset(-20);
        make.height.greaterThanOrEqualTo(@0.f);
    }];
}

- (void)spread {
    if (!_label.numberOfLines) {
        _label.numberOfLines = 2;
        [_label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(maxCompactHeight);
        }];
    } else {
        _label.numberOfLines = 0;
        [_label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.scrollView.mas_bottom).offset(30);
            make.width.equalTo(self.scrollView).offset(-20);
            make.height.greaterThanOrEqualTo(@0.f);
        }];
    }
}


@end
