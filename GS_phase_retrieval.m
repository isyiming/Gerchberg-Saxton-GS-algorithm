iterative=300;            %设迭代次数为300次吧  
imagename='cat.jpg';    %你想要提取相位的图像名称  
phaseimage='phase.png';  %要保存的相位图像名称  
  
  
%空域输入图像的幅度（是已知的，也就是清晰的图像，它的灰度就是幅值）和相位图像（待恢复）  
known_abs_spatial=imread(imagename);            %作为输入图像的幅度，是已知的  
known_abs_spatial =rgb2gray(known_abs_spatial); %注意要用单通道图像做实验，如果你读取的是彩色图像，那就吧这行取消注释变成灰度图像吧  
known_abs_spatial=im2double(known_abs_spatial); %将图像灰度映射到0～1  
  
unknown_phase=known_abs_spatial;                %Peppers图像作为输入图像的相位，也即为待恢复的数据，  
                                                %要求它和known_abs_spatial大小一致，所以这里直接赋值就好了  
unknown_phase=im2double(unknown_phase);         %将图像灰度映射到0～1  
unknown_phase2=unknown_phase*2*pi;              %相位范围映射到0-2*pi  
unknown_phase2(unknown_phase2>pi)=unknown_phase2(unknown_phase2>pi)-2*pi;%进一步映射至[-pi,+pi]  
  
[width,length]=size(known_abs_spatial);         %获取Lena图像的大小  
input=known_abs_spatial.*exp(i*unknown_phase2); %最终输入图像:幅度*e^(i*相位角度)，它是复数图像  
known_abs_fourier=abs(fft2(input));             %先将input图像进行傅立叶变换，然后取模，就是傅氏变换后的幅度  
%以下开始迭代求相位  
phase_estimate=pi*rand(width,length);           %这是生成了一副大小为(width*length)的图像  
                                                %它的像素值是在[0,pi]范围内随机生成的。  
imshow(phase_estimate)  
%以下开始迭代  
for p=1:iterative  
    signal_estimate_spatial=known_abs_spatial.*exp(i*phase_estimate);   %Step 1  构造estimated signal：还是幅度*e^(i*相位角度)变成复数形式  
    temp1=fft2(signal_estimate_spatial);                                %傅立叶变换到频域  
    temp_ang=angle(temp1);                                              %求相位弧度，它的范围是[-pi,pi]  
    signal_estimate_fourier=known_abs_fourier.*exp(i*temp_ang);         %Step 2  替换傅氏变换后的幅度，产生estimate Fourier transform  
    temp2=ifft2(signal_estimate_fourier);                               %Step 3  对Step 2产生的estimate Fourier transform进行傅立叶反变换，又变换到空域了  
    phase_estimate=angle(temp2);                                        %Step 4:estimated phase  
end  
%以上循环就是通过随便预设一个相位图像，在循环中不断调整逼近真实的相位，直到满足条件（也就是我们求的相位和真实相位非常接近的时候）  
%不过这里我们只需要设定一个比较大的循环就可以了，基本上都可以满足条件了，这个激光原理就讲过了。  
  
phase_estimate(phase_estimate<0)=phase_estimate(phase_estimate<0)+2*pi; %把estimate_phase从[-pi,+pi]，映射到[0,2pi]  
retrieved=phase_estimate/(2*pi);%再映射到[0,1]  
  
figure (1)  
imshow(retrieved);title('相位图像')%显示我们提取到的相位图像  
imwrite(retrieved,phaseimage) 