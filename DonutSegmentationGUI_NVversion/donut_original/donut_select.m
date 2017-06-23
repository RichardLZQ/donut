function [bwcells]=donut_select(ImRaw)

donut_main;
donut_loadfuncIoana(ImRaw);
[bwcells]=donut_disp;

global gh
panelliststr={'main';'disp'};
for ii=1:length(panelliststr)
    if eval(['gh.' panelliststr{ii,1} '.opened'])
        delete(eval(['gh.',panelliststr{ii,1},'.figure1']));
    end
end

gh.data=rmfield(gh.data,fieldnames(gh.data));
gh.param=rmfield(gh.param,fieldnames(gh.param));
gh.main=rmfield(gh.main,fieldnames(gh.main));
gh.disp=rmfield(gh.disp,fieldnames(gh.disp));