//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

#import "___FILEBASENAME___.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UIViewController+NiuNiu.h"
#import "UITableView+NiuNiuQiChe.h"
#import "NNRefreshWheelHeader.h"
#import "NNViewModelProtocol.h"
#import "NNNoDataView.h"
#import "MJRefresh.h"

@interface ___FILEBASENAMEASIDENTIFIER___ ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NNNoDataView *nodataView;
@property (nonatomic, strong) NSMutableArray *dataArray;
// cell种类多时，建议用cellIdentifiers拼装，如cell类型单一可不用该属性；
@property (nonatomic, strong) NSMutableArray *cellIdentifiers;
@end

@implementation ___FILEBASENAMEASIDENTIFIER___


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.dataArray.count) {
        [self showRingLoadingDefault];
    }
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.top = 0.f;
    self.tableView.size = self.view.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self dismissRingLoading];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Network

- (void)loadData {
    self.pageNum = 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [self requestDataWithParams:params isLoadMore:NO];
}

- (void)loadMoreData {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [self requestDataWithParams:params isLoadMore:YES];
}

- (void)requestDataWithParams:(NSMutableDictionary *)params isLoadMore:(BOOL)isLoadMore {
    @weakify(self);
    [API requestWithName:APIMyChatGroups
              parameters:params
          viewController:self
          loadingMessage:nil
                   modal:YES
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     @strongify(self);
                     [self dismissRingLoading];
                     JSONResponseBase *respond = responseObject;
                     if (respond.isSuccess) {
                         [self handleWithResponsData:respond isLoadMore:isLoadMore];
                         [self showSuccessMsg:respond.message thenDefaultMsg:nil];
                     } else {
                         [self showErrorMsg:respond.message thenDefaultMsg:nil];
                     }
                 } completion:^(AFHTTPRequestOperation *operation) {
                     [self handleWithCompletion];
                 }];
}

- (void)handleWithResponsData:(JSONResponseBase *)respond isLoadMore:(BOOL)isLoadMore {
    self.pageNum ++;
    if (isLoadMore) {

    } else {
        
    }
    [self buildCellIdentifiers];
}

- (void)handleWithCompletion {
    [self dismissRingLoading];
    [self handleMJHeaderFooter];
    [self handleWithNoDataView];
    [self.tableView reloadData];

}

- (void)handleWithNoDataView {
    self.nodataView.hidden = self.cellIdentifiers.count;
    self.tableView.hidden = !self.cellIdentifiers.count;
}

- (void)handleMJHeaderFooter {
    [self endMJRefreshing];
    [self updateMJFooterState];
}

-(void)updateMJFooterState {
    
}


#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 根据页面实际情况选择return dataArray.count 或 cellIdentifiers.count 或固定数值
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellIdentifiers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = self.cellIdentifiers[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    //配置cell需要的属性 (不影响高度计算)
    if ([reuseIdentifier isEqualToString:NSStringFromClass([UITableViewCell class])]) {
        
    } else if ([reuseIdentifier isEqualToString:NSStringFromClass([UITableViewCell class])]) {
        
    }
    
    //渲染数据，用于计算高度
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(configureViewWithModel:)]) {
        id model = self.dataArray[indexPath.row];
        [(UITableViewCell<NNViewModelProtocol> *)cell configureViewWithModel:model];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = self.cellIdentifiers[indexPath.row];
    CGFloat height = 0.f;
    if ([reuseIdentifier isEqualToString:NSStringFromClass([UITableViewCell class])]) {
        height = 100.f;
    } else {
        height = [tableView fd_heightForCellWithIdentifier:reuseIdentifier
                                          cacheByIndexPath:indexPath
                                             configuration:^(id cell)
        {
            [self configureCell:cell forRowAtIndexPath:indexPath];
        }];
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}


#pragma mark - Private Methods

- (void)buildCellIdentifiers {
    
}


#pragma mark - Setup

- (void)setup {
    [self setupData];
    [self setupUI];
}

- (void)setupData {
    [self loadData];
}

- (void)setupUI {
    [self setupNavigationBar];
    [self setupTableview];
    [self setupNodataView];
}

- (void)setupNavigationBar {
    
}

- (void)setupTableview {
    [self.view addSubview:self.tableView];
    @weakify(self);
    self.tableView.mj_header = [NNRefreshWheelHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.tableView.mj_footer resetNoMoreData];
        [self loadData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
}

- (void)setupNodataView {
    [self.view addSubview:self.nodataView];
}

- (void)endMJRefreshing {
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
}


#pragma mark - Setter & Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        [_tableView registerCellNibFileName:[UITableViewCell class]];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (NSMutableArray *)cellIdentifiers {
    if (!_cellIdentifiers) {
        _cellIdentifiers = [NSMutableArray arrayWithCapacity:0];
    }
    return _cellIdentifiers;
}

- (NNNoDataView *)nodataView {
    if (!_nodataView) {
        _nodataView = [NNNoDataView noDataViewWithType:NNNoDatasViewTypeRecommendSearchCar];
        _nodataView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _nodataView.top = 85.f * ScreenWidth / 375.0 + 82;
    }
    return _nodataView;
}

@end
