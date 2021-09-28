% Direct I and II structer iir filter
%
% Author: myuzhao@163.com
% Date: 09/28/2021 
%-------------------------------------------------------------------------
load('HighPass50HzFs16k.mat')
fs = 16000;
data = rand(fs,1);
data_out1 = zeros(size(data));
data_out2 = zeros(size(data));
b0 = SOS(1);
b1 = SOS(2);
b2 = SOS(3);
a1 = SOS(5);
a2 = SOS(6);
x1=0; x2=0; y1=0; y2=0;
[bb,aa] = sos2tf(SOS,G);
data_out0 = filter(bb,aa,data);
for i = 1:length(data)
    x0 = data(i);
    y0 = (x0 * b0 + x1 * b1 + x2 * b2) * G(1) ...
          - y1 * a1 - y2 * a2;
    data_out1(i) = y0;
    x2 = x1;
    x1 = x0;
    y2 = y1;
    y1 = y0;
end

s1 = 0; s2 = 0;
for i = 1:length(data)
    s0 = data(i) - a1 * s1 - a2 *s2;
    y0 = (s0 * b0 + s1 * b1 + s2 * b2) * G(1);
    data_out2(i) = y0;
    s2 = s1;
    s1 = s0;
end
idx = 1:length(data);
figure

plot(idx,data_out0,'r.',idx,data_out1,'g-',idx,data_out2,'b--')