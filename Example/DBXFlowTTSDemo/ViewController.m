//
//  ViewController.m
//  WebSocketDemo
//
//  Created by linxi on 19/11/6.
//  Copyright © 2017年 newbike. All rights reserved.
//

#import "ViewController.h"
#import <DBFlowTTS/DBSynthesizerManager.h>
#import <DBCommon/DBSynthesisPlayer.h>
#import <AVFoundation/AVFoundation.h>


 NSString * textViewText = @"标贝&科技10%交互@123提供智能语音整体解决方案和数据服务 近期，天津市宝坻区某百货大楼内部，10%的 @123酒精相继出现了5例新型冠状病毒感染的肺炎病例。这几个病例都没有去过武汉，也没有接触过确诊病例，而且从前三个病例发病时的情况看，似乎找不到到任何流行病学上的关联性。他们是怎么发病的？发病前有哪些情况是可以溯源？2月2日，天津市疾控中心传染病预防控制室主任张颖在发布会上，针对这起聚集性暴发的疫情进行了全程脱稿的“福尔摩斯式”分析，谜底层层被揭开，而这背后，给大家的却是一个深刻的警示！ 我们再来复盘一下—— 第1个病例： 百货大楼小家电区销售人员无武汉的流行病学史，无外出经历，也没有接触过确诊病例或疑似病例1月22日发热，商场26日春节停业。该售货员发病之后连续4天都在没有发热门诊的社区门诊看病。期间，她持续高热，自己购买药物在家中处理。31日到天津宝坻区医院的发热门诊就诊。最终被天津市疾病预防控制中心确认为确诊病例。源？2月2日，天津市疾控中心传染病预防控制室主任张颖在发布会上，针对这起聚集性暴发的疫情进行了全程脱稿的“福尔摩斯式”分析，谜底层层被揭开，而这背后，给大家的却是一个深刻的警示！ 我们再来复盘一下—— 第1个病例： 百货大楼小家电区销售人员无武汉的流行病学史，无外出经历，也没有接触过确诊病例或疑似病例1月22日发热，商场26日春节停业。该售货员发病之后连续4天都在没有发热门诊的社区门诊看病。期间，她持续高热，自己购买药物在家中处理。31日到天津宝坻区医院的发热门诊就诊。最终被天津市疾病预防控制中心确认为确诊病例。";
//NSString * textViewText = @"标贝&科技10%交互@123提供智能语音整体解决方案和数据服务 近期，天津市宝坻区某百货大楼内部，10%的 @123酒精相继出现了5例新型冠状病";


@interface ViewController ()<DBSynthesisPlayerDelegate,DBSynthesizerManagerDelegate,UITextViewDelegate>
/// 合成管理类
@property(nonatomic,strong)DBSynthesizerManager * synthesizerManager;
/// 合成需要的参数
@property(nonatomic,strong)DBSynthesizerRequestParam * synthesizerPara;
/// 展示文本的textView
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property(nonatomic,strong)NSMutableString * textString;

/// 播放器设置
@property(nonatomic,strong)DBSynthesisPlayer * synthesisDataPlayer;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
/// 展示回调状态
@property (weak, nonatomic) IBOutlet UITextView *displayTextView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textString = [textViewText mutableCopy];
    self.displayTextView.text = @"";
    [self addBorderOfView:self.textView];
    [self addBorderOfView:self.displayTextView];
    self.textView.text = textViewText;
    
    _synthesizerManager = [[DBSynthesizerManager alloc]init];
    //设置打印日志
     _synthesizerManager.log = YES;
    
    //TODO: 如果使用私有化部署,按如下方式设置URL,否则设置setupClientId：clientSecret：的方法进行授权
//   [_synthesizerManager setupPrivateDeploymentURL:@"default"];
    [_synthesizerManager setupClientId:@"" clientSecret:@"" handler:^(BOOL ret, NSString * _Nonnull token) {
        NSLog(@"ret:%@,message:%@",@(ret),token);
    }];
    _synthesizerManager.delegate = self;
    
    // 设置播放器
    _synthesisDataPlayer = [[DBSynthesisPlayer alloc]init];
    _synthesisDataPlayer.delegate = self;
    
    // 将初始化的播放器给合成器持有，合成器会持有并回调数据给player
    self.synthesizerManager.synthesisDataPlayer = self.synthesisDataPlayer;
    
    
}

// MARK: IBActions

- (IBAction)startAction:(id)sender {
    // 先清除之前的数据
    [self resetPlayState];
    self.displayTextView.text = @"";
    if (!_synthesizerPara) {
        _synthesizerPara = [[DBSynthesizerRequestParam alloc]init];
    }
    _synthesizerPara.audioType = DBTTSAudioTypePCM16K;
    _synthesizerPara.text = self.textView.text;
    _synthesizerPara.voice = @"标准合成_模仿儿童_果子";
    
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();

    // 设置合成参数
    NSInteger code = [self.synthesizerManager setSynthesizerParams:self.synthesizerPara];
    if (code == 0) {
        // 开始合成
        [self.synthesizerManager start];
    }
    NSLog(@"设置时间 %@",@(CFAbsoluteTimeGetCurrent() - startTime));

}
- (IBAction)closeAction:(id)sender {
    [self.synthesizerManager stop];
    [self resetPlayState];
    self.displayTextView.text = @"";

}
///  重置播放器播放控制状态
- (void)resetPlayState {
    if (self.playButton.isSelected) {
        self.playButton.selected = NO;
    }
    [self.synthesisDataPlayer stopPlay];
}

- (IBAction)playAction:(UIButton *)sender {
    if (self.synthesisDataPlayer.isReadyToPlay && self.synthesisDataPlayer.isPlayerPlaying == NO) {
        [self.synthesisDataPlayer startPlay];
    }else {
        [self.synthesisDataPlayer pausePlay];
    }
}
- (IBAction)currentPlayPosition:(id)sender {
    NSString *position = [NSString stringWithFormat:@"播放进度 %@",[self timeDataWithTimeCount:self.synthesisDataPlayer.currentPlayPosition]];
    [self appendLogMessage:position];
}
- (IBAction)getAudioLength:(id)sender {
    NSString *audioLength = [NSString stringWithFormat:@"音频数据总长度 %@",[self timeDataWithTimeCount:self.synthesisDataPlayer.audioLength]];
    [self appendLogMessage:audioLength];
}
- (IBAction)playState:(id)sender {
    NSString *message;
    if (self.synthesisDataPlayer.isPlayerPlaying) {
        message = @"正在播放";
    }else {
        message = @"播放暂停";
    }
    [self appendLogMessage:message];
}

//

- (void)onSynthesisCompleted {
    [self appendLogMessage:@"合成完成"];
}

- (void)onSynthesisStarted {
    [self appendLogMessage:@"开始合成"];

}
- (void)onBinaryReceivedData:(NSData *)data audioType:(NSString *)audioType interval:(NSString *)interval endFlag:(BOOL)endFlag {
    NSLog(@"interval :%@,endFlag:%@",interval,@(endFlag));
    NSString *msg = [NSString stringWithFormat:@",endFlag:%@",@(endFlag)];
    [self appendLogMessage:msg];
}

- (void)onTaskFailed:(DBFailureModel *)failreModel  {
    NSLog(@"合成播放失败 %@",failreModel);
    [self appendLogMessage:[NSString stringWithFormat:@"合成播放失败 %@",failreModel.message]];
}

//MARK:  UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:textViewText]&&textView == self.textView) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.textView.isFirstResponder) {
        [self.textView resignFirstResponder];
    }
    if (self.displayTextView.isFirstResponder) {
        [self.displayTextView resignFirstResponder];
    }
}

//MARK: player Delegate


- (void)readlyToPlay {
    [self appendLogMessage:@"准备就绪"];
    [self playAction:self.playButton];
}

- (void)playFinished {
    [self appendLogMessage:@"播放结束"];
    [self resetPlayState];
    self.playButton.selected = NO;
}

- (void)playPausedIfNeed {
    self.playButton.selected = NO;
    [self appendLogMessage:@"暂停"];

}

- (void)playResumeIfNeed  {
    self.playButton.selected = YES;
    [self appendLogMessage:@"播放"];
}

- (void)updateBufferPositon:(float)bufferPosition {
    [self appendLogMessage:[NSString stringWithFormat:@"buffer 进度 %.0f%%",bufferPosition*100]];
}


// MARK: Private Methods

- (void)addBorderOfView:(UIView *)view {
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 1.f;
    view.layer.masksToBounds =  YES;
}


- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (NSString *)timeDataWithTimeCount:(CGFloat)timeCount {
    long audioCurrent = ceil(timeCount);
    NSString *str = nil;
    if (audioCurrent < 3600) {
        str =  [NSString stringWithFormat:@"%02li:%02li",lround(floor(audioCurrent/60.f)),lround(floor(audioCurrent/1.f))%60];
    } else {
        str =  [NSString stringWithFormat:@"%02li:%02li:%02li",lround(floor(audioCurrent/3600.f)),lround(floor(audioCurrent%3600)/60.f),lround(floor(audioCurrent/1.f))%60];
    }
    return str;
    
}

- (void)appendLogMessage:(NSString *)message {
    NSString *text = self.displayTextView.text;
    NSString *appendText = [text stringByAppendingString:[NSString stringWithFormat:@"\n%@",message]];
    self.displayTextView.text = appendText;
    [self.displayTextView scrollRangeToVisible:NSMakeRange(self.displayTextView.text.length, 1)];
}


@end
