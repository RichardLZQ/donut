function donut_loadfunc

global gh

[FileName,PathName]=uigetfile('*.*',  'All Files (*.*)');

if isequal(FileName,0) || isequal(PathName,0)
    return;
else
    FilePath=[PathName FileName];
end


donut_updateparam({'FilePath'},{FilePath});



switch get(gh.main.pop_loadtype,'value')
    case 1
        DataTemp=load(FilePath,'ImRaw');
    case 2
        ImRaw=ScanImageTiffReader(FilePath).data();
        Templen=size(ImRaw,3);
        tmpseq=1:2:Templen-1;
        DataTemp.ImRaw=ImRaw(:,:,tmpseq);
    case 3
        ImRaw=ScanImageTiffReader(FilePath).data();
        Templen=size(ImRaw,3);
        tmpseq=2:2:Templen;
        DataTemp.ImRaw=ImRaw(:,:,tmpseq);        
        
end
        



% gh.data.ImRaw=permute(DataTemp.ImRaw,[2 1 3]);
gh.data.ImRaw=single(DataTemp.ImRaw);
gh.data.ImRawAvg=mean(gh.data.ImRaw,3);
gh.data.ImRawMax=max(gh.data.ImRaw,[],3);
gh.param.InferFlag=0;
gh.data.ImReg=gh.data.ImRaw;

donut_disp;