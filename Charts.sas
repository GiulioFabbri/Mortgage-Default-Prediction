/* Initialize CAS (Cloud Analytic Services) session */
cas;
libname mylib cas;

/* Load the mortgage dataset into CAS memory */
proc casutil;
	load casdata='mortgagedefault.sas7bdat' incaslib='CASUSER'
		casout= 'mortagage' outcaslib= 'CASUSER' replace;
quit;

/* Check if the dataset is balanced by visualizing the frequency of defaults */
ods graphics / reset width=6.4in height=4.8in imagemap;
proc sgplot data=LIB.MORTGAGEDEFAULT;
	title height=14pt "Will Default Frequency";
	vbar willDefault / stat=percent;
	yaxis grid;
run;
ods graphics / reset;
title;

/* Compute summary statistics for dataset variables */
ods noproctitle;
libname _tmpcas_ cas caslib="CASUSER";

proc cardinality data=MYLIB.MORTAGAGE outcard=_tmpcas_.varSummaryTemp 
	out=_tmpcas_.levelDetailTemp;
run;

/* Print variable summary statistics */
proc print data=_tmpcas_.varSummaryTemp label;
	var _varname_ _fmtwidth_ _type_ _rlevel_ _more_ _cardinality_ _nmiss_ _min_ 
		_max_ _mean_ _stddev_;
	title 'Variable Summary';
run;

/* Print first 20 observations of level details */
proc print data=_tmpcas_.levelDetailTemp (obs=20) label;
	title 'Level Details';
run;

/* Delete temporary datasets */
proc delete data=_tmpcas_.varSummaryTemp _tmpcas_.levelDetailTemp;
run;
libname _tmpcas_;

/* Visualizing distributions of numeric variables */

/* Loan Age Distribution */
ods graphics / reset width=6.4in height=4.8in imagemap;
proc sgplot data=MYLIB.MORTAGAGE;
	title height=14pt "Loan Age Distribution";
	histogram LoanAge;
	yaxis grid;
run;
ods graphics / reset;

/* Loan Age Distribution for Default vs Non-Default */
ods graphics / reset width=6.4in height=4.8in imagemap;
proc sgplot data=MYLIB.MORTAGAGE;
	title height=14pt "Loan Age Distribution by Default Status";
	histogram LoanAge / group=willDefault transparency=0.5;
	yaxis grid;
run;
ods graphics / reset;

/* Similar distribution visualizations for other numeric variables */

/* Last UPB (Unpaid Principal Balance) Distribution */
ods graphics / reset width=6.4in height=4.8in imagemap;
proc sgplot data=MYLIB.MORTAGAGE;
	title height=14pt "Last UPB Distribution";
	histogram LAST_UPB;
	yaxis grid;
run;
ods graphics / reset;

/* Last UPB Distribution by Default Status */
ods graphics / reset width=6.4in height=4.8in imagemap;
proc sgplot data=MYLIB.MORTAGAGE;
	title height=14pt "Last UPB Distribution by Default Status";
	histogram LAST_UPB / group=willDefault transparency=0.5;
	yaxis grid;
run;
ods graphics / reset;

/* Similar analyses are performed for Orig_RT, Orig_AMT, NUM_BO, CSCORE_B, NUM_UNIT, MI_PCT, CSCORE_C, MI_TYPE, and Mortgage Rate */

/* Visualizing distributions of nominal (categorical) variables */

/* Original Channel Distribution */
ods graphics / reset width=6.4in height=4.8in imagemap;
proc sgplot data=MYLIB.MORTAGAGE;
	title height=14pt "Origination Channel Frequency";
	vbar ORIG_CHN / group=willDefault groupdisplay=cluster stat=percent;
	yaxis grid;
run;
ods graphics / reset;
title;

/* Similar bar plots for FTHB_FLG, PURPOSE, PROP_TYP, and OCC_STAT */

/* End of code */
