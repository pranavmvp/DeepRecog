% a=(double(2*imread('1.jpg'))+2*double(imread('2.jpg'))+double(imread('3.jpg')))/4;
% 
% a=uint8(a);
% % a=white_balance(a);
% a(:,:,2)=a(:,:,2)*1.01;
% imshow(a);
% imwrite(a,['a','.jpg']);

%�����е�֡ͼƬת��Ϊ��Ƶ
DIR='vedio\img_';        %ͼƬ�����ļ���
file=dir(strcat(DIR,'*.png'));                %��ȡ����jpg�ļ�
filenum=size(file,1);                         %ͼƬ����

obj_gray = VideoWriter('ˮ��ͼ��������.avi');   %��ת���ɵ���Ƶ����
writerFrames = filenum;                       %��Ƶ֡��

%������ͼƬ����avi�ļ�
open(obj_gray);
for k = 1: writerFrames
    if sum(k==251:300)==1
        continue;
    end
    fname = strcat(DIR, num2str(k), '.png');
    frame = imread(fname);
    frame=imresize(frame,[778,1038]);
    writeVideo(obj_gray, frame);
end
close(obj_gray);