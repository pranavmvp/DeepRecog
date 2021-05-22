clc;
clear all;close all;
img_name='11w=-3Xt=1e-07.jpg';
% ԭʼͼ��
I=double(imread(img_name))/255;
%   I = imresize(I,0.5);
% ��ȡͼ���С
[h,w,c]=size(I);
win_size = 3;
img_size=w*h;
figure, imshow(I);
win_dark=ones(h,w);
%����ֿ�darkchannel
 for j=1+win_size:w-win_size
    for i=win_size+1:h-win_size
        m_pos_min = min(I(i,j,:));
        for n=j-win_size:j+win_size
            for m=i-win_size:i+win_size
                if(win_dark(m,n)>m_pos_min)
                    win_dark(m,n)=m_pos_min;
                end
            end
        end
    end
 end
 %ѡ����ȷdark value����
% win_b = zeros(img_size,1);
 figure, imshow(win_dark);
 win_t=1-0.95*win_dark;
 win_b=zeros(img_size,1);
for ci=1:h
    for cj=1:w
        if(rem(ci-8,15)<1)
            if(rem(cj-8,15)<1)
                win_b(ci*w+cj)=win_t(ci*w+cj);
            end
        end
    end
end
 
%��ʾ�ֿ�darkchannel
%figure, imshow(win_dark);
neb_size = 9;
win_size = 1;
epsilon = 0.000001;
%ָ��������״
indsM=reshape(1:img_size,h,w);
%�������L
tlen = img_size*neb_size^2;
row_inds=zeros(tlen ,1);
col_inds=zeros(tlen,1);
vals=zeros(tlen,1);
len=0;
for j=1+win_size:w-win_size
    for i=win_size+1:h-win_size
        if(rem(h-8,15)<1)
            if(rem(w-8,15)<1)
                continue;
            end
        end
      win_inds=indsM(i-win_size:i+win_size,j-win_size:j+win_size);
      win_inds=win_inds(:);%����ʾ
      winI=I(i-win_size:i+win_size,j-win_size:j+win_size,:);
      winI=reshape(winI,neb_size,c); %����ͨ������ƽ��Ϊһ����ά���� 9*3
      win_mu=mean(winI,1)';  %��ÿһ�еľ�ֵ ����ڶ�������Ϊ2 ��Ϊ��ÿһ�еľ�ֵ  //���������
      win_var=winI'*winI/neb_size-win_mu*win_mu'+epsilon/neb_size*eye(c); %�󷽲�
      winI=winI-repmat(win_mu',neb_size,1);%�����
      tvals=(1+winI/win_var*winI')/neb_size;% ��������ָ�ľ���L
      row_inds(1+len:neb_size^2+len)=reshape(repmat(win_inds,1,neb_size),...
                                             neb_size^2,1);
      col_inds(1+len:neb_size^2+len)=reshape(repmat(win_inds',neb_size,1),...
                                             neb_size^2,1);
      vals(1+len:neb_size^2+len)=tvals(:);
      len=len+neb_size^2;
    end
end 
 
 
vals=vals(1:len);
row_inds=row_inds(1:len);
col_inds=col_inds(1:len);
%����ϡ�����
A=sparse(row_inds,col_inds,vals,img_size,img_size);
%���е��ܺ� 
sumA=sum(A,2);
%spdiags(sumA(:),0,img_size,img_size) ����img_size��С��ϡ�������Ԫ����sumA�е���Ԫ�ط�����0ָ���ĶԽ���λ���ϡ�
A=spdiags(sumA(:),0,img_size,img_size)-A;


  %����ϡ�����
  D=spdiags(win_b(:),0,img_size,img_size);
  lambda=1;
  x=(A+lambda*D)\(lambda*(win_b(:).*win_b(:)));
   %ȥ��0-1��Χ�������
  alpha=max(min(reshape(x,h,w),1),0);
 
figure, imshow(alpha);
% **************************************************
%     �Զ���ȡ�����ⲽ�裬AΪ���մ������ֵ
% **************************************************
range=ceil(img_size*0.1);%ȡ��ԭɫ��������%1�ĵ���
radi_pro=zeros(range,1); %���ڼ�¼�������ڶ�ӦͼƬ�����ص�����ͨ������ɫǿ��
      for s=1:range
          [a,b]=max(win_dark);  
          [c,d]=max(a);
          b=b(d);
          m=sparse(b,d,1,h,w);        %b,dΪ����ֵ������
          win_dark=win_dark-c.*m;     %��ȥѡ�������ֵ
          radi_pro(s)=sum(I(b,d,:));  %���ֵ��Ӧ������ͨ�����
      end
A=max(radi_pro)/3;%�������ֵ
% **************************************************
%  �㷨�Ľ����裬���������͸�����Լ�С�������ֵ�ʧ����
% **************************************************
inten=zeros(h,w);
    for m=1:h
        for n=1:w
            inten(m,n)=mean(I(m,n,:));
        end
    end
k=70;    
k=zeros(h,w)+k/255; %�ݲ�
% A=220/255;
cha=abs(inten-A);   %����
alpha=min(max(k./cha,1).*max(alpha,0.1),1); %�㷨�Ľ��ؼ�����
figure,imshow(alpha);
% ***************************************************
alpha=repmat(alpha,[1,1,3]);   
dehaze=(I-A)./alpha+A;  
figure, imshow(dehaze);