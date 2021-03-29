function PowerSpecSub(filename,outfile)

%  Implements the basic power spectral subtraction algorithm [1].
% 
%  Usage:  PowerSpecSub(noisyFile, outputFile)
%           
%         noisyFile - noisy speech file in .wav format
%         outputFile - enhanced output file in .wav format
%
%  References:
%   [1] Loizou P C . Loizou, P.: Speech enhancement: Theory and practice[J]. Crc Press, 2017.
%
% Author: myuzhao@163.com
% Date: 03/28/2021 
%-------------------------------------------------------------------------

if nargin<2
   fprintf('Usage: specsub noisyfile.wav outFile.wav \n\n');
   
   filename = 'sp04_babble_sn10.wav';
   outfile = 'sp04_babble_sn10_specsub_out.wav';
end

[data,fs]=audioread(filename);
% =============== Initialize variables ===============
hop_size = 128;
frame_size = 512;
nFFT = frame_size;
outputs = zeros(size(data));    
data_buff = zeros(frame_size,1);
DPower = zeros(nFFT,1);
XPower = zeros(nFFT,1);
win = (hanning(nFFT,'periodic')); %define window
winGain = hop_size/sum(win); % normalization gain for overlap+add with 25% overlap
Nframes = floor((length(data)-(frame_size - hop_size))/hop_size);
%===============================  Start Processing ==================================
for n = 1:Nframes 
    idx = (n-1)*hop_size + (1:hop_size);
    data_buff = [data_buff(hop_size+1:end,:);data(idx)];
    data_buff_fft = fft(data_buff.* win);
    theta=angle(data_buff_fft);
    FramePower = data_buff_fft.* conj(data_buff_fft);
    if(n < 5)
        DPower = 0.99 * DPower + 0.01 * FramePower;
    else 
        for i = 1:nFFT %estimate noise power
            if(FramePower(i) < DPower(i))
                DPower(i) = 0.9 * DPower(i) + 0.1 * FramePower(i);
            else
                DPower(i) = 0.99 * DPower(i) + 0.01 * FramePower(i);
            end
        end
    end
    
    for i = 1:nFFT % SpecSub
        XPower(i) = FramePower(i) - DPower(i);
        if(XPower(i)<0) 
            XPower(i) = 0;
        end
    end
    y_tmp = sqrt(XPower).*exp(1i*theta);
    y = real(ifft(y_tmp));
    
    idx = (n-1)*hop_size + (1:frame_size);
    outputs(idx) = outputs(idx) + y;
end
%========================================================================================


audiowrite(outfile,winGain*outputs,fs);