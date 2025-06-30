%taking image input------------------------------------------------------


start_time=datetime("now");
rgbImage=imread('./Resizes/c4500.jpg');


%dimensions of image-----------------------------------------------------

[Row,Columns,channels]=size(rgbImage);

%image conversions and channel extractions...............................

grayImage=rgb2gray(rgbImage);
hsvImage=rgb2hsv(rgbImage);
hChannel=hsvImage(:,:,1);
sChannel=hsvImage(:,:,2);
vChannel=hsvImage(:,:,3);
tempVChannel=round(vChannel.*255);
sChannel=round(sChannel.*255);

%finding gray and s channel frequencies-----------------------------------

grayfreq=zeros(1,256);
sfreq=zeros(1,256);
for i=1:Row
    for j=1:Columns
        grayfreq(grayImage(i,j)+1)=grayfreq(grayImage(i,j)+1)+1;
        sfreq(sChannel(i,j)+1)=sfreq(sChannel(i,j)+1)+1;
    end
end

%finding maxValue in Vchannel---------------------------------------------

vmaxValue=max(grayImage(:));

%Linear Enhancment--------------------------------------------------------

enhancedVChannelImg=grayImage(:,:);
for i=1:Row
    for j=1:Columns
        if grayImage(i,j)>=2 && grayImage(i,j)<220
            enhancedVChannelImg(i,j)=uint8(255/vmaxValue)*(tempVChannel(i,j));
        end
    end
end


%To find gamma%..........................................................

%calculating mean

tempenhance=enhancedVChannelImg;
num=0;
den=0;
for i=1:256
    num=num+(grayfreq(i)*(i-1));
   
end

mean=floor(num/(Row*Columns));


%calculating c

num1=0;den1=0;

for i=1:mean
    num1=num1+grayfreq(i)*(i-1);
    den1=grayfreq(i)+den1;
end
c=num1/(128*den1);
num

%enlarging c

c1=1/(1+exp(-c));
c1=floor(c1);

%Calculating PDF

pdf=zeros(1,256);
for i=1:256
    pdf(i)=grayfreq(i)/(Row*Columns);
end

%Calculating CDF

cdf=0;
for i=1:128
    cdf=cdf+pdf(i);
end

%Calculating gamma

w=0.48;
gamma=(w*c1)+((1-w)*cdf);


%gamma on every pixxel
tempold=0;
oldvalue=6;

for i=1:Row
    for j=1:Columns
        %....................applying gamma..............................
        if enhancedVChannelImg(i,j)>=0 
            oldvalue=enhancedVChannelImg(i,j);
            oldvalue=double(oldvalue)/255;
            tempold=oldvalue^gamma;
  %.....................%VE = exp(log(V) - log(VL).......................
            change1=tempold;
            change2=vChannel(i,j);
            if (change1~=0)
                change1=log(change1);
            end
            if (change2~=0)
                change2=log(change2);
            end
            if(change1~=0)
                tempold=exp(change2-change1);
            end
     %...................Dynamic Range Expnsion..........................
            temp1=tempold;
            if enhancedVChannelImg(i,j)<200
                temp1=2*(temp1^2);
                temp1=temp1*255;
                enhancedVChannelImg(i,j)=floor(temp1);
            end

        end
    end
end


enhancedVChannelImg(Row,Columns)


%calculating VES--------------------------------------------------------
vefreq=zeros(1,256);
for i=1:Row
    for j=1:Columns
        vefreq(enhancedVChannelImg(i,j)+1)=vefreq(enhancedVChannelImg(i,j)+1)+1;
    end
end

%calculating s mean and vemean-----------------------------------------
num=0;num1=0;den1=0;
den=0;
for i=1:256
    num=num+sfreq(i)*(i-1);
    den=den+sfreq(i);
    num1=num1+vefreq(i)*(i-1);
    den1=den1+vefreq(i);
end
Smean=num/den;
VEmean=num1/den1;

%calculating VES--------------------------------------------------------

VES=VEmean-Smean;
VES=VES/255;

%Schannel adjustment-----------------------------------------------------

enhancedSChannelImg=sChannel;
enhancedSChannelImg1 = enhancedSChannelImg./255;



%applyingSchannel
n=0;
if VES>=0
    n=1;
end
tempImg=sChannel./255;
tempPow=1+((-1)^(2-n))*(((abs(VES))^2)+(abs(VES)));
tempImg=tempImg.^(tempPow);
enhancedSChannelImg1=tempImg;


%enhancedSChannelImg=enhancedSChannelImg./255;

enhancedVChannelImg=double(enhancedVChannelImg)./255;
%enhancedSChannelImg*255

%.................................................................
%updating hsvImage

UpdatedHSVImage=cat(3,hChannel,enhancedSChannelImg1,enhancedVChannelImg);
im2double(UpdatedHSVImage);
%convertion of hsvImage to rgbImage

outputImage=hsv2rgb(UpdatedHSVImage);
end_time=datetime("now");
diff=end_time-start_time;
milliseconds(diff)/1000
%..................................................................
% plotting histograms

subplot(2,2,1);
imshow(rgbImage);
title('Original Image');
subplot(2,2,2);
imshow(outputImage);
title('Enhanced Image');
subplot(2,2,3);
histogram(vChannel,'EdgeColor',"#0080ff");
%imshow(tempenhance);
title('Original V channel');
subplot(2,2,4);
histogram(enhancedVChannelImg,'EdgeColor',"#0080ff");
title('Enhanced V channel')


imwrite(outputImage,'./Output1.jpg');



