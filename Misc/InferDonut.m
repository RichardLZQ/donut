%% Load files and register
xDim=256;
yDim=256;
nFrame=938;

FilePath='C:\Users\Ko Ho\Desktop\GCaMP6Axon.tif';
ImRaw=permute(max(squeeze(loadmultitif(FilePath,nFrame)),0),[2 1 3]);


% FilePath='C:\Users\Ko Ho\Desktop\(20140120_16_00_49)-_natural_LNC2_region1_movie_30s_10frbaseline.tif';
% ImRaw=permute(max(squeeze(loadmultitif(FilePath,nFrame)),0),[2 1 3]);

FilePath='C:\Users\Ko Ho\Dropbox\koho\anaesthetised\Data\(20140120_16_00_49)-_natural_LNC2_region1_movie_30s_10frbaseline\(20140120_16_00_49)-_natural_LNC2_region1_movie_30s_10frbaseline.raw';
ImRaw=importraw(FilePath,xDim,yDim,nFrame,'first');
ImRaw=max(reshape(ImRaw,xDim,yDim,nFrame),0);

ImReg_JK=ImRaw;
ImRef=mean(ImReg_JK,3);
[ImReg_JK]=correctstackv16r(ImReg_JK,ImRef,16,1/10);

%% Display raw and registered images
figure;
for ii=1:nFrame
    subplot(1,2,1);
    ImTemp=zeros(xDim,yDim,3);
    ImTemp(:,:,1)=NormIm(ImRef)';
    ImTemp(:,:,2)=NormIm(ImRaw(:,:,ii))';
    image(ImTemp);
    colormap gray
    daspect([1 1 1]);
    
    subplot(1,2,2);
    ImTemp=zeros(xDim,yDim,3);
    ImTemp(:,:,1)=NormIm(ImRef)';
    ImTemp(:,:,2)=NormIm(ImReg_JK(:,:,ii))';
    image(ImTemp);
    colormap gray
    daspect([1 1 1]);

    pause(1/20);
end

%% Save raw and registered as tiff
SaveAs32BitTiff(ImReg_JK,'ImReg_JK');
SaveAs32BitTiff(ImRaw,'ImRaw');

%% Extract ROIs

% Load processed image
load GCaMP6DataAnesSoma_JK16e-1.mat
% Load model parameters
load GCaMP6_ModelHausserNew.mat
%Infer donuts
ImRef_JK=mean(ImReg_JK,3);
% ImRef_JK=regavgsGcamp6{1,1};
ops.Nextract=0;
sig=[1.2 1.5];
[elem,NormImg]=run_inference(ImRef_JK,model,ops,sig);

% Rotate basis
ix=elem.ix(elem.map==1,1);
iy=elem.iy(elem.map==1,1);
FullBasis=cell(size(model.W,3),4);
for jj=1:size(FullBasis,1)
    for kk=1:4
        FullBasis{jj,kk}=rot90(model.W(:,:,jj),kk+3);
    end
end

BasSze=size(model.W);
HlfWid=floor(size(model.W,1)/2);
ImPatch=cell(1,size(ix,1));
ImPatch_Raw=cell(1,size(ix,1));
ImPatch_Norm=cell(1,size(ix,1));
ImPatchRec=cell(1,size(ix,1));

UseFullBasis=1;
for ii=1:size(ix,1)
        % Crop out the cell
        xL=max(ix(ii,1)-HlfWid,1);
        xR=min(ix(ii,1)+HlfWid,xDim);
        yL=max(iy(ii,1)-HlfWid,1);
        yR=min(iy(ii,1)+HlfWid,yDim);
        ImPatch_Raw{1,ii}=ImRef_JK(xL:xR,yL:yR);
        ImPatch_Norm{1,ii}=NormImg(xL:xR,yL:yR);
        ImPatch{1,ii}=ImPatch_Norm{1,ii};
        if (ix(ii,1)-HlfWid>=1) && (ix(ii,1)+HlfWid<=xDim) && (iy(ii,1)-HlfWid>=1) && (iy(ii,1)+HlfWid<=yDim)
            % Reconstruct
            if UseFullBasis
                M=[ones(BasSze(1)*BasSze(2),1) FullBasis{1,1}(:) FullBasis{1,2}(:) FullBasis{1,3}(:) FullBasis{1,4}(:)...
                    FullBasis{2,1}(:) FullBasis{2,2}(:) FullBasis{2,3}(:) FullBasis{2,4}(:)...
                    FullBasis{3,1}(:) FullBasis{3,2}(:) FullBasis{3,3}(:) FullBasis{3,4}(:)];
            else
                M=[ones(BasSze(1)*BasSze(2),1) FullBasis{1,1}(:) FullBasis{2,1}(:) FullBasis{3,1}(:)];
            end
            c=M\ImPatch{1,ii}(:);
            ImPatchRec{1,ii}=reshape(M*c,BasSze(1),BasSze(2));
        else
            % Find size reduction
            SzePad=zeros(2,2);
            SzePad(1,1)=max(1-(ix(ii,1)-HlfWid),0);
            SzePad(1,2)=max((ix(ii,1)+HlfWid)-xDim,0);
            SzePad(2,1)=max(1-(iy(ii,1)-HlfWid),0);
            SzePad(2,2)=max((iy(ii,1)+HlfWid)-xDim,0);
            % Use smaller bases
            for jj=1:size(model.W,3)
                for kk=1:4
                    PartBasis{jj,kk}=rot90(model.W(SzePad(1,1)+1:end-SzePad(1,2),SzePad(2,1)+1:end-SzePad(2,2),jj),kk);
                end
            end
            PartBasis{1,1}=model.W(SzePad(1,1)+1:end-SzePad(1,2),SzePad(2,1)+1:end-SzePad(2,2),1);
            PartBasis{1,2}=model.W(SzePad(1,1)+1:end-SzePad(1,2),SzePad(2,1)+1:end-SzePad(2,2),2);
            PartBasis{1,3}=model.W(SzePad(1,1)+1:end-SzePad(1,2),SzePad(2,1)+1:end-SzePad(2,2),3);
            PartBasSze=size(PartBasis{1,1});
            % Reconstruct
            if UseFullBasis
                M=[ones(PartBasSze(1)*PartBasSze(2),1) PartBasis{1,1}(:) PartBasis{1,2}(:) PartBasis{1,3}(:) PartBasis{1,4}(:)...
                    PartBasis{2,1}(:) PartBasis{2,2}(:) PartBasis{2,3}(:) PartBasis{2,4}(:)...
                    PartBasis{3,1}(:) PartBasis{3,2}(:) PartBasis{3,3}(:) PartBasis{3,4}(:)];
            else
                M=[ones(PartBasSze(1)*PartBasSze(2),1) PartBasis{1,1}(:) PartBasis{2,1}(:) PartBasis{3,1}(:)];
            end
            c=M\ImPatch{1,ii}(:);
            ImPatchRec{1,ii}=reshape(M*c,PartBasSze(1),PartBasSze(2));
        end
end

%% Creating masks
figure;
[rr cc]=meshgrid(1:15);
C1=sqrt((rr-8).^2+(cc-8).^2)<=3;
C2=sqrt((rr-8).^2+(cc-8).^2)<=7;
R=C2-C1;
Threshold=0.6;
se=strel('disk',1);
for ii=1:size(ix,1)
    subplot(12,18,2*ii-1);
    imagesc(ImPatch_Raw{1,ii});
    axis off
    daspect([1 1 1]);
    title(num2str(ii));
    subplot(12,18,2*ii);
    imagesc(ImPatchRec{1,ii});
    Mask=NormIm(ImPatchRec{1,ii})>Threshold;
    Mask=bwmorph(Mask,'bridge');
    Mask=bwmorph(Mask,'fill');
    while sum((Mask(:)>Threshold))<40
        Mask=imdilate(Mask,se);
    end
    Mask=bwareaopen(Mask,20,4);
    Mask=bwmorph(Mask,'diag');
    Mask=bwmorph(Mask,'spur');
    if sum((Mask(:)>Threshold))>110
        if size(Mask,1)*size(Mask,2)==225
            Mask=Mask.*R;
        else
            % Find size reduction
            SzePad=zeros(2,2);
            SzePad(1,1)=max(1-(ix(ii,1)-HlfWid),0);
            SzePad(1,2)=max((ix(ii,1)+HlfWid)-xDim,0);
            SzePad(2,1)=max(1-(iy(ii,1)-HlfWid),0);
            SzePad(2,2)=max((iy(ii,1)+HlfWid)-xDim,0);
            
            Mask=Mask.*R(SzePad(1,1)+1:end-SzePad(1,2),SzePad(2,1)+1:end-SzePad(2,2));
        end
    else
        if size(Mask,1)*size(Mask,2)==225
            Mask=Mask.*C2;
        else
            % Find size reduction
            SzePad=zeros(2,2);
            SzePad(1,1)=max(1-(ix(ii,1)-HlfWid),0);
            SzePad(1,2)=max((ix(ii,1)+HlfWid)-xDim,0);
            SzePad(2,1)=max(1-(iy(ii,1)-HlfWid),0);
            SzePad(2,2)=max((iy(ii,1)+HlfWid)-xDim,0);
            
            Mask=Mask.*C2(SzePad(1,1)+1:end-SzePad(1,2),SzePad(2,1)+1:end-SzePad(2,2));
        end
    end
    imagesc(Mask);
    axis off
    title(num2str(sum(Mask(:))));
    daspect([1 1 1]);
    MaskAll{1,ii}=Mask;
end

% figure;
% Threshold=0.6;
% LblMask=zeros(size(ImRef_JK));
% for ii=1:size(ix,1)
%     
%     Mask=NormIm(ImPatchRec{1,ii})>Threshold;
%     Mask=bwmorph(Mask,'bridge');
%     Mask=bwmorph(Mask,'fill');
%     while sum((Mask(:)>Threshold))<40
%         Mask=imdilate(Mask,se);
%     end
%     Mask=bwareaopen(Mask,20,4);
%     Mask=bwmorph(Mask,'diag');
%     Mask=bwmorph(Mask,'spur');
%     if size(Mask,1)*size(Mask,2)==225
%         Mask=Mask.*R;
%     end
%     
%     xL=max(ix(ii,1)-HlfWid,1);
%     xR=min(ix(ii,1)+HlfWid,xDim);
%     yL=max(iy(ii,1)-HlfWid,1);
%     yR=min(iy(ii,1)+HlfWid,yDim);
%     LblMask(xL:xR,yL:yR)=LblMask(xL:xR,yL:yR)+ii*Mask;
%     
%     subplot(10,14,ii);
%     imagesc(NormIm(ImPatch_Raw{1,ii}).*~bwperim(Mask));
%     axis off
%     colormap gray;
%     daspect([1 1 1]);
% end
% figure;
% imagesc(LblMask);
% daspect([1 1 1]);
% axis off
% for ii=1:size(ix,1)
%     text(iy(ii),ix(ii),num2str(ii));
% end
% 
% figure;
% imagesc((NormImg+abs(min(NormImg(:)))).*~bwperim(LblMask));
% colormap gray
% daspect([1,1,1]);

%% Separation of signals
CorrMtx=cell(1,1);
for ii=[8,36,37]
    figure;
%     subplot(8,10,ii);
    xL=max(ix(ii,1)-HlfWid,1);
    xR=min(ix(ii,1)+HlfWid,xDim);
    yL=max(iy(ii,1)-HlfWid,1);
    yR=min(iy(ii,1)+HlfWid,yDim);
    ImROIv=ImReg_JK(xL:xR,yL:yR,:);
    PxlTC=reshape(ImROIv,(xR-xL+1)*(yR-yL+1),[]);
    CorrMtx{1,ii}=corr(PxlTC');
end

[CNew{1,8},OrderNew{1,8}]=mtrx2tpz(CorrMtx{1,8},2000,5);
[CNew{1,36},OrderNew{1,36}]=mtrx2tpz(CorrMtx{1,36},2000,5);
[CNew{1,37},OrderNew{1,37}]=mtrx2tpz(CorrMtx{1,37},2000,5);

CorrMtx=cell(1,1);
for ii=37
    figure;
%     subplot(8,10,ii);
    xL=max(ix(ii,1)-HlfWid,1);
    xR=min(ix(ii,1)+HlfWid,xDim);
    yL=max(iy(ii,1)-HlfWid,1);
    yR=min(iy(ii,1)+HlfWid,yDim);
    ImROIv=ImReg_JK(xL:xR,yL:yR,:);
    PxlTC=reshape(ImROIv,(xR-xL+1)*(yR-yL+1),[]);
    CorrMtx{1,ii}=corr(PxlTC');
end

[CNew{1,15},OrderNew{1,15}]=mtrx2tpz(CorrMtx{1,15},2000,5);
[CNew{1,65},OrderNew{1,65}]=mtrx2tpz(CorrMtx{1,65},2000,5);
k=zeros(1,225);
for jj=1:225
    k(jj)=sum(OrderNew{1,65}(16:28)==jj)+sum(OrderNew{1,65}(105:165)==jj);
end
figure;
imagesc(reshape(k,15,15).*MaskAll{1,65});

%%
for ii=1:38
    xL=max(ix(ii,1)-HlfWid,1);
    xR=min(ix(ii,1)+HlfWid,xDim);
    yL=max(iy(ii,1)-HlfWid,1);
    yR=min(iy(ii,1)+HlfWid,yDim);
    ImROIv{1,ii}=ImReg_JK(xL:xR,yL:yR,:);
    [mixsig]=reshape(ImROIv{1,ii}-reshape(repmat(mean(ImROIv{1,ii},3),1,size(ImROIv{1,ii},3)),15,15,[]),225,470);
    mixsig_all{1,ii}=mixsig;
    [icasig{1,ii},Ma{1,ii},Mw{1,ii}]=fastica(mixsig,'lastEig',2,'numOfIC',2);
end

for kk=1:2
    figure;
    for ii=1:30
        subplot(6,10,2*ii-1);
        imagesc(reshape(Ma{1,ii}(:,kk)',15,15));
        daspect([1 1 1]);
        subplot(6,10,2*ii);
        imagesc(ImPatch_Raw{1,ii});
        daspect([1 1 1]);
    end
end