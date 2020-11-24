//
//  QNUploadServerDomainResolver.m
//  AppTest
//
//  Created by yangsen on 2020/4/23.
//  Copyright © 2020 com.qiniu. All rights reserved.
//

#import "QNUploadDomainRegion.h"
#import "QNResponseInfo.h"
#import "QNUploadServer.h"
#import "QNZoneInfo.h"
#import "QNUploadServerFreezeManager.h"
#import "QNDnsPrefetch.h"
#import "QNUtils.h"

@interface QNUploadIpGroup : NSObject
@property(nonatomic,   copy, readonly)NSString *groupType;
@property(nonatomic, strong, readonly)NSArray <id <QNIDnsNetworkAddress> > *ipList;
@end
@implementation QNUploadIpGroup
- (instancetype)initWithGroupType:(NSString *)groupType
                           ipList:(NSArray <id <QNIDnsNetworkAddress> > *)ipList{
    if (self = [super init]) {
        _groupType = groupType;
        _ipList = ipList;
    }
    return self;
}
- (id <QNIDnsNetworkAddress>)getServerIP{
    if (!self.ipList || self.ipList.count == 0) {
        return nil;
    } else {
        return self.ipList[arc4random()%self.ipList.count];
    }
}
@end

@interface QNUploadServerDomain: NSObject
@property(atomic   , assign)BOOL isAllFrozen;
@property(nonatomic,   copy)NSString *host;
@property(nonatomic, strong)NSArray <QNUploadIpGroup *> *ipGroupList;
@end
@implementation QNUploadServerDomain
+ (QNUploadServerDomain *)domain:(NSString *)host{
    QNUploadServerDomain *domain = [[QNUploadServerDomain alloc] init];
    domain.host = host;
    domain.isAllFrozen = false;
    return domain;
}
- (QNUploadServer *)getServer:(NSArray <QNUploadServerFreezeManager *> *)freezeManagerList{
    if (self.isAllFrozen || !self.host || self.host.length == 0) {
        return nil;
    }
    
    if (!self.ipGroupList || self.ipGroupList.count == 0) {
        [self createIpGroupList];
    }
    
    // Host解析出IP时:
    if (self.ipGroupList && self.ipGroupList.count > 0) {
        QNUploadServer *server = nil;
        for (QNUploadIpGroup *ipGroup in self.ipGroupList) {
            if (![self isGroup:ipGroup.groupType frozenByFreezeManagers:freezeManagerList]) {
                id <QNIDnsNetworkAddress> inetAddress = [ipGroup getServerIP];
                server = [QNUploadServer server:self.host
                                           host:self.host
                                             ip:inetAddress.ipValue
                                         source:inetAddress.sourceValue
                               ipPrefetchedTime:inetAddress.timestampValue];
                break;
            }
        }
        if (server == nil) {
            self.isAllFrozen = true;
        }
        return server;
    }
    
    // Host未解析出IP时:
    NSString *groupType = [QNUtils getIpType:nil host:self.host];
    if (![self isGroup:groupType frozenByFreezeManagers:freezeManagerList]){
        return [QNUploadServer server:self.host host:self.host ip:nil source:nil ipPrefetchedTime:nil];
    } else {
        self.isAllFrozen = true;
        return nil;
    }
}

- (BOOL)isGroup:(NSString *)groupType frozenByFreezeManagers:(NSArray <QNUploadServerFreezeManager *> *)freezeManagerList{
    if (!groupType) {
        return YES;
    }
    if (!freezeManagerList || freezeManagerList.count == 0) {
        return NO;
    }
    
    BOOL isFrozen = NO;
    for (QNUploadServerFreezeManager *freezeManager in freezeManagerList) {
        isFrozen = [freezeManager isFrozenHost:self.host type:groupType];
        if (isFrozen) {
            break;
        }
    }
    return isFrozen;
}

- (QNUploadServer *)getOneServer{
    if (!self.host || self.host.length == 0) {
        return nil;
    }
    if (self.ipGroupList && self.ipGroupList.count > 0) {
        NSInteger index = arc4random()%self.ipGroupList.count;
        QNUploadIpGroup *ipGroup = self.ipGroupList[index];
        id <QNIDnsNetworkAddress> inetAddress = [ipGroup getServerIP];
        QNUploadServer *server = [QNUploadServer server:self.host host:self.host ip:inetAddress.ipValue source:inetAddress.sourceValue ipPrefetchedTime:inetAddress.timestampValue];;
        return server;
    } else {
        return [QNUploadServer server:self.host host:self.host ip:nil source:nil ipPrefetchedTime:nil];
    }
}
- (void)createIpGroupList{
    @synchronized (self) {
        if (self.ipGroupList && self.ipGroupList.count > 0) {
            return;
        }
        
        NSMutableDictionary *ipGroupInfos = [NSMutableDictionary dictionary];
        NSArray *inetAddresses = [kQNDnsPrefetch getInetAddressByHost:self.host];
        for (id <QNIDnsNetworkAddress> inetAddress in inetAddresses) {
            NSString *ipValue = inetAddress.ipValue;
            NSString *groupType = [QNUtils getIpType:ipValue host:self.host];
            if (groupType) {
                NSMutableArray *ipList = ipGroupInfos[groupType] ?: [NSMutableArray array];
                [ipList addObject:inetAddress];
                ipGroupInfos[groupType] = ipList;
            }
        }
        
        NSMutableArray *ipGroupList = [NSMutableArray array];
        for (NSString *groupType in ipGroupInfos.allKeys) {
            NSArray *ipList = ipGroupInfos[groupType];
            QNUploadIpGroup *ipGroup = [[QNUploadIpGroup alloc] initWithGroupType:groupType ipList:ipList];
            [ipGroupList addObject:ipGroup];
        }
        self.ipGroupList = ipGroupList;
    }
}
- (void)freeze:(NSString *)ip freezeManager:(QNUploadServerFreezeManager *)freezeManager frozenTime:(NSInteger)frozenTime{
    [freezeManager freezeHost:self.host type:[QNUtils getIpType:ip host:self.host] frozenTime:frozenTime];
}

@end


@interface QNUploadDomainRegion()
// 是否获取过，PS：当第一次获取Domain，而区域所有Domain又全部冻结时，返回一个domain尝试一次
@property(atomic   , assign)BOOL hasGot;
@property(atomic   , assign)BOOL isAllFrozen;
// 局部冻结管理对象
@property(nonatomic, strong)QNUploadServerFreezeManager *partialFreezeManager;
@property(nonatomic, strong)NSArray <NSString *> *domainHostList;
@property(nonatomic, strong)NSDictionary <NSString *, QNUploadServerDomain *> *domainDictionary;
@property(nonatomic, strong)NSArray <NSString *> *oldDomainHostList;
@property(nonatomic, strong)NSDictionary <NSString *, QNUploadServerDomain *> *oldDomainDictionary;

@property(nonatomic, strong, nullable)QNZoneInfo *zoneInfo;
@end
@implementation QNUploadDomainRegion

- (BOOL)isValid{
    return !self.isAllFrozen && (self.domainHostList.count > 0 || self.oldDomainHostList.count > 0);
}

- (void)setupRegionData:(QNZoneInfo *)zoneInfo{
    _zoneInfo = zoneInfo;
    
    self.isAllFrozen = NO;
    
    NSMutableArray *serverGroups = [NSMutableArray array];
    NSMutableArray *domainHostList = [NSMutableArray array];
    if (zoneInfo.domains) {
        [serverGroups addObjectsFromArray:zoneInfo.domains];
        [domainHostList addObjectsFromArray:zoneInfo.domains];
    }
    self.domainHostList = domainHostList;
    self.domainDictionary = [self createDomainDictionary:serverGroups];
    
    [serverGroups removeAllObjects];
    NSMutableArray *oldDomainHostList = [NSMutableArray array];
    if (zoneInfo.old_domains) {
        [serverGroups addObjectsFromArray:zoneInfo.old_domains];
        [oldDomainHostList addObjectsFromArray:zoneInfo.old_domains];
    }
    self.oldDomainHostList = oldDomainHostList;
    self.oldDomainDictionary = [self createDomainDictionary:serverGroups];
}
- (NSDictionary *)createDomainDictionary:(NSArray <NSString *> *)hosts{
    NSMutableDictionary *domainDictionary = [NSMutableDictionary dictionary];
    
    for (NSString *host in hosts) {
        QNUploadServerDomain *domain = [QNUploadServerDomain domain:host];
        [domainDictionary setObject:domain forKey:host];
    }
    return [domainDictionary copy];
}

- (id<QNUploadServer> _Nullable)getNextServer:(BOOL)isOldServer
                                 responseInfo:(QNResponseInfo *)responseInfo
                                 freezeServer:(id <QNUploadServer> _Nullable)freezeServer{
    if (self.isAllFrozen) {
        return nil;
    }
    
    if (freezeServer.serverId) {
        // 无法连接到Host || Host不可用， 局部冻结
        if (!responseInfo.canConnectToHost || responseInfo.isHostUnavailable) {
            [_domainDictionary[freezeServer.serverId] freeze:freezeServer.ip
                                               freezeManager:self.partialFreezeManager
                                                  frozenTime:kQNGlobalConfiguration.partialHostFrozenTime];
            [_oldDomainDictionary[freezeServer.serverId] freeze:freezeServer.ip
                                                  freezeManager:self.partialFreezeManager
                                                     frozenTime:kQNGlobalConfiguration.partialHostFrozenTime];
        }
        
        // Host不可用，全局冻结
        if (responseInfo.isHostUnavailable) {
            [_domainDictionary[freezeServer.serverId] freeze:freezeServer.ip
                                               freezeManager:kQNUploadServerFreezeManager
                                                  frozenTime:kQNGlobalConfiguration.globalHostFrozenTime];
            [_oldDomainDictionary[freezeServer.serverId] freeze:freezeServer.ip
                                                  freezeManager:kQNUploadServerFreezeManager
                                                     frozenTime:kQNGlobalConfiguration.globalHostFrozenTime];
        }
    }
    
    
    
    NSArray *hostList = isOldServer ? self.oldDomainHostList : self.domainHostList;
    NSDictionary *domainInfo = isOldServer ? self.oldDomainDictionary : self.domainDictionary;
    QNUploadServer *server = nil;
    for (NSString *host in hostList) {
        server = [domainInfo[host] getServer:@[self.partialFreezeManager, kQNUploadServerFreezeManager]];
        if (server) {
           break;
        }
    }
    if (server == nil && !self.hasGot && hostList.count > 0) {
        NSInteger index = arc4random()%hostList.count;
        NSString *host = hostList[index];
        server = [domainInfo[host] getOneServer];
    }
    self.hasGot = true;
    if (server == nil) {
        self.isAllFrozen = YES;
    }
    return server;
}

- (QNUploadServerFreezeManager *)partialFreezeManager{
    if (!_partialFreezeManager) {
        _partialFreezeManager = [[QNUploadServerFreezeManager alloc] init];
    }
    return _partialFreezeManager;
}

@end
