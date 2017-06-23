function [ImOut]=donut_ImReg(ImIn,ImRef)
usfac = 5;
[output, Greg] = dftregistration(fft2(ImRef),fft2(ImIn),usfac);
ImOut=abs(ifft2(Greg));
end