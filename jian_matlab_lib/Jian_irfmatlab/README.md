Jian-matlab
====================
Set of tools for Matlab for use of Cluster data, mainly concerning CIS-HIA data with subspin resolution.

Author: Jian Yang  <br />
BUAA_SSI

Email:yangjian615@buaa.edu.cn

Installation
------------

Make sure to add the path to Matlab so it can be used from anywhere. Add the following line to your [startup.m](http://se.mathworks.com/help/matlab/ref/startup.html?searchHighlight=startup.m "startup.m at Mathworks"):
>addpath /.../Jian-matlab

[irfu-matlab](https://github.com/irfu/irfu-matlab "IRFU's github") is required for these functions.

Compatibility
-------------------
Several functions related to plotting only works in Matlab 2014b or newer.

Usage
----------
Use the functions from any directory using:
>  Jian.function_name(...)

View help for the repo by typing in Matlab
> help Jian

or 
> doc Jian


Most "get functions" requires data to have been downloaded to a directory "data/caalocal". Can use Jian.import_c_data to download data to this local directory.

>jian_irfmatlab=jian_irfmatlab('data_path','/data/caalocal');
init lib :
jian_irfmatlab.init
jian_irfmatlab.reset


>Jian.import_c_data 
Downloads data from CSA, stores it in data/caalocal.

tint=irf.tint('2001-07-31T20:14:17.499996Z/2001-07-31T20:16:17.499996Z'); % time interval
Jian.import_c_data(tint,'fgm');
bField = Jian.get_3d_b_field(tint,1);