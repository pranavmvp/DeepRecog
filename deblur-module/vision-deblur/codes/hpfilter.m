%��һ�⣺hpfilter.m
%������ʵ�ֵ���IHPF��BHPF��EHPF�Ĵ��ݺ���
%@author�����ڷ�
function[H,D] = hpfilter(type,M,N,D0,nn)
%����Ƶ�����
U = 0 : (M - 1);%����U�ķ�Χ
V = 0 : (N - 1);%����V�ķ�Χ
%�������ʹ�õ�����ֵ
idx = find(U > M/2);
U(idx) = U(idx) - M;
idy = find(V > N/2);
V(idy) = V(idy) - N;
[V,U] = meshgrid(V,U);%����������
D = sqrt(U.^2 + V.^2);%����Ƶ���D(u,v)��ԭ��ľ���D
%�˲����Ĵ��ݺ���
switch type
    case 'ideal' %IHPF���ݺ���
        H = double(D>D0);
    case 'btw' %BHPF���ݺ���
        if nargin ==4
            nn =1;
        end
        H = 1./(1+(sqrt(2)-1)*(D0./D).^nn);
    case 'expotential' %EHPF���ݺ���
        H = exp(log(1/sqrt(2))*(D0./D).^nn);
    otherwise
        error('unkown filter type')
end
