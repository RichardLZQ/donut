function [stack,filename]=ldmultitif(loadfilename,nframes)

if nargin<1;
    [filename,pathname]=uigetfile('*.tif;*.tiff', 'Select MultiTif');
    loadfilename=[pathname filename];
end

imgdetails=imfinfo(loadfilename);
if nargin<2;
    nframes=length(imgdetails);
end
bitdepth=imgdetails(1,1).BitDepth/imgdetails(1,1).SamplesPerPixel;
if bitdepth==32;
    stack=zeros(imgdetails(1,1).Height,imgdetails(1,1).Width,imgdetails(1,1).SamplesPerPixel,nframes, 'single');
else
    stack=zeros(imgdetails(1,1).Height,imgdetails(1,1).Width,imgdetails(1,1).SamplesPerPixel,nframes, ...
        ['uint' num2str(bitdepth)]);
end
for i=1:nframes
    stack(:,:,:,i)=imread(loadfilename,i);
end

end
