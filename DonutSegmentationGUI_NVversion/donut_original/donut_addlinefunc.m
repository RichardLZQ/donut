function donut_addlinefunc(NewLineP)

global gh

if get(gh.disp.ChckbxLineStart,'Value')
    gh.data.vess_ix(end+1,1)=round(NewLineP(1));
    gh.data.vess_iy(end+1,1)=round(NewLineP(2));
    
    gh.data.LblMaskV(gh.data.vess_ix(end,1),gh.data.vess_iy(end,1)) = size(gh.data.vess_ix,1);
    
    set(gh.disp.ChckbxLineStart,'Value',0);
    set(gh.disp.ChckbxLineEnd,'Value',1);
else
    gh.data.vess_ix(end,2)=round(NewLineP(1));
    gh.data.vess_iy(end,2)=round(NewLineP(2));
    
    gh.data.LblMaskV(gh.data.vess_ix(end,2),gh.data.vess_iy(end,2)) = size(gh.data.vess_ix,1);
    
    %draw the line
    x = [gh.data.vess_ix(end,1) gh.data.vess_ix(end,2)];
    y = [gh.data.vess_iy(end,1) gh.data.vess_iy(end,2)];
    dx = gh.data.vess_ix(end,2)-gh.data.vess_ix(end,1);    
    dy = gh.data.vess_iy(end,2)-gh.data.vess_iy(end,1);
    m = dy/dx;
    for ii = 1:10
        gh.data.LblMaskV(round(gh.data.vess_ix(end,1) + ii*dx/10),...
            round(gh.data.vess_iy(end,1) + m*ii*dx/10)-1) = size(gh.data.vess_ix,1);
    end
    
    set(gh.disp.ChckbxLineStart,'Value',1);
    set(gh.disp.ChckbxLineEnd,'Value',0);
end

donut_dispdrawfunc;

