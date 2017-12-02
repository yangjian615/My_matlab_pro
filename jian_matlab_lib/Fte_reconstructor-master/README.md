fte_reconstructor
=================

Matlab program that reconstructs flux transfer events from THEMIS probe spacecraft data

The "main" file is fte_gui.m, while the Matlab GUIDE fig / plot / layout file is fte_gui.fig.  I realize now that there are many many MANY bad design decisions that could've been fixed with a bit of modular programming and version control.  
Anything ending in a .dat is a data file (duh.).  
The .txt files are metadata files that I manually compiled from hours of searching through IDL plots for THEMIS probes.
(it would be good if these were automated into something less horrifically kludgy.  The THEMIS API / Library is pretty solid.)
The other files are somewhat frankensteined from Wai Leong Teh's original matlab code, which are described below:

Main program: IRMgs.m
Subroutine: 		gsup.m: integration above y=0
			gsdn.m: integration below y=0
			dht.m : calculate HT velocity
			HTcoef.m: calculate c.c. and slope of HT analysis
			MVAB.m: minimum variance analysis of B field
			
			savgolfilter.m and savgolrev.m: for smoothing or x-derivative calculation
			weighFunc1.m: weighting function for vector potential A
