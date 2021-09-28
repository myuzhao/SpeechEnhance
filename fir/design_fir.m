% lowpass fir design using window function approximation and  freq sampling method.%
%
% Author: myuzhao@163.com
% Date: 09/28/2021 
%-------------------------------------------------------------------------
%% window function approximation 
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

%% freq sampling method
fc = 1/2;                     %% w_c/pi
n = floor(6.2/(0.15 * fc));   
N = floor(n/2) * 2 + 1;       % set window len to old
n = (N - 1)/2;

w = linspace(0,pi,360);
A = [ones(360,1) 2*cos(kron(w',[1:n]))];
w_pass_end = 0.5 * pi;
w_stop_start = 0.7 * pi;
pass_dB = 0;
stop_dB = -30;

idx = find((w >=0) & (w<= w_pass_end));
A_pass = A(idx,:)
H_pass = 10^(stop_dB/20) * ones(length(idx),1);

idx = find((w >=w_stop_start) & (w<= pi));
A_stop = A(idx,:)
H_stop = 10^(stop_dB/20) * ones(length(idx),1);

cvx_begin
    variable d
    variable h(n+1,1);
    
    minimize (d)
    subject to
        max(abs(A_pass*h - H_pass)) <=d
        abs(A_stop*h) <= H_stop;
cvx_end

h = [flipud(h(2:end));h];
figure
freqz(h)
% H = exp(-1j*kron(w',[0:2*n]))*h;
% figure
% subplot(2,1,1)
% plot(w,20*log10(abs(H)))
% subplot(2,1,2)
% plot(w,angle(H))