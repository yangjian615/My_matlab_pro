%% init
addpath('../Matlab_Export_fig/')
mkdir('Test_Matlab_Export_fig');
cd Test_Matlab_Export_fig
%% 保持原比例输出
% Examples
% Visual accuracy - MATLAB's exporting functions, namely saveas and print, change many visual properties of a figure, such as size, axes limits and ticks, and background colour, in unexpected and unintended ways. Export_fig aims to faithfully reproduce the figure as it appears on screen. For example:
plot(cos(linspace(0, 7, 1000)));
set(gcf, 'Position', [100 100 150 150]);
saveas(gcf, 'test.png');
export_fig test2.png

set(gcf, 'Color', 'white');
export_fig test_white.png


%% Resolution 修改输出分辨率
% - by default, export_fig exports bitmaps at screen resolution.
% However, you may wish to save them at a different resolution.
% You can do this using either of two options: -m<val>,
% where is a positive real number, magnifies the figure by the factor for export,
% e.g. -m2 produces an image double the size (in pixels) of the on screen figure;
% -r<val>, again where is a positive real number, specifies the output bitmap to have pixels per inch, the dimensions of the figure (in inches) being those of the on screen figure.
% For example, using:
export_fig test_Resolution.png -m2.5;

%% Sometimes you might have a figure with an image in. For example:

imshow(imread('cameraman.tif'))
hold on
plot(0:255, sin(linspace(0, 10, 256))*127+128);
set(gcf, 'Position', [100 100 150 150]);

% Here the image is displayed in the figure at resolution lower than its native resolution.
% However, you might want to export the figure at a resolution such that the image is output at its native (i.e. original) size (in pixels).
% Ordinarily this would require some non-trivial computation to work out what that resolution should be,
% but export_fig has an option to do this for you. Using:


export_fig test_image_native.png -native

%% Shrinking dots & dashes
%when exporting figures with dashed or dotted lines using either the ZBuffer or OpenGL (default for bitmaps) renderers,
%the dots and dashes can appear much shorter, even non-existent, in the output file,
%especially if the lines are thick and/or the resolution is high. For example:

plot(sin(linspace(0, 10, 1000)), 'b:', 'LineWidth', 4);
hold on
plot(cos(linspace(0, 7, 1000)), 'r--', 'LineWidth', 3);
grid on
export_fig test_Shrinking_dots.png

%This problem can be overcome by using the painters renderer. For example:
export_fig test_Shrinking_dots2.png -painters

%% Transparency
%- sometimes you might want a figure and axes' backgrounds to be transparent,
%so that you can see through them to a document (for example a presentation slide, with coloured or textured background) that the exported figure is placed in.
%To achieve this, first (optionally) set the axes' colour to 'none' prior to exporting, using:

logo;
alpha(0.5);

set(gca, 'Color', 'none'); % Sets axes background

export_fig test_Transparency.png -transparent

%% Image quality THE import for us
%first we need install Ghostscrip
%- when publishing images of your results, you want them to look as good as possible.
%By default, when outputting to lossy file formats (PDF, EPS and JPEG), export_fig uses a high quality setting,
%i.e. low compression, for images, so little information is lost.
%This is in contrast to MATLAB's print and saveas functions, whose default quality settings are poor. For example:

A = im2double(imread('peppers.png'));
B = randn(ceil(size(A, 1)/6), ceil(size(A, 2)/6), 3) * 0.1;
B = cat(3, kron(B(:,:,1), ones(6)), kron(B(:,:,2), ones(6)), kron(B(:,:,3), ones(6)));
B = A + B(1:size(A, 1),1:size(A, 2),:);
imshow(B);
print -dpdf test_Image_quality_matlab.pdf

export_fig test_Image_quality_exportfig.pdf

%You may prefer to export with no artifacts at all,
%i.e. lossless compression. Alternatively, you might need a smaller file, and be willing to accept more compression.
%Either way, export_fig has an option that can suit your needs: -q<val>, where is a number from 0-100,
%will set the level of lossy image compression (again in PDF, EPS and JPEG outputs only; other formats are lossless),
%from high compression (0) to low compression/high quality (100).
%If you want lossless compression in any of those formats then specify a greater than 100. For example:
export_fig test_Image_quality_exportfig_nocomp.pdf -q101


%% Tips

%Anti-aliasing - the anti-aliasing which export_fig applies to bitmap outputs by default makes the images look
%Cropping - by default, export_fig crops its output to minimize the amount of empty space around the figure

%Specifying a target directory - you can get export_fig to save output files to any directory
%(for which you have write permission), simply by specifying the full or relative path in the filename. For example:

% export_fig ../subdir/fig.png;
% export_fig('C:/Users/Me/Documents/figures/myfig', '-pdf', '-png');s


% Variable file names - often you might want to save a series of figures in a for loop,
% each with a different name. For this you can use the functional form of input arguments,
% i.e. export_fig(arg1, arg2), and construct the filename string in a variable.
% Here's an example of this:

figure
mkdir('plot_seriees');
for a = 1:5
    plot(rand(5, 2));
    export_fig(sprintf('plot_seriees/plot%d.png', a));
end


%Multiple formats - save time by exporting to multiple formats simultaneously. E.g.:

%export_fig filename -pdf -eps -png -jpg -tiff

%% Clear
pause
cd ..
rmdir('Test_Matlab_Export_fig','s');

