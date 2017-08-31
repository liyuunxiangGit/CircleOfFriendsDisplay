//
//  GetInfoSection.m
//  CircleOfFriendsDisplay
//
//  Created by liyunxiang on 16/11/3.
//  Copyright © 2016年 李云祥. All rights reserved.
//

#import "GetInfoSection.h"

@implementation GetInfoSection
/**
 *  模拟数据
 *  给界面进行网络请求
 */
+ (NSMutableArray *)getInfo {
   
    NSMutableArray *fakeDatasource = [[NSMutableArray alloc]init];

    NSArray *array = @[
                        @{
                            @"name": @"SIZE潮流生活",
                            @"avatar": @"http://tp2.sinaimg.cn/1829483361/50/5753078359/1",
                            @"content": @"近日[心]，adidas Originals为经典鞋款Stan Smith打造Primeknit版本，并带来全新的“OG”系列。简约的鞋身采用白色透气Primeknit针织材质制作， www.baidu.com 再将Stan Smith代表性的绿、红、深蓝三个元年色调融入到鞋舌和后跟点缀，最后搭载上米白色大底来保留其复古风味。据悉该鞋款将在今月登陆全球各大adidas Originals指定店舖。 http://blog.csdn.net/liyunxiangrxm/article/details/52082884 ",
                            @"date": @"1459668442",
                            @"time":@"08/29 10:25",
                            @"imgs": @[@"http://ww2.sinaimg.cn/mw690/6d0bb361gw1f2jim2hgxij20lo0egwgc.jpg",
                                       @"http://ww3.sinaimg.cn/mw690/6d0bb361gw1f2jim2hsg6j20lo0egwg2.jpg",
                                       @"http://ww1.sinaimg.cn/mw690/6d0bb361gw1f2jim2d7nfj20lo0eg40q.jpg",
                                       @"http://ww1.sinaimg.cn/mw690/6d0bb361gw1f2jim2hka3j20lo0egdhw.jpg",
                                       @"http://ww2.sinaimg.cn/mw690/6d0bb361gw1f2jim2hq61j20lo0eg769.jpg"
                                       ],
                            @"statusID": @"1",
                            @"commentList": @[
                                    @{
                                        @"from": @"SIZE潮流生活",
                                        @"to": @"",
                                        @"content": @"使用LWAsyncDisplay来实现图文混排。享受如丝般顺滑的滚动体验。"
                                        },
                                    @{
                                        @"from": @"waynezxcv",
                                        @"to": @"SIZE潮流生活",
                                        @"content": @"哈哈哈哈"
                                        },
                                    @{
                                        @"from": @"SIZE潮流生活",
                                        @"to": @"waynezxcv",
                                        @"content": @"nice~使用LWAsyncDisplayView。支持异步绘制，让滚动如丝般顺滑。并且支持图文混排[心]和点击链接#LWAsyncDisplayView#"
                                        }
                                    ]
                            },
                        @{
                            @"name": @"妖妖小精",
                            @"avatar": @"http://tp2.sinaimg.cn/2185608961/50/5714822219/0",
                            @"content": @"出国留学的儿子为思念自己的家人们寄来一个用自己照片做成的人形立牌，本人博客：富文本的使用 http://blog.csdn.net/liyunxiangrxm/article/details/52046038",
                            @"date": @"1459668442",
                            @"time":@"08/29 10:25",
                            @"statusID": @"2",
                            @"commentList": @[
                                    @{
                                        @"from": @"waynezxcv",
                                        @"to": @"妖妖小精",
                                        @"content": @"[心]"
                                        }
                                    ],
                            @"MsgType":@"text",
                            },
                        @{
                            @"name": @"妖妖小精",
                            @"avatar": @"http://tp2.sinaimg.cn/2185608961/50/5714822219/0",
                            @"content": @"出国留学的儿子为思念自己的家人们寄来一个用自己照片做成的人形立牌，本人博客：富文本的使用 http://blog.csdn.net/liyunxiangrxm/article/details/52046038",
                            @"date": @"1459668442",
                            @"time":@"08/29 10:25",
                            @"imgs": @[
                                    @"http://ww3.sinaimg.cn/mw690/8245bf01jw1f2jhh2ohanj20jg0yk418.jpg",
                                    @"http://ww4.sinaimg.cn/mw690/8245bf01jw1f2jhh34q9rj20jg0px77y.jpg",
                                    @"http://ww1.sinaimg.cn/mw690/8245bf01jw1f2jhh3grfwj20jg0pxn13.jpg",
                                    @"http://ww4.sinaimg.cn/mw690/8245bf01jw1f2jhh3ttm6j20jg0el76g.jpg",
                                    @"http://ww3.sinaimg.cn/mw690/8245bf01jw1f2jhh43riaj20jg0pxado.jpg",
                                    @"http://ww2.sinaimg.cn/mw690/8245bf01jw1f2jhh4mutgj20jg0ly0xt.jpg",
                                    @"http://ww3.sinaimg.cn/mw690/8245bf01jw1f2jhh4vc7pj20jg0px41m.jpg",
                                    @"http://ww4.sinaimg.cn/mw690/8245bf01jw1f2jhh2mgkgj20jg0pxn2z.jpg"
                                    ],
                            @"statusID": @"2",
                            @"commentList": @[
                                    @{
                                        @"from": @"waynezxcv",
                                        @"to": @"妖妖小精",
                                        @"content": @"[心]"
                                        }
                                    ]
                            },
                        @{
                            @"name": @"妖妖小精",
                            @"avatar": @"http://tp2.sinaimg.cn/2185608961/50/5714822219/0",
                            @"content": @"望断天涯，不见君暖馨，只见一片片枯叶冷梧桐，最是心寒荒凉寄。一室尘埃，染烟雪，谁将残红，榭轻波？一片汪洋终是太茫茫。风凄凄，夜太寒，云落千丈，情太凉，梦落烟花，一场空，一片寥寂，怎呻吟？愁也叹，凉也叹，悲也泣。一杯清酒，醉断魂。残香半烛，灰已尽。青灯半盏，窗前寒。冷梦湿雨，夜半寒。寒心薄凉，情无语。泪落青衣，花台湿。忧伴袈裟，昏做添。篱落眼脸，心生寒。魂断愁云，三千水。舞落纤红，几清欢？得来翰轩，谁点墨？知恋心寄，多少人？踏月随风，研相思入墨，执笔落花，填半卷清词，在花笺掠影中，任思念缱绻，读你千遍，隔着岁月的窗，将眷恋轻描。一程山水，会因一个人而丰盈；一段时光，会因一场相遇而葱茏，清风绕过处，心如素雅的青莲，将一湄如水的清韵，散发出明媚悠远的清宁，尘封住，初识的那一眼凝眸。浅笑离愁，婉转牵绊，就好像悲伤这场盛宴，曾在无数的执念中，写满了太多的泪痕，在流年荒芜的画里，一笑而过，那些缘深缘浅终将缘来缘去，彻悟了思情的逐情，世间并没有天长地久，地老天荒，那些曾一段华丽的对望，是悲伤里浅笑的云卷云舒，花开花落。竹笠芒鞋，走过青石小巷，今生，我只是一个乞丐，亦是一个苦行的高僧，在生命的雨巷，向你乞讨，你能否施舍给我，一点尘缘，一个深情的回眸。弱水三千只取一瓢，水流，瓢漂，归何处。红尘渡口，我为你摆渡，可你却留恋红尘，只说此梦千年，不会醒。不忘初心，不忘过去的誓言，不离不弃，莫失莫忘。静水流深，沧笙踏歌，如花美眷，只缘感你一回顾，使我常思朝与暮。转身后，一缕幽香远，逝雪浅，春意浓，笑意深。一叶绽放一追寻，一花盛开一世界，一生相思为一人。望断天涯，不见君暖馨，只见一片片枯叶冷梧桐，最是心寒荒凉寄。一室尘埃，染烟雪，谁将残红，榭轻波？一片汪洋终是太茫茫。风凄凄，夜太寒，云落千丈，情太凉，梦落烟花，一场空，一片寥寂，怎呻吟？愁也叹，凉也叹，悲也泣。一杯清酒，醉断魂。残香半烛，灰已尽。青灯半盏，窗前寒。",
                            @"date": @"1459668442",
                            @"time":@"08/29 10:25",
                            @"imgs": @[
                                    @"http://ww3.sinaimg.cn/mw690/8245bf01jw1f2jhh2ohanj20jg0yk418.jpg",
                                    @"http://ww4.sinaimg.cn/mw690/8245bf01jw1f2jhh34q9rj20jg0px77y.jpg",
                                    @"http://ww2.sinaimg.cn/mw690/8245bf01jw1f2jhh4mutgj20jg0ly0xt.jpg",
                                    @"http://ww3.sinaimg.cn/mw690/8245bf01jw1f2jhh4vc7pj20jg0px41m.jpg",
                                    @"http://ww4.sinaimg.cn/mw690/8245bf01jw1f2jhh2mgkgj20jg0pxn2z.jpg"
                                    ],

                            @"statusID": @"2",
                            @"commentList": @[
                                    @{
                                        @"from": @"waynezxcv",
                                        @"to": @"妖妖小精",
                                        @"content": @"[心]"
                                        }
                                    ]
                            },

                        @{
                            @"name": @"Instagram热门",
                            @"avatar": @"http://tp4.sinaimg.cn/5074408479/50/5706839595/0",
                            @"content": @"Austin Butler & Vanessa Hudgens  想试试看扑到一个一米八几的人怀里是有多舒服[心]",
                            @"date": @"1459668442",
                            @"time":@"08/29 10:25",
                            @"imgs": @[
                                    @"http://ww1.sinaimg.cn/mw690/005xpHs3gw1f2jg132p3nj309u0goq62.jpg",
                                    @"http://ww3.sinaimg.cn/mw690/005xpHs3gw1f2jg14per3j30b40ctmzp.jpg",
                                    @"http://ww3.sinaimg.cn/mw690/005xpHs3gw1f2jg14vtjjj30b40b4q5m.jpg",
                                    @"http://ww1.sinaimg.cn/mw690/005xpHs3gw1f2jg15amskj30b40f1408.jpg",
                                    @"http://ww3.sinaimg.cn/mw690/005xpHs3gw1f2jg16f8vnj30b40g4q4q.jpg",
                                    @"http://ww4.sinaimg.cn/mw690/005xpHs3gw1f2jg178dxdj30am0gowgv.jpg",
                                    @"http://ww2.sinaimg.cn/mw690/005xpHs3gw1f2jg17c5urj30b40ghjto.jpg",
                                    @"http://ww4.sinaimg.cn/mw690/005xpHs3gw1f2jg18p02pj30b40fdmz4.jpg"
                                    ],
                            @"statusID": @"3"
                            },
                        @{
                            @"name": @"头条新闻",
                            @"avatar": @"http://tp1.sinaimg.cn/1618051664/50/5735009977/0",
                            @"content": @"#万象# 【熊孩子！4名小学生铁轨上设障碍物逼停火车】4名小学生打赌，1人认为火车会将石头碾成粉末，其余3人不信，认为只会碾碎，于是他们将道碴摆放在铁轨上。火车司机发现前方不远处的铁轨上，摆放了影响行车安全的障碍物，于是紧急采取制动，列车中途停车13分钟。O4名学生铁轨上设障碍物逼停火车",
                            @"date": @"1459668442",
                            @"time":@"08/29 10:25",
                            @"imgs": @[
                                    @"http://ww2.sinaimg.cn/mw690/60718250jw1f2jg46smtmj20go0go77r.jpg"
                                    ],
                            @"statusID": @"4"
                            },
                        @{
                            @"name": @"优酷",
                            @"avatar": @"http://tp2.sinaimg.cn/1642904381/50/5749093752/1",
                            @"content": @"1000杯拿铁，幻化成一生挚爱。两个人，不远万里来相遇、相识、相知，直至相守，小小拿铁却是大大的世界。 L如何用 1000 杯拿铁表达爱",
                            @"date": @"1459668442",
                            @"time":@"08/29 10:25",
                            @"imgs": @[
                                    @"http://ww1.sinaimg.cn/mw690/61ecbb3dgw1f2jfeqmwskg208w04wwvj.gif"
                                    ],
                            @"statusID": @"5"
                            },
                        @{
                            @"name": @"Kindle中国",
                            @"avatar": @"http://tp1.sinaimg.cn/3262223112/50/5684307907/1",
                            @"content": @"#只限今日#《简单的逻辑学》作者D.Q.麦克伦尼在书中提出了28种非逻辑思维形式，http://blog.csdn.net/liyunxiangrxm/article/details/53410821 凡是抛却了逻辑学一贯的刻板理论，转而以轻松的笔触带领我们畅游这个精彩无比的逻辑世界；《蝴蝶梦》我错了，我曾以为付出自己就是爱你。全球公认20世纪伟大的爱情经典，大陆独家合法授权。",
                            @"date": @"",
                            @"time":@"08/29 10:25",
                            @"imgs": @[
                                    @"http://ww2.sinaimg.cn/mw690/c2719308gw1f2hav54htyj20dj0l00uk.jpg",
                                    @"http://ww4.sinaimg.cn/mw690/c2719308gw1f2hav47jn7j20dj0j341h.jpg"
                                    ],
                            @"statusID": @"6"
                            },
                        @{
                            @"name": @"G-SHOCK",
                            @"avatar": @"http://tp3.sinaimg.cn/1595142730/50/5691224157/1",
                            @"content": @"就算平时没有时间，周末也要带着G-SHOCK到户外走走，感受大自然的满满正能量！",
                            @"date": @"1459668442",
                            @"time":@"08/29 10:25",
                            @"imgs": @[
                                    @"http://ww2.sinaimg.cn/mw690/5f13f24ajw1f2hc1r6j47j20dc0dc0t4.jpg"
                                    ],
                            @"statusID": @"7"
                            },
                        @{
                            @"name": @"型格志style",
                            @"avatar": @"http://tp4.sinaimg.cn/5747171147/50/5741401933/0",
                            @"content": @"春天卫衣的正确打开方式~",
                            @"date": @"1459668442",
                            @"time":@"08/29 10:25",
                            @"imgs": @[
                                    @"http://ww2.sinaimg.cn/mw690/006gWxKPgw1f2jeloxwhnj30fu0g0ta5.jpg",
                                    @"http://ww3.sinaimg.cn/mw690/006gWxKPgw1f2jelpn9bdj30b40gkgmh.jpg",
                                    @"http://ww1.sinaimg.cn/mw690/006gWxKPgw1f2jelriw1bj30fz0g175g.jpg",
                                    @"http://ww3.sinaimg.cn/mw690/006gWxKPgw1f2jelt1kh5j30b10gmt9o.jpg",
                                    @"http://ww4.sinaimg.cn/mw690/006gWxKPgw1f2jeluxjcrj30fw0fz0tx.jpg",
                                    @"http://ww3.sinaimg.cn/mw690/006gWxKPgw1f2jelzxngwj30b20godgn.jpg",
                                    @"http://ww2.sinaimg.cn/mw690/006gWxKPgw1f2jelwmsoej30fx0fywfq.jpg",
                                    @"http://ww4.sinaimg.cn/mw690/006gWxKPgw1f2jem32ccrj30xm0sdwjt.jpg",
                                    @"http://ww4.sinaimg.cn/mw690/006gWxKPgw1f2jelyhutwj30fz0fxwfr.jpg",
                                    
                                    ],
                            @"statusID": @"8"
                            },
                        @{
                            @"name": @"数字尾巴",
                            @"avatar": @"http://tp1.sinaimg.cn/1726544024/50/5630520790/1",
                            @"content": @"外媒 AndroidAuthority 日前曝光诺基亚首款回归作品 NOKIA A1 的渲染图，手机的外形很 N 记，边框控制的不错。这是一款纯正的 Android 机型，传闻手机将采用 5.5 英寸 1080P 屏幕，搭载骁龙 652，Android 6.0 系统，并使用了诺基亚自家的 Z 启动器，不过具体发表的时间还是未知。尾巴们你会期待吗？",
                            @"date": @"1459668442",
                            @"time":@"08/29 10:25",
                            @"imgs": @[
                                    @"http://ww3.sinaimg.cn/mw690/66e8f898gw1f2jck6jnckj20go0fwdhb.jpg"
                                    ],
                            @"statusID": @"9"
                            },
                        @{
                            @"name": @"欧美街拍XOXO",
                            @"avatar": @"http://tp4.sinaimg.cn/1708004923/50/1283204657/0",
                            @"content": @"3.31～4.2 肯豆",
                            @"date": @"1459668442",
                            @"imgs": @[
                                    @"http://ww2.sinaimg.cn/mw690/65ce163bjw1f2jdkd2hgjj20cj0gota8.jpg",
                                    @"http://ww1.sinaimg.cn/mw690/65ce163bjw1f2jdkjdm96j20bt0gota9.jpg",
                                    @"http://ww2.sinaimg.cn/mw690/65ce163bjw1f2jdkvwepij20go0clgnd.jpg",
                                    @"http://ww4.sinaimg.cn/mw690/65ce163bjw1f2jdl2ao77j20ci0gojsw.jpg",
                                    
                                    ],
                            @"statusID": @"10"
                            },
                        
                        ];
    [fakeDatasource addObjectsFromArray:array];
    return fakeDatasource;
}

@end
