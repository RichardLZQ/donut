FilePath='C:\(20140120_16_00_49)-_natural_LNC2_region1_movie_30s_10frbaseline';
FileList=dir(FilePath);
for jj=3:size(FileList,1);
    mystackU.fname=[FilePath FileList(jj,1).name];
    
    fid=fopen(mystackU.fname);
    mystackU.dim=fread(fid,2,'int16');
%     mystackU.totfrm = (l.bytes-2*(16/8))./(2*prod(mystackU.dim)); % total number of frames
    fclose(fid);
    
    mystackU.totfrm=1000;
    rng = [1:mystackU.totfrm]; % here you can specify a frame number, or a rng of consecutive frames
    % read in those frames
    fid = fopen(mystackU.fname);
    fseek(fid, 2*(16/8) + (2*mystackU.dim(1)*mystackU.dim(2)*(rng(1)-1)), 'bof'); % skip header (2*2bytes) + 2bytes * x * y pixels * number of preceding frames
    ndat =fread(fid,[length(rng)*prod(mystackU.dim)],'*int16'); % read single frame
    Im=reshape(ndat,mystackU.dim(2),mystackU.dim(1),[]); % size(datr)
    fclose(fid);
    
    save(['JasperData',num2str(jj-2)],'Im');
end