function donut_initialization(GUI)

global gh

switch GUI
    case 'main'
        InitParamList   = {'NumParam';      'ConvCret';     'NumLoop';                                          ...
                           'Sensitivity';   'Sig1';         'Sig2';         'HlfWid';       'ExcludeEdgeNum';   ...
                           'NumPC';         'NumIC';        'InclCret';     'ClusterCutoff';                    ...
                           'CretCorr0';     'CretCorr1';    'CretCorr2';    'NumRing'};
        InitParamValue  = {16;              10;             20;                                                 ...
                           1;               1.2;            1.5;            7;              5;                  ...
                           2;               2;              10;             1.5;                                ...
                           0.4;             0.25;           0.8;            1};
        InitSliderValue = {16;              10;             20;                                                 ...
                           10;              12;             15;             7;              5;                  ...
                           2;               2;              10;             15;                                 ...
                           40;              25;             80;             1};
        InitSliderStep  = {64;              100;            100;                                                ...
                           100;             500;            800;            100;            50;                 ...
                           30;              30;             100;            200;                                ...
                           100;             100;            100;            20};
        InitSclFact     = {1;               1;              1;                                                  ...
                           10;              10;             10;             1;              1;                  ...
                           1;               1;              1;              10;                                 ...
                           100;             100;            100;            1};
                       
        donut_updateparam(InitParamList,InitParamValue);
        donut_setsliderfunc(InitParamList,InitSliderValue,InitSliderStep);
                       
        for ii=1:length(InitParamList)
            eval(['gh.param.SclFact' InitParamList{ii,1} '=' num2str(InitSclFact{ii,1}) ';']);
            eval(['gh.param.MaxValue' InitParamList{ii,1} '=' num2str(InitSliderStep{ii,1}) ';']);
        end
        
        gh.param.InferFlag=0;
        gh.param.ICAFlag=0;
        gh.param.ClusterFlag=0;
        
        gh.main.opened=1;
        gh.disp.opened=0;
        
    case 'disp'
        gh.data.sze=size(gh.data.ImRaw);
        gh.data.nFrame=gh.data.sze(3);
        gh.data.cFrame=1;
        gh.data.cMax=1;
        gh.data.cMin=0;
        gh.data.Gamma=1;
        gh.data.cSlice=zeros(gh.data.sze(1),gh.data.sze(2),3);
        
        set(gh.disp.TextNFrame,'String',num2str(gh.data.nFrame));
        set(gh.disp.SliderMain,'Value',0, 'SliderStep',[1/(gh.data.nFrame-1) 0.1]);
        
        gh.disp.ih=image(zeros(1,1,3),'Parent',gh.disp.AxesMain);
        set(gh.disp.ih,'ButtonDownFcn',@donut_axesfunc);
        daspect([1 1 1]);
        set(gh.disp.AxesMain,'XLim',[1,gh.data.sze(1)],'YLim',[1,gh.data.sze(2)]);
    
        gh.disp.opened=1;
        gh.param.CurrentCellNum=0;
                
%         % for marking vessels
        gh.data.LblMaskV=zeros(size(gh.data.ImRawAvg));
        gh.data.vess_ix=[];
        gh.data.vess_iy=[];
        
        donut_dispdrawfunc;
end