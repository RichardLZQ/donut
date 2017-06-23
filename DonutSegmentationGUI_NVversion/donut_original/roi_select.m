function [ slice, refslice ] = roi_select( slice, refslice , vsExpParam, bRef)
% Calls roi select function from vsExpParam
%   Load cells if bwcells already exists

% Default functions
% pDefault = struct('volOneFn',@celldetectmodgui,...
%     'volTwoPlusFn', @rois_shift);
pDefault = struct('volOneFn',@donut_select,...
    'volTwoPlusFn', @rois_shift);

roip = checkDefaultFields(vsExpParam.roi, pDefault);
volOneFn = roip.volOneFn;
volTwoPlusFn = roip.volTwoPlusFn;

% Determines if rois have been already selected 
vcFieldNames = fields(slice);
bExistCellsField = any(ismember('bwcells',vcFieldNames));

% get ROIs
if bRef
    disp(' ');
    disp('ROI Select');
    if ~bExistCellsField
        regp = vsExpParam.reg;
        reg = importregistered_slice(fullfile(regp.targetDir,slice.regraw),...
            slice.x_pixels,slice.y_pixels,...
            slice.frame_count,slice.channel);
        % function call to select rois
%         slice.bwcells = (volOneFn(slice.regavg))'; close(gcf);
            slice.bwcells = (volOneFn(reg));
    else
        display pre-selecteted rois
        slice.bwcells = (volOneFn(slice.regavg, slice.bwcells'))'; close(gcf);
    end
    [lbl_mask,~] = bwlabel(slice.bwcells);
    slice.new_lbl_mask = lbl_mask;
    refslice = slice;
else
    slice.bwcells = refslice.bwcells;
%     % mayabe add another flag to decide if shifting is desired
%     if bExistCellsField 
%         disp('ROI Shifting... ');
%         [slice.new_lbl_mask, slice.merged_rois, slice.wrois] =...
%             volTwoPlusFn(slice,refslice,vsExpParam);
%     end
end

% disp('End of ROI fn');
end

