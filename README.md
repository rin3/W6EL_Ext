# Extraction and Report script for W6EL Prop
### - Preparation for specific contest dates
### - World opening times table for each band, SP and LP
###
#### rin fukuda, jg1vgx@jarl.com, Oct 2004
#### version 0.02, for W6EL Prop v2.70 ONLY!!

Requirements
============
You need Perl package to run this script. If you are on Windows, use ActivePerl (http://www.activestates.com/) or Windows Services for Unix (http://www.microsoft.com/japan/windows/sfu/), which also includes Perl. 

W6EL Prop Settings
===================================
This software ONLY WORKS for W6EL Prop, version 2.70.
In W6EL Prop, Options:
 - [Default Teminal] = (any)
 - [Frequencies and Constants] = Five-band prediction, 80-10m is assumed. Use factory setting of 3.6, 7.1, 14.1, 21.2 and 28.3. You cannot add or remove any bands. Signal constants are changeable.
 - [Prediction Parameters], [User Preferences] = (any)

How to Use
==========
(1) Once you have entered the above settings, in W6EL Prop, go to menu "Prediction"-"Batch". Fill in destination locators, date, solar index etc. Set the Path as 'B'oth. You can enter any numbers of lines here.
(2) Press 'Print Predictions', but when the print dialogue appears, don't press 'OK' to print yet. IMPORTANT: Check "Output to File(L)" box here, then press OK. Once finished, batch prediction output files (.wpf) will be created. You can quit W6EL Prop then.
(3) Run the W6EL_Ext Perl script. In Windows, use command window, eg: use 'Run' from the Start menu. Then run 'cmd'. Change directory to where this script and the above .wpf is located. (It would be easier if you save .wpf in the same directory as the script itself.) When you run the script, it asks you the name of .wpf file. Enter it, and that's all! The output of this script, handy perdiction table will be produced in the same directory with the extention .txt.

- Sample input batch files (.wbt) are included for world-wide prediction from JA, for each SSN, 50, 100, 150 and 200.

How to Read the Table
=====================
The table follows in order of 80, 40, 20, 15 and 10m. For each band, SP is followed by LP predictions. The symbols in the table means the following possibility of openings:
 # 100-75%
 + 75-50%
 - 50-25%
"Space" means 25% or less possibility of openings.

IMPORTANT: Remember that, ONLY the possibility of openings but not signal levels are illustrated.

Version History
===============

v0.02 (28 Oct 2004)
-First Release