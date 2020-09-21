//
//  XYHPickerView.m
//  Black
//
//  Created by xuyiheng on 15/10/24.
//  Copyright © 2015年 徐恒. All rights reserved.
//

#import "XYHPickerView.h"

#define TextColor [UIColor blackColor]
#define sizeOfText 18
#define row_height 50
#define CornerRadius 10

@interface XYHPickerCell : UITableViewCell

@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIView *lineView;

@end

@implementation XYHPickerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        // 1. 创建标题
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width - 20, row_height - 1)];
        self.titleLabel.font = kFontBold16;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
        
        
        // 3. 创建线条
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, row_height-1, kScreen_Width-20, 1)];
        [self.contentView addSubview:self.lineView];
        
    }
    
    return self;
}

@end


@interface XYHPickerView()

@property (assign, nonatomic) NSInteger selectIndex;

@property (strong, nonatomic) myBlock sendBlock;

/** 蒙版Button */
@property (strong, nonatomic) XXButton *mengBanButton;

/** 主面板 */
@property (strong, nonatomic) UIView *mainBanView;

/** 取消按钮 */
@property (strong, nonatomic) XXButton *quxiaButton;


@end

@implementation XYHPickerView
static XYHPickerView *object = nil;

+ (void)showPickerViewWithNamesArray:(NSMutableArray *)names selectIndex:(NSInteger)selectIndex Block:(myBlock)block {
    
    // 1. 判断当前Object是否为空, 如果为空就创建一个
    if ( object == nil) {
        @synchronized (self){ // 避免多个线程同时访问
            if (object == nil) {
                
                // 1. 创建拾取器视图对象
                object = [[XYHPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
                
                // 2. 创建蒙版
                object.mengBanButton = [XXButton buttonWithFrame:object.bounds block:^(UIButton *button) {
                    
                    // 出场
                    [UIView animateWithDuration:0.3 animations:^{
                        object.mengBanButton.alpha = 0;
                        object.mainBanView.top = kScreen_Height;
                    } completion:^(BOOL finished) {
                        [object removeFromSuperview];
                    }];
                    
                }];
                object.mengBanButton.backgroundColor = [UIColor blackColor];
                object.mengBanButton.alpha = 0;
                [object addSubview:object.mengBanButton];
                
                // 3. 创建主面板
                object.mainBanView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height, kScreen_Width, 0)];
                object.backgroundColor = [UIColor clearColor];
                [object addSubview:object.mainBanView];
                
                // 4. 创建表示图
                object.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, kScreen_Width - 20, 0) style:UITableViewStylePlain];
                object.tableView.delegate = object;
                object.tableView.dataSource = object;
                object.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                object.tableView.backgroundColor = kWhite100;
                object.tableView.layer.cornerRadius = CornerRadius;
                object.tableView.layer.masksToBounds = YES;
                [object.mainBanView addSubview:object.tableView];
                
                
                // 5. 创建取消按钮
                object.quxiaButton = [XXButton buttonWithFrame:CGRectMake(10, 0, kScreen_Width-20, row_height) title:@"" font:kFontBold18 titleColor:kDark100 block:^(UIButton *button) {
               
                    // 出场
                    [UIView animateWithDuration:0.3 animations:^{
                        object.mengBanButton.alpha = 0;
                        object.mainBanView.top = kScreen_Height;
                    } completion:^(BOOL finished) {
                        
                        [object removeFromSuperview];
                        
                    }];
                    
                }];
                object.quxiaButton.backgroundColor = kWhite100;
                object.quxiaButton.layer.cornerRadius = CornerRadius;
                object.quxiaButton.layer.masksToBounds = YES;
                object.quxiaButton.titleLabel.font = kFontBold18;
                [object.mainBanView addSubview:object.quxiaButton];
                
                // 7. 调用出场事件
                [object showPickerViewWithNamesArray:names selectIndex:selectIndex Block:block];
                
            }
        }
    } else {
    
        // 调用出场事件
        [object showPickerViewWithNamesArray:names selectIndex:selectIndex Block:block];
        
    }
    
}

#pragma mark - Show picker view
- (void)showPickerViewWithNamesArray:(NSMutableArray *)names selectIndex:(NSInteger)selectIndex Block:(myBlock)block{
    
    self.selectIndex = selectIndex;
    self.tableView.backgroundColor = kWhite100;
    self.quxiaButton.backgroundColor = kWhite100;
    [self.quxiaButton setTitle:LocalizedString(@"Cancel") forState:UIControlStateNormal];
    [self.quxiaButton setTitleColor:kDark100 forState:UIControlStateNormal];
    
    // 1. 指定回调的Block
    self.sendBlock = block;
    
    // 2. 数组赋值
    self.namesArray = names;
    
    // 3. 刷新标示图
    [self.tableView reloadData];
    
    // 4. 设定表示图的frame
    if (names.count*row_height < kScreen_Height*2/3) {
        self.tableView.height = names.count*row_height;
    } else {
        self.tableView.height = kScreen_Height*0.66;
    }
    
    CGFloat tabbarHeight = BH_IS_IPHONE_X ? 24 : 0;
    self.mainBanView.height = self.tableView.height + (row_height + 20) + tabbarHeight;
    self.quxiaButton.top = CGRectGetMaxY(self.tableView.frame) + 10;

    // 6. 把Object添加到窗口
    [KWindow addSubview:self];
    
    // 7. 展现视图
    [UIView animateWithDuration:0.3 animations:^{
        self.mengBanButton.alpha = 0.5;
        self.mainBanView.top = kScreen_Height - self.mainBanView.height;
        
    }];
}

#pragma mark - 表示图代理事件
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.namesArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return row_height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XYHPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xuanzeqi"];
    if (cell == nil) {
        cell = [[XYHPickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xuanzeqi"];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    }
    
    cell.selectedBackgroundView.backgroundColor = KLine_Color;
    
    // 1. 填充单元格内标签的内容
    cell.titleLabel.text = self.namesArray[indexPath.row];

    // 3. 设置线条颜色
    cell.lineView.backgroundColor = KLine_Color;
    
    // 4. 设置整体背景颜色和透明度
    cell.backgroundColor = kWhite100;
    
    if (self.selectIndex == indexPath.row) {
        cell.titleLabel.textColor = kBlue100;
    } else {
        cell.titleLabel.textColor = kDark100;
    }
    
    if (indexPath.row == self.namesArray.count - 1) {
        cell.lineView.hidden = YES;
    } else {
        cell.lineView.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    // 出场
    [UIView animateWithDuration:0.3 animations:^{
        self.mengBanButton.alpha = 0;
        self.mainBanView.frame = CGRectMake(0, kScreen_Height, kScreen_Width, 70 + self.tableView.frame.size.height);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];

    }];
    
    // 回调Block
    self.sendBlock(self.namesArray[indexPath.row], indexPath.row);
    
}

@end
