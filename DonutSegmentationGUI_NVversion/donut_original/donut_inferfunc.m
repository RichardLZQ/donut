function donut_inferfunc(AddFlag)

global gh

if ~AddFlag
    
    switch get(gh.main.PopupMenuObjType,'value')
        case 1
              ModelTemp=load('GCaMP6_ModelMFSoma7.mat','model');
%             ModelTemp=load('GCamp6_ModelMFSoma8.mat','model');
%             ModelTemp=load('GCaMP6_ModelJasperAdilSoma13','model');
        case 2
            ModelTemp=load('GCaMP6_ModelMFBouton.mat','model');
    end
    
    gh.param.model=ModelTemp.model;
    sig=[gh.param.Sig1 gh.param.Sig2];
    
    gh.param.ModelHlfWid=floor(size(gh.param.model.W,1)/2);
    gh.param.ImSclFact=gh.param.HlfWid/gh.param.ModelHlfWid;

    if get(gh.main.ChckbxExcludeEdge,'Value')
        ImgPxlRangeX=1+gh.param.ExcludeEdgeNum:gh.data.sze(1)-gh.param.ExcludeEdgeNum;
        ImgPxlRangeY=1+gh.param.ExcludeEdgeNum:gh.data.sze(2)-gh.param.ExcludeEdgeNum;
        gh.param.ImSzeInfer=round([length(ImgPxlRangeX) length(ImgPxlRangeY)]/gh.param.ImSclFact);
    else
        ImgPxlRangeX=1:gh.data.sze(1);
        ImgPxlRangeY=1:gh.data.sze(2);
        gh.param.ImSzeInfer=round([gh.data.sze(1) gh.data.sze(2)]/gh.param.ImSclFact);
    end
    
    for ii=1:2
        if ii==1
            ops.Nextract=0;
        elseif ~(gh.param.Sensitivity==1)
            ops.Nextract=round(size(elem.ix(elem.map==1,1),1)*gh.param.Sensitivity);
        else
            break;
        end
        if get(gh.disp.ChckbxLKDisp,'Value')
            if gh.param.ImSclFact==1
                [elem,NormImg]=run_inference(gh.data.ImRegAvg(ImgPxlRangeX,ImgPxlRangeY),gh.param.model,ops,sig);
            else
                [elem,NormImg]=run_inference(imresize(gh.data.ImRegAvg(ImgPxlRangeX,ImgPxlRangeY),...
                    gh.param.ImSzeInfer),gh.param.model,ops,sig);
            end
        else
            if gh.param.ImSclFact==1
                [elem,NormImg]=run_inference(gh.data.ImRawAvg(ImgPxlRangeX,ImgPxlRangeY),gh.param.model,ops,sig);
            else
                [elem,NormImg]=run_inference(imresize(gh.data.ImRawAvg(ImgPxlRangeX,ImgPxlRangeY),...
                    gh.param.ImSzeInfer),gh.param.model,ops,sig);
            end
        end
%         if get(gh.disp.ChckbxLKDisp,'Value')
%             if gh.param.ImSclFact==1
%                 [elem,NormImg]=run_inference(gh.data.ImRegMax(ImgPxlRangeX,ImgPxlRangeY),gh.param.model,ops,sig);
%             else
%                 [elem,NormImg]=run_inference(imresize(gh.data.ImRegMax(ImgPxlRangeX,ImgPxlRangeY),...
%                     gh.param.ImSzeInfer),gh.param.model,ops,sig);
%             end
%         else
%             if gh.param.ImSclFact==1
%                 [elem,NormImg]=run_inference(gh.data.ImRawMax(ImgPxlRangeX,ImgPxlRangeY),gh.param.model,ops,sig);
%             else
%                 [elem,NormImg]=run_inference(imresize(gh.data.ImRawMax(ImgPxlRangeX,ImgPxlRangeY),...
%                     gh.param.ImSzeInfer),gh.param.model,ops,sig);
%             end
%         end
    end
    
    gh.data.ix=elem.ix(elem.map==1,1);
    gh.data.iy=elem.iy(elem.map==1,1);
    
    if get(gh.main.ChckbxExcludeEdge,'Value')
        
        gh.data.ix=gh.data.ix+round(gh.param.ExcludeEdgeNum/gh.param.ImSclFact);
        gh.data.iy=gh.data.iy+round(gh.param.ExcludeEdgeNum/gh.param.ImSclFact);
        
        gh.param.ImSzeInfer=round([gh.data.sze(1) gh.data.sze(2)]/gh.param.ImSclFact);
        
        if get(gh.disp.ChckbxLKDisp,'Value')
            if gh.param.ImSclFact==1
                NormImg=normal_img(gh.data.ImRegAvg,gh.param.Sig1,gh.param.Sig2);
            else
                NormImg=normal_img(imresize(gh.data.ImRegAvg,gh.param.ImSzeInfer),gh.param.Sig1,gh.param.Sig2);
            end
        else
            if gh.param.ImSclFact==1
                NormImg=normal_img(gh.data.ImRawAvg,gh.param.Sig1,gh.param.Sig2);
            else
                NormImg=normal_img(imresize(gh.data.ImRawAvg,gh.param.ImSzeInfer),gh.param.Sig1,gh.param.Sig2);
            end
        end
    end
    gh.data.NormImg=NormImg;
    gh.param.InferFlag=1;
    
    %Mask
    gh.data.InitLblMask=zeros(gh.param.ImSzeInfer);
    gh.data.LblMask=zeros(size(gh.data.ImRawAvg));
    gh.data.LblMaskI=zeros(size(gh.data.ImRawAvg));
    gh.data.LblMaskM=zeros(size(gh.data.ImRawAvg));

    StartNum=1;
else
    StartNum=size(gh.data.ix,1);
end

FullBasis=cell(size(gh.param.model.W,3),4);
for jj=1:size(FullBasis,1)
    for kk=1:4
        FullBasis{jj,kk}=rot90(gh.param.model.W(:,:,jj),kk+3);
    end
end

BasSze=size(gh.param.model.W);

ImPatch=cell(1,size(gh.data.ix,1));
ImPatch_Rec=cell(1,size(gh.data.ix,1));

UseFullBasis=~get(gh.disp.ChckbxRegularizeMask,'Value');
for ii=StartNum:size(gh.data.ix,1)
    % Crop out the cell
    [xL,xR,yL,yR]=donut_retrbound(ii,gh.param.ModelHlfWid,gh.param.ImSzeInfer(1,1),gh.param.ImSzeInfer(1,2));
    
    ImPatch{1,ii}=gh.data.NormImg(xL:xR,yL:yR);
        
        if (gh.data.ix(ii,1)-gh.param.ModelHlfWid>=1) && (gh.data.ix(ii,1)+gh.param.ModelHlfWid<=gh.param.ImSzeInfer(1,1)) &&...
                (gh.data.iy(ii,1)-gh.param.ModelHlfWid>=1) && (gh.data.iy(ii,1)+gh.param.ModelHlfWid<=gh.param.ImSzeInfer(1,2))
            % Reconstruct
            if UseFullBasis
                M=[ones(BasSze(1)*BasSze(2),1) FullBasis{1,1}(:) FullBasis{1,2}(:) FullBasis{1,3}(:) FullBasis{1,4}(:)...
                    FullBasis{2,1}(:) FullBasis{2,2}(:) FullBasis{2,3}(:) FullBasis{2,4}(:)...
                    FullBasis{3,1}(:) FullBasis{3,2}(:) FullBasis{3,3}(:) FullBasis{3,4}(:)];
            else
                M=[ones(BasSze(1)*BasSze(2),1) FullBasis{1,1}(:) FullBasis{2,1}(:) FullBasis{3,1}(:) FullBasis{4,1}(:) FullBasis{5,1}(:)];
            end
            c=M\ImPatch{1,ii}(:);
            ImPatch_Rec{1,ii}=reshape(M*c,BasSze(1),BasSze(2));
        else
            % Find size reduction
            SzePad=zeros(2,2);
            SzePad(1,1)=max(1-(gh.data.ix(ii,1)-gh.param.ModelHlfWid),0);
            SzePad(1,2)=max((gh.data.ix(ii,1)+gh.param.ModelHlfWid)-gh.param.ImSzeInfer(1,1),0);
            SzePad(2,1)=max(1-(gh.data.iy(ii,1)-gh.param.ModelHlfWid),0);
            SzePad(2,2)=max((gh.data.iy(ii,1)+gh.param.ModelHlfWid)-gh.param.ImSzeInfer(1,2),0);
            
            % Use smaller bases
            for jj=1:size(gh.param.model.W,3)
                for kk=1:4
                    PartBasis{jj,kk}=rot90(gh.param.model.W(SzePad(1,1)+1:end-SzePad(1,2),SzePad(2,1)+1:end-SzePad(2,2),jj),kk);
                end
            end
            PartBasis{1,1}=gh.param.model.W(SzePad(1,1)+1:end-SzePad(1,2),SzePad(2,1)+1:end-SzePad(2,2),1);
            PartBasis{1,2}=gh.param.model.W(SzePad(1,1)+1:end-SzePad(1,2),SzePad(2,1)+1:end-SzePad(2,2),2);
            PartBasis{1,3}=gh.param.model.W(SzePad(1,1)+1:end-SzePad(1,2),SzePad(2,1)+1:end-SzePad(2,2),3);
            PartBasis{1,4}=gh.param.model.W(SzePad(1,1)+1:end-SzePad(1,2),SzePad(2,1)+1:end-SzePad(2,2),4);
            PartBasis{1,5}=gh.param.model.W(SzePad(1,1)+1:end-SzePad(1,2),SzePad(2,1)+1:end-SzePad(2,2),5);
            PartBasSze=size(PartBasis{1,1});
            
            % Reconstruct
            if UseFullBasis
                M=[ones(PartBasSze(1)*PartBasSze(2),1) PartBasis{1,1}(:) PartBasis{1,2}(:) PartBasis{1,3}(:) PartBasis{1,4}(:)...
                    PartBasis{2,1}(:) PartBasis{2,2}(:) PartBasis{2,3}(:) PartBasis{2,4}(:)...
                    PartBasis{3,1}(:) PartBasis{3,2}(:) PartBasis{3,3}(:) PartBasis{3,4}(:)];
            else
                M=[ones(PartBasSze(1)*PartBasSze(2),1) PartBasis{1,1}(:) PartBasis{2,1}(:) PartBasis{3,1}(:) PartBasis{4,1}(:) PartBasis{5,1}(:)];
            end
            c=M\ImPatch{1,ii}(:);
            ImPatch_Rec{1,ii}=reshape(M*c,PartBasSze(1),PartBasSze(2));
        end
end

Threshold=0.7;

[rr cc]=meshgrid(1:2*gh.param.ModelHlfWid+1);
R_Circ1=sqrt((rr-gh.param.ModelHlfWid-1).^2+(cc-gh.param.ModelHlfWid-1).^2)<=(gh.param.ModelHlfWid);
se=strel('disk',1);

for ii=StartNum:size(gh.data.ix,1)

    Mask=NormIm(ImPatch_Rec{1,ii})>Threshold;
    Mask=bwmorph(Mask,'bridge');
    Mask=bwmorph(Mask,'fill');
    while sum((Mask(:)>Threshold))<(gh.param.ModelHlfWid^2)
        Mask=imdilate(Mask,se);
    end
    
    if get(gh.main.PopupMenuObjType,'value')==1
        Mask=bwareaopen(Mask,round(gh.param.ModelHlfWid^2/3),4);
        Mask=bwmorph(Mask,'diag');
        Mask=single(bwmorph(Mask,'spur'));
        if (size(Mask,1)==(2*gh.param.ModelHlfWid+1)) && (size(Mask,2)==(2*gh.param.ModelHlfWid+1))
            Mask=Mask.*R_Circ1;
            [Mask]=donut_convHullConnect(Mask,ii);
        end
    end
    
    [xL,xR,yL,yR]=donut_retrbound(ii,gh.param.ModelHlfWid,gh.param.ImSzeInfer(1,1),gh.param.ImSzeInfer(1,2));
    gh.data.InitLblMask(xL:xR,yL:yR)=max(gh.data.InitLblMask(xL:xR,yL:yR),ii*Mask);
end

if ~(gh.param.ImSclFact==1)
    gh.data.ix(StartNum:size(gh.data.ix,1),1)=round(gh.data.ix(StartNum:size(gh.data.ix,1),1)*gh.param.ImSclFact);
    gh.data.iy(StartNum:size(gh.data.ix,1),1)=round(gh.data.iy(StartNum:size(gh.data.ix,1),1)*gh.param.ImSclFact);
    gh.data.LblMask=imresize(gh.data.InitLblMask,size(gh.data.ImRawAvg),'nearest');
else
    gh.data.LblMask=gh.data.InitLblMask;
end

% Breaking ROIs
for ii=StartNum:size(gh.data.ix,1)
    gh.data.LblMask=gh.data.LblMask.*~((gh.data.LblMask==ii)-bwareaopen(gh.data.LblMask==ii,round(gh.param.HlfWid^2/4),4));
end
[gh.data.LblMask]=donut_breakROIfunc(gh.data.LblMask,gh.data.LblMask);

donut_dispdrawfunc;