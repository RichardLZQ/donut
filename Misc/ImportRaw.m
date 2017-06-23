function a=importraw(filename,x,y,frames,channel)

a=single(zeros(x*y*frames,1));
fid=fopen(filename,'r','b');

switch channel
    case 'first'
        a=single(zeros(x*y,frames));
        for fr=1:frames
            a(:,fr)=fread(fid,prod([x y]),[num2str(prod([x y])) '*float32=>float32'],4*prod([x y]));
            fprintf('%s\n',['Loading ' num2str(fr) ' of ' num2str(frames)]);
        end
    case 'second'
        a=single(zeros(x*y,frames));
        for fr=1:frames
            a(:,fr)=fread(fid,prod([x y]),[num2str(prod([x y])) '*float32=>float32'],4*prod([x y]));
            fprintf('%s\n',['Loading ' num2str(fr) ' of ' num2str(frames)]);
        end
    case 'both'
        y=y*2;
        a=single(zeros(x*y,frames));
        for fr=1:frames
            a(:,fr)=fread(fid,prod([x y]),[num2str(prod([x y])) '*float32=>float32']);
            fprintf('%s\n',['Loading ' num2str(fr) ' of ' num2str(frames)]);
        end
end
fclose(fid);