# My_matlab_pro 按首字母排序由大到小
Project myself Jiang Yang 
Contents:


 jian_matlab_lib
    Mrx_GUI: 小波变换一些数据处理
    
    Matlab_Export_fig: 
    A toolbox for exporting figures from MATLAB to standard image and document formats nicely.
          Test_Matlab_Export_fig.m ;测试程序
             
    m_map: mapping toolbox 
          Contents.m-   包含的内容
          m_demo.m-     测试demo
          map.html-     使用说明
             
    losscone: Calculate loss cone angle over the globe at given satellite altitude
         Demo_test_losscone  简单的使用 
              
    kempo1m_src: Kyoto university ElectroMagnetic Particle cOde: 1D version
         kempo1_mac 
         kempo1           ;windows matlab
         模拟各种不稳定性
    
    Jian_irfmatlab: 自己写的一些matlab程序
          +my_matlab_code  基于irf的一些自定义程序
       
    
    GEOPACK: geopack from xiao
     GEOPACK_test
     Magnetopause_Shue; 磁层顶shue的模型 
     Rc               ; 磁力线2D模型
     GEOPACK_EXAMPLE1 ;
     GEOPACK_EXAMPLE2
      
    Geocentric coordinate_HapgoodRotations: Rotations from one Geocentric coordinate system to another. (MatLab)
    

    
    eqn_master: 地面台站数据处理 International Monitor for Auroral Geomagnetic Effects
               35 magnetometer stations
               
               UniGUI: Params = eqn_paramLoader('config.txt');缺少config.txt
               
               Diff-Coeffs-master:得到平均的小波变换power用来计算扩散系数
    grinsted-wavelet-coherence: 小波变化
%   continuous wavelet transform (CWT), Cross wavelet transform (XWT)
%   and Wavelet Coherence (WTC) plots of your own data.
              wtcdemo.m
              wavetest.m
    Higher Order Spectral Analysis toolkit:(HOSA) Toolbox
    
    安装说明:https://cn.mathworks.com/matlabcentral/fileexchange/3013-hosa-higher-order-spectral-analysis-toolbox
    Common installation issues with HOSA Toolbox
    Issue 1: All .m files are uppercase 
    Solution: Rename .m files to lowercase. See Stefano Tronci's post (25 Jul 2015) if using Linux.
    Issue 2: HOSA Demo does not work  : for the choice.m-file problem: 
    https://cn.mathworks.com/matlabcentral/fileexchange/36084-choices?focused=5229533&tab=function 
    
        hosahelp  will give one-line syntax for all the toolbox mfiles.
        help hosa will give a functional descrption of the toolbox mfiles.
        hosademo  will run the HOSA toolbox demo. 
        hosadem.m
        hosademo.m