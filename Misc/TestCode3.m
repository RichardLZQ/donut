% figure;
% imagesc(gh.data.MaskPatchFin{1,ii})
global gh
ii=64

HlfWid=floor(size(gh.param.model.W,1)/2);
xL=floor(max(gh.data.ix(ii,1)-HlfWid,1));
        xR=floor(min(gh.data.ix(ii,1)+HlfWid,gh.data.sze(1)));
        yL=floor(max(gh.data.iy(ii,1)-HlfWid,1));
        yR=floor(min(gh.data.iy(ii,1)+HlfWid,gh.data.sze(2)));

se=strel('disk',3);
MaskPatchFinDil{1,ii}=imdilate(gh.data.MaskPatchFin{1,ii},se);

if get(gh.main.ChckbxInferReg,'Value')
    ImROIv{1,ii}=gh.data.ImReg(xL:xR,yL:yR,:);
else
    ImROIv{1,ii}=gh.data.ImRaw(xL:xR,yL:yR,:);
end
[mixsig]=reshape(ImROIv{1,ii},(xR-xL+1)*(yR-yL+1),gh.data.sze(3));
corrMat=corr([mixsig' gh.data.dFoF(ii,:)']);


figure;
plot(mixsig(sub2ind([15 15],8,12),:));
hold on;
plot(gh.data.dFoF(ii,:),'r');

figure;
subplot(1,2,1);
imagesc(reshape(corrMat(226,1:225),(xR-xL+1),(yR-yL+1)));
subplot(1,2,2);
imagesc(reshape(corrMat(226,1:225),(xR-xL+1),(yR-yL+1)).*(MaskPatchFinDil{1,ii}-gh.data.MaskPatchFin{1,ii})');

%     else
%         
%         corrMat=corr(mixsig');
%         dissimilarity=1-corrMat;
%         Z=linkage(dissimilarity,'complete');
%         groups=cluster(Z,'criterion','distance','MaxClust',3);
%         
%         for jj=1:3
%             MaskPatchBin{ii,jj}=(reshape(groups,xR-xL+1,yR-yL+1)==jj);
%             CRMtx=normxcorr2(MaskPatchBin{ii,jj},(gh.data.LblMask(xL:xR,yL:yR)==ii));
%             sze=size(CRMtx);
%             CR(ii,jj)=CRMtx(floor(sze(1)/2),floor(sze(2)/2));
%         end
%         
%         [gh.data.CRMax(1,ii),IdxMax]=max(CR(ii,:));
%         gh.data.MaskPatchFin{1,ii}=MaskPatchBin{ii,IdxMax};
%         
% %         corrMatAvg=mean(corrMat-eye(size(corrMat)),1);
% %         gh.data.MaskPatchFin{1,ii}=reshape(corrMatAvg-mean(corrMatAvg(:)),xR-xL+1,yR-yL+1);
% %         
%         gh.data.LblMaskI(xL:xR,yL:yR)=max(ii*gh.data.MaskPatchFin{1,ii},gh.data.LblMaskI(xL:xR,yL:yR));
%         gh.data.MaskType(1,ii)=1;
%         
%     end