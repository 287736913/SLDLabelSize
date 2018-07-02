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
@property (nonatomic, strong) NSAttributedString *expandAttrString;
@property (nonatomic, strong) NSAttributedString *compactAttrString;
@property (nonatomic, assign) CGFloat labelHeight;
@property (nonatomic, assign) BOOL isExpanded;
@end

#define maxCompactHeight 78
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define labelWidth (kScreenWidth - 24)
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self addSubViews];
    [self layoutSubViews];
}

- (void)addSubViews {
    self.view.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.label];
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
        make.width.mas_equalTo(labelWidth);
        make.height.mas_equalTo(maxCompactHeight);
    }];
}

- (void)expandLabel {
    if (_isExpanded) {
        _label.numberOfLines = 3;
        [_label setAttributedText:self.compactAttrString];
        [_label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(maxCompactHeight);
        }];
    } else {
        _label.numberOfLines = 0;
        [_label setAttributedText:self.expandAttrString];
        [_label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.scrollView.mas_bottom).offset(30);
            make.width.mas_equalTo(labelWidth);
            make.height.greaterThanOrEqualTo(@0.f);
        }];
    }
    _isExpanded = !_isExpanded;
}

-(NSAttributedString *)cutAttributedText:(NSAttributedString *)attributedText maxSize:(CGSize )maxSize appendString:(NSString *)appendString {
    if (!attributedText.length)
        return [[NSAttributedString alloc]initWithString:@""];
    
    if (ceil([self attributedTextHeight:attributedText appendString:nil]) <= maxCompactHeight)
        return attributedText;

    NSRange range = NSMakeRange(0, 0);
    for (NSInteger len = attributedText.length; len > 0; len--) {
        range.length = len;
        NSAttributedString * tmpStr = [attributedText attributedSubstringFromRange:range];
        CGFloat textHeight = ceil([self attributedTextHeight:tmpStr appendString:appendString]);
        if (textHeight <= maxCompactHeight) {
            return [self attributedString:tmpStr appendString:appendString];
        }
    }
    return [[NSAttributedString alloc]initWithString:@"error"];
}

- (CGFloat)attributedTextHeight:(NSAttributedString *)attributedText appendString:(NSString *)appendString
{
    attributedText = [self attributedString:attributedText appendString:appendString];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine;
    CGSize size = [attributedText boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX) options:options context:nil].size;
    return size.height;
}

- (NSAttributedString *)attributedString:(NSAttributedString *)attributedText appendString:(NSString *)appendString {
    if (appendString) {
        NSMutableAttributedString *mutAttrString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
        [mutAttrString appendAttributedString:[[NSAttributedString alloc] initWithString:appendString
                                                                              attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Regular" size:14]}]];
        attributedText = [mutAttrString copy];
    }
    return attributedText;
}

#pragma mark lazy loading
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UILabel *)label {
    if (!_label) {
        NSString *string = @"6月是毕业季，很多\n大学毕业生玩起创意毕业照 \n，穿婚纱、女装反串、民国校园风等，然而暨大学生暴雨毕业照意外走红。6月26日，暨大2016 级广告专硕研究生到校门前拍摄毕业合照，但是在拍摄时突然下起了大雨。身着硕士服的23位毕业生们站成前后两行，与端坐在最前排的3位老师，共同冒雨完成了毕业照的拍摄。";
        NSLog(@"%@",string);
        self.expandAttrString = [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Regular" size:18]}];
        
        self.compactAttrString = [self cutAttributedText:self.expandAttrString
                                                 maxSize:CGSizeMake(labelWidth, MAXFLOAT)
                                            appendString:@"[...展开]"];
        
        _label = [[UILabel alloc] init];
        _label.tintColor = [UIColor blackColor];
        _label.numberOfLines = 3;
        _label.backgroundColor = [UIColor greenColor];
        [_label setAttributedText:self.compactAttrString];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandLabel)];
        _label.userInteractionEnabled = YES;
        [_label addGestureRecognizer:tapGesture];
    }
    return _label;
}

@end
