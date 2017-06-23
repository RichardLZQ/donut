function [Mask]=donut_convHullConnect(Mask,ii)

% [L,NumReg]=bwlabel(Mask);
% if  NumReg>1
%     fprintf('%s\n',['ROI ' num2str(ii) ' fragmented and modified.']);
    MaskJt=bwconvhull(Mask);
    dr=double(floor(sqrt(sum(sum(MaskJt))/pi)-sqrt(sum(sum(MaskJt-Mask))/pi)/2));
    seJt=strel('disk',dr);
    MaskJt=MaskJt-imerode(MaskJt,seJt);
    Mask=(Mask+MaskJt)>0;
% end