%% fir design using window function approximation 
fc = 1/2;                     %% w_c/pi
n = floor(6.2/(0.15 * fc));   
n = floor(n/2) * 2 + 1;       % set window len to old
w = hamming(n);
idx = 0:(n - 1);
idx = idx - (n - 1)/2 ;
idx = idx(:);
h = fc * sinc(fc * idx).* w;
figure
freqz(h)

