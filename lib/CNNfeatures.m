% install and compile MatConvNet (needed once)
untar('http://www.vlfeat.org/matconvnet/download/matconvnet-1.0-beta18.tar.gz') ;

files = dir('../images');
cd matconvnet-1.0-beta18
run matlab/vl_compilenn

% download a pre-trained CNN from the web (needed once)
urlwrite(...
  'http://www.vlfeat.org/matconvnet/models/imagenet-vgg-f.mat', ...
  'imagenet-vgg-f.mat') ;

% setup MatConvNet
run  matlab/vl_setupnn

% load the pre-trained CNN
net = load('imagenet-vgg-f.mat') ;
miss_dat = {};
M=[];
filenames=[];
% load and preprocess an image
for n = 3:(length(files)-3)
    pic = files(n).name;
    try
        im = imread(strcat('../validate/',pic)) ;
        im_ = single(im) ; % note: 0-255 range
        im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ;
        im_ = im_ - net.meta.normalization.averageImage ;
        res = vl_simplenn(net, im_);
        a = res(10+1).x;
        filenames = [filenames,' ',pic];
    catch
        a = [];
        display('error')
        
    end
    M = [M;a]; 
    display(n) 
end

% run the CNN

dlmwrite('CNNfeatures.txt',M,'delimiter',' ');
