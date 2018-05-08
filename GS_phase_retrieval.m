iterative=300;            %���������Ϊ300�ΰ�  
imagename='cat.jpg';    %����Ҫ��ȡ��λ��ͼ������  
phaseimage='phase.png';  %Ҫ�������λͼ������  
  
  
%��������ͼ��ķ��ȣ�����֪�ģ�Ҳ����������ͼ�����ĻҶȾ��Ƿ�ֵ������λͼ�񣨴��ָ���  
known_abs_spatial=imread(imagename);            %��Ϊ����ͼ��ķ��ȣ�����֪��  
known_abs_spatial =rgb2gray(known_abs_spatial); %ע��Ҫ�õ�ͨ��ͼ����ʵ�飬������ȡ���ǲ�ɫͼ���ǾͰ�����ȡ��ע�ͱ�ɻҶ�ͼ���  
known_abs_spatial=im2double(known_abs_spatial); %��ͼ��Ҷ�ӳ�䵽0��1  
  
unknown_phase=known_abs_spatial;                %Peppersͼ����Ϊ����ͼ�����λ��Ҳ��Ϊ���ָ������ݣ�  
                                                %Ҫ������known_abs_spatial��Сһ�£���������ֱ�Ӹ�ֵ�ͺ���  
unknown_phase=im2double(unknown_phase);         %��ͼ��Ҷ�ӳ�䵽0��1  
unknown_phase2=unknown_phase*2*pi;              %��λ��Χӳ�䵽0-2*pi  
unknown_phase2(unknown_phase2>pi)=unknown_phase2(unknown_phase2>pi)-2*pi;%��һ��ӳ����[-pi,+pi]  
  
[width,length]=size(known_abs_spatial);         %��ȡLenaͼ��Ĵ�С  
input=known_abs_spatial.*exp(i*unknown_phase2); %��������ͼ��:����*e^(i*��λ�Ƕ�)�����Ǹ���ͼ��  
known_abs_fourier=abs(fft2(input));             %�Ƚ�inputͼ����и���Ҷ�任��Ȼ��ȡģ�����Ǹ��ϱ任��ķ���  
%���¿�ʼ��������λ  
phase_estimate=pi*rand(width,length);           %����������һ����СΪ(width*length)��ͼ��  
                                                %��������ֵ����[0,pi]��Χ��������ɵġ�  
imshow(phase_estimate)  
%���¿�ʼ����  
for p=1:iterative  
    signal_estimate_spatial=known_abs_spatial.*exp(i*phase_estimate);   %Step 1  ����estimated signal�����Ƿ���*e^(i*��λ�Ƕ�)��ɸ�����ʽ  
    temp1=fft2(signal_estimate_spatial);                                %����Ҷ�任��Ƶ��  
    temp_ang=angle(temp1);                                              %����λ���ȣ����ķ�Χ��[-pi,pi]  
    signal_estimate_fourier=known_abs_fourier.*exp(i*temp_ang);         %Step 2  �滻���ϱ任��ķ��ȣ�����estimate Fourier transform  
    temp2=ifft2(signal_estimate_fourier);                               %Step 3  ��Step 2������estimate Fourier transform���и���Ҷ���任���ֱ任��������  
    phase_estimate=angle(temp2);                                        %Step 4:estimated phase  
end  
%����ѭ������ͨ�����Ԥ��һ����λͼ����ѭ���в��ϵ����ƽ���ʵ����λ��ֱ������������Ҳ�������������λ����ʵ��λ�ǳ��ӽ���ʱ��  
%������������ֻ��Ҫ�趨һ���Ƚϴ��ѭ���Ϳ����ˣ������϶��������������ˣ��������ԭ��ͽ����ˡ�  
  
phase_estimate(phase_estimate<0)=phase_estimate(phase_estimate<0)+2*pi; %��estimate_phase��[-pi,+pi]��ӳ�䵽[0,2pi]  
retrieved=phase_estimate/(2*pi);%��ӳ�䵽[0,1]  
  
figure (1)  
imshow(retrieved);title('��λͼ��')%��ʾ������ȡ������λͼ��  
imwrite(retrieved,phaseimage) 