function [ radiance1,radiance2 ] = dehaze_fast( image, omega, win_size )
%DEHZE Summary of this function goes here
%   Detailed explanation goes here

if ~exist('omega', 'var')
    omega = 0.95;
end

if ~exist('win_size', 'var')
    win_size = 30;
end

r = 15;
res = 0.001;

[m, n, ~] = size(image);

dark_channel = get_dark_channel(image, win_size);

atmosphere = get_atmosphere(image, dark_channel);

trans_est = get_transmission_estimate(image, atmosphere, omega, win_size);
% �����˲�
x1 = guided_filter(rgb2gray(image), trans_est, r, res);  


% w = 3;       %WΪ˫���˲������ˣ��ı߳�/2 
% sigma = [3 0.2];
% x2=bilateral_filter(abs(trans_est),w,sigma);%����˫���˲�����

r = 0;
N=[1,-2,1];
M=[1;-2;1];
dim=size(trans_est);
for i=1:(dim(1)/2)
    for j=1:(dim(2)/2)
        p=abs(conv(M,conv(N,trans_est(i,j))));
        r=p+r;
    end
end
q=1.66*p/(dim(1)*dim(2))
w = 3;       %WΪ˫���˲������ˣ��ı߳�/2 
sigma = [3 q]; %�ռ����ƶ�Ӱ�����ӷ����d��ΪSIGMA(1),�������ƶ�Ӱ�����ӷ����r��ΪSIGMA(2)

x2=bilateral_filter(abs(trans_est),w,sigma);%����˫���˲�����

transmission1 = reshape(x1, m, n);
transmission2 = reshape(x2, m, n);

radiance1 = get_radiance(image, transmission1, atmosphere);
radiance2 = get_radiance(image, transmission2, atmosphere);
end

