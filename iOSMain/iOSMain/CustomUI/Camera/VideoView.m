//
//  VideoView.m
//  iOSMain
//
//  Created by shenjie on 2020/11/25.
//

#import "VideoView.h"

@implementation VideoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self addSubview:self.bgView];
        [self addSubview:self.progressView];
        [self addSubview:self.btnCamera];
        [self addSubview:self.imgRecord];
        [self addSubview:self.btnEnsure];
        [self addSubview:self.btnAfresh];
        [self addSubview:self.btnBack];
        [self addSubview:self.focusCursor];
        self.progressView.layer.cornerRadius = self.progressView.frame.size.width/2;
        self.progressView.layer.masksToBounds = YES;
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(0);
            make.right.mas_equalTo(self.mas_right).offset(0);
            make.top.mas_equalTo(self.mas_top).offset(0);
            make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        }];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_centerX).offset(87/2);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-BottomBarHeight);
            make.width.mas_equalTo(87);
            make.height.mas_offset(87);
        }];
        [self.imgRecord mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.progressView.mas_centerX).offset(67/2);
            make.bottom.mas_equalTo(self.progressView.mas_centerY).offset(67/2);
            make.width.mas_equalTo(67);
            make.height.mas_offset(67);
        }];
        [self.btnCamera mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-20);
            make.top.mas_equalTo(self.mas_top).offset(StatusBarHeight);
            make.width.mas_equalTo(37);
            make.height.mas_offset(37);
        }];
        [self.btnEnsure mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.progressView.mas_centerX).offset(70/2);
            make.bottom.mas_equalTo(self.progressView.mas_centerY).offset(70/2);
            make.width.mas_equalTo(70);
            make.height.mas_offset(70);
        }];
        [self.btnAfresh mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.progressView.mas_centerX).offset(70/2);
            make.bottom.mas_equalTo(self.progressView.mas_centerY).offset(70/2);
            make.width.mas_equalTo(70);
            make.height.mas_offset(70);
        }];
        [self.btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.btnEnsure.mas_left).offset(-20);
            make.bottom.mas_equalTo(self.btnEnsure.mas_centerY).offset(40/2);
            make.width.mas_equalTo(40);
            make.height.mas_offset(40);
        }];
    }
    return self;
}

- (void)updateUI:(BOOL)flag{
    if (flag) {
        [self.btnEnsure mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.progressView.mas_centerX).offset(10);
            make.bottom.mas_equalTo(self.progressView.mas_centerY).offset(70/2);
            make.width.mas_equalTo(70);
            make.height.mas_offset(70);
        }];
        [self.btnAfresh mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.progressView.mas_centerX).offset(-10);
            make.bottom.mas_equalTo(self.progressView.mas_centerY).offset(70/2);
            make.width.mas_equalTo(70);
            make.height.mas_offset(70);
        }];
        [self.btnBack mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.btnAfresh.mas_left).offset(-20);
            make.bottom.mas_equalTo(self.btnEnsure.mas_centerY).offset(40/2);
            make.width.mas_equalTo(40);
            make.height.mas_offset(40);
        }];
    }else{
        [self.btnEnsure mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.progressView.mas_centerX).offset(70/2);
            make.bottom.mas_equalTo(self.progressView.mas_centerY).offset(70/2);
            make.width.mas_equalTo(70);
            make.height.mas_offset(70);
        }];
        [self.btnAfresh mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.progressView.mas_centerX).offset(70/2);
            make.bottom.mas_equalTo(self.progressView.mas_centerY).offset(70/2);
            make.width.mas_equalTo(70);
            make.height.mas_offset(70);
        }];
        [self.btnBack mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.btnEnsure.mas_left).offset(-20);
            make.bottom.mas_equalTo(self.btnEnsure.mas_centerY).offset(40/2);
            make.width.mas_equalTo(40);
            make.height.mas_offset(40);
        }];
    }
}

- (UIImageView *)bgView{
    if (!_bgView) {
        _bgView = [[UIImageView alloc]init];
    }
    return _bgView;
}

- (VideoProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[VideoProgressView alloc]initWithFrame:CGRectMake(0, 0, 87, 87)];
        _progressView.backgroundColor = [UIColor grayColor];
        _progressView.hidden = YES;
    }
    return _progressView;
}

- (UIButton *)btnCamera{
    if (!_btnCamera) {
        _btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnCamera setImage:[UIImage imageNamed:@"btn_video_flip_camera"] forState:UIControlStateNormal];
        [_btnCamera addTarget:self action:@selector(flipCameraClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCamera;
}

- (UIImageView *)imgRecord{
    if (!_imgRecord) {
        _imgRecord = [[UIImageView alloc]init];
        _imgRecord.image = [UIImage imageNamed:@"video_take"];
        _imgRecord.userInteractionEnabled = YES;
    }
    return _imgRecord;
}

- (UIButton *)btnEnsure{
    if (!_btnEnsure) {
        _btnEnsure = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnEnsure setImage:[UIImage imageNamed:@"Video_confirm"] forState:UIControlStateNormal];
        _btnEnsure.hidden = YES;
        [_btnEnsure addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnEnsure;
}

- (UIButton *)btnAfresh{
    if (!_btnAfresh) {
        _btnAfresh = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnAfresh setImage:[UIImage imageNamed:@"Video_cancel"] forState:UIControlStateNormal];
        _btnAfresh.hidden = YES;
        [_btnAfresh addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAfresh;
}

- (UIButton *)btnBack{
    if (!_btnBack) {
        _btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnBack setImage:[UIImage imageNamed:@"Video_back"] forState:UIControlStateNormal];
        [_btnBack addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnBack;
}

- (UIImageView *)focusCursor{
    if (!_focusCursor) {
        _focusCursor = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44, 126)];
        _focusCursor.image = [UIImage imageNamed:@"Video_focusing"];
        [_focusCursor setFrame:CGRectMake(0, 0, _focusCursor.image.size.width, _focusCursor.image.size.height)];
        _focusCursor.alpha = 0;
    }
    return _focusCursor;
}

- (void)flipCameraClick{
    [self.delegate flipCameraClick];
}

- (void)sureClick{
    [self.delegate sureClick];
}

- (void)cancelClick{
    [self.delegate cancelClick];
}

- (void)backClick{
    [self.delegate onCancelAction];
}

@end
