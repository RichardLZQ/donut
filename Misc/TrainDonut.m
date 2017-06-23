%% Load averaged images
clear all;
SclFactor=2.25;
KImSze=370;
KImHalfSze=floor(KImSze/2);
TrnImSze=round(KImSze/SclFactor);
TrnImHalfSze=floor(TrnImSze/2);
% 1. Hausser lab data
load('GCaMP6_AvgImHausser','y');
HImHalfSze=floor(size(y,1)/2);
y=y(HImHalfSze-TrnImHalfSze+1:HImHalfSze+TrnImHalfSze,...
    HImHalfSze-TrnImHalfSze+1:HImHalfSze+TrnImHalfSze,:);
% 2.Keller lab data
FilePath{1,1}='C:\Users\Ko Ho\Dropbox\My documents\Research\Matlab Programs\Own\GCaMP6\AlexData\Folder1\';
FilePath{1,2}='C:\Users\Ko Ho\Dropbox\My documents\Research\Matlab Programs\Own\GCaMP6\AlexData\Folder2\';
ImCount=size(y,3);
for ii=1:size(FilePath,2)
    FileList{1,ii}=dir(FilePath{1,ii});
    for jj=3:size(FileList{1,ii},1)
        ImCount=ImCount+1;
        yTemp=double(imread([FilePath{1,ii} FileList{1,ii}(jj,1).name]))';
        LImHalfSze=size(yTemp)/2;
        y(:,:,ImCount)=imresize(yTemp(LImHalfSze(1)-KImHalfSze+1:LImHalfSze(1)+KImHalfSze,...
            LImHalfSze(2)-KImHalfSze+1:LImHalfSze(2)+KImHalfSze),[TrnImSze TrnImSze]);
    end
end
save('GCaMP6_AvgImHausserKeller','y');
clc
%% Algorithm learning
clear all
ops.cell_diam       = 9;
ops.ex              = 10;
ops.cells_per_image = 100;
ops.NSS             = 1;
ops.KS              = 5;
ops.MP              = 0;
ops.inc             = 20;
ops.fig             = 1;
ops.learn           = 1;
ops.data_path       = 'C:\Users\Ko Ho\Dropbox\My documents\Research\Matlab Programs\Own\GCaMP6';
ops.code_location   = 'C:\Users\Ko Ho\Dropbox\My documents\Research\Matlab Programs\Own\GCaMP6\DonutCode\learning_module';

NormalizeFlag=1;
TrainingDataFileName = 'GCamp6_DataMFSoma8.mat';
ModelSaveFileName    = 'GCamp6_ModelMFSoma8.mat';

MPCC2_KSVD;