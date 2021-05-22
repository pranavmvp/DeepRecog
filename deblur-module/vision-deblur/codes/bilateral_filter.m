%�򵥵�˵:
%AΪ����ͼ�񣬹�һ����[0,1]�ľ���
%WΪ˫���˲������ˣ��ı߳�/2
%�����򷽲��d��ΪSIGMA(1),ֵ�򷽲��r��ΪSIGMA(2)
function B = bilateral_filter(A,w,sigma)
%ȷ������ͼ����ڲ�����Ч.
if ~exist('A','var') || isempty(A)%���Aͼ���Ƿ����
   error('Input image A is undefined or invalid.');
end
if ~isfloat(A) || ~sum([1,3] == size(A,3))
%       min(A(:)) < 0 || max(A(:)) > 1
   error(['Input image A must be a double precision ',...
          'matrix of size NxMx1 or NxMx3 on the closed ',...
          'interval [0,1].']);      
end

% ��֤˫���˲������ߴ�.
if ~exist('w','var') || isempty(w) || ...
      numel(w) ~= 1 || w < 1
   w = 3;
end
w = ceil(w);

% ��֤˫���˲�����׼ƫ��.
if ~exist('sigma','var') || isempty(sigma) || ...
      numel(sigma) ~= 2 || sigma(1) <= 0 || sigma(2) <= 0
   sigma = [3 0.1];
end

% Ӧ�ûҶȻ��ɫ˫���˲�.
if size(A,3) == 1
    B = bfltGray(A,w,sigma(1),sigma(2));
else
    B = bfltColor(A,w,sigma(1),sigma(2));
    % �˲�ͼ��ת����sRGBɫ�ʿռ䡣
    if exist('applycform','file')
        B = applycform(B,makecform('lab2srgb'));
    else
        B = colorspace('RGB<-Lab',B);
    end
end

end




