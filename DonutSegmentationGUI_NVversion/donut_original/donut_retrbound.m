function [xL,xR,yL,yR]=donut_retrbound(varargin)

global gh

CellNum=varargin{1,1};
if nargin==1
    HlfWidRetr=gh.param.HlfWid;
    SzeRetr(1)=gh.data.sze(1);
    SzeRetr(2)=gh.data.sze(2);
else
    HlfWidRetr=varargin{1,2};
    SzeRetr(1)=varargin{1,3};
    SzeRetr(2)=varargin{1,4};
end

xL=floor(max(gh.data.ix(CellNum,1)-HlfWidRetr,1));
xR=floor(min(gh.data.ix(CellNum,1)+HlfWidRetr,SzeRetr(1)));
yL=floor(max(gh.data.iy(CellNum,1)-HlfWidRetr,1));
yR=floor(min(gh.data.iy(CellNum,1)+HlfWidRetr,SzeRetr(2)));