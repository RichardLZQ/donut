function donut_dispdrawfunc

global gh

% if ~get(gh.disp.ChckbxDispAvg,'Value')
%     if ~get(gh.disp.ChckbxLKDisp,'Value')
%         ImTemp=donut_adjustcontrast(NormIm(gh.data.ImRaw(:,:,gh.data.cFrame)),gh.data.cMin,gh.data.cMax);
%     else
%         ImTemp=donut_adjustcontrast(NormIm(gh.data.ImReg(:,:,gh.data.cFrame)),gh.data.cMin,gh.data.cMax);
%     end
% else
%     if ~get(gh.disp.ChckbxLKDisp,'Value')
%         ImTemp=donut_adjustcontrast(NormIm(gh.data.ImRawAvg),gh.data.cMin,gh.data.cMax);
%     else
%         ImTemp=donut_adjustcontrast(NormIm(gh.data.ImRegAvg),gh.data.cMin,gh.data.cMax);
%     end
% end
if ~get(gh.disp.ChckbxLKDisp,'Value')
    switch get(gh.disp.MenuDisp,'Value')
        case 1
            ImTemp=gh.data.ImRaw(:,:,gh.data.cFrame);   
        case 2
            ImTemp=gh.data.ImRawAvg;
        case 3
            ImTemp=gh.data.ImRawMax;
    end
else
    switch get(gh.disp.MenuDisp,'Value')
        case 1
            ImTemp=gh.data.ImReg(:,:,gh.data.cFrame);
        case 2
            ImTemp=gh.data.ImRegAvg;
        case 3
            ImTemp=gh.data.ImRegMax;
    end
end
ImCLimGamma=[gh.data.cMin,gh.data.cMax,gh.data.Gamma];
ImTemp=donut_adjustcontrast(ImTemp,ImCLimGamma);
gh.data.cSlice=repmat(ImTemp,[1 1 3]);

if get(gh.disp.ChckbxDispCluster,'Value') && gh.param.ClusterFlag
    alpha=repmat(0.35*(gh.data.LblMaskC>0),[1 1 3]);
    MaskLabel=single(label2rgb(gh.data.LblMaskC)/255);
    gh.data.cSlice=((1-alpha).*gh.data.cSlice)+(alpha.*MaskLabel);
else
    if gh.param.InferFlag
        if get(gh.disp.ChckbxDispSF,'Value');
            if get(gh.disp.ChckbxDispSFIC,'Value');
                
                if get(gh.disp.ChckbxDispLine,'Value')
                    alpha=repmat(0.35*((gh.data.LblMaskI+gh.data.LblMaskM+gh.data.LblMaskV)>0),[1 1 3]);
                    MaskLabel=single(label2rgb((gh.data.LblMaskI>0)+2*(gh.data.LblMaskM>0)+3*(gh.data.LblMaskV>0),[0 1 0;0 0 1;1 0 0])/255);
                else
                    alpha=repmat(0.35*((gh.data.LblMaskI+gh.data.LblMaskM)>0),[1 1 3]);
                    MaskLabel=single(label2rgb((gh.data.LblMaskI>0)+2*(gh.data.LblMaskM>0),[0 1 0;0 0 1])/255);
                end
                gh.data.cSlice=((1-alpha).*gh.data.cSlice)+(alpha.*MaskLabel);
            else
                if get(gh.disp.ChckbxDispLine,'Value')
                    alpha=repmat(0.35*((gh.data.LblMask+gh.data.LblMaskV)>0),[1 1 3]);
                    MaskLabel=single(label2rgb((gh.data.LblMask>0)+2*(gh.data.LblMaskV>0),[0 0 1;1 0 0])/255);
                else
                    alpha=repmat(0.35*(gh.data.LblMask>0),[1 1 3]);
                    MaskLabel=single(label2rgb(gh.data.LblMask>0,[0 0 1])/255);
                end
                gh.data.cSlice=((1-alpha).*gh.data.cSlice)+(alpha.*MaskLabel);
            end
        end
    else
        if get(gh.disp.ChckbxDispLine,'Value')
            alpha=repmat(0.35*(gh.data.LblMaskV>0),[1 1 3]);
            MaskLabel=single(label2rgb((gh.data.LblMaskV>0),[1 0 0])/255);
            gh.data.cSlice=((1-alpha).*gh.data.cSlice)+(alpha.*MaskLabel);
        end
    end
end

set(gh.disp.ih,'CDATA',gh.data.cSlice);

if myIsField(gh.disp,'TextH')
    if size(gh.disp.TextH,1)>=1
        NumMasks=size(gh.disp.TextH,2);
        for ii=1:NumMasks
            delete(gh.disp.TextH{1,NumMasks-ii+1});
            gh.disp.TextH=CellRemoveEmpty(gh.disp.TextH,NumMasks-ii+1);
        end
    end
end
if get(gh.disp.ChckbxDispMaskNum,'Value')
    for ii=1:size(gh.data.ix,1)
        if ii==gh.param.CurrentCellNum
            C=0.9*[0 1 0];
        else
            C=0.8*[1 1 1];
        end
        if ~get(gh.disp.ChckbxDispCluster,'Value')
            gh.disp.TextH{1,ii}=text(gh.data.iy(ii),gh.data.ix(ii),num2str(ii),'Parent',gh.disp.AxesMain,'color',C);
        elseif ii<=size(gh.data.groups,1)
            gh.disp.TextH{1,ii}=text(gh.data.iy(ii),gh.data.ix(ii),num2str(gh.data.groups(ii)),'Parent',gh.disp.AxesMain,'color',C);
        end
    end
end