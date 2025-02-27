data mortages;
  set '/shared/home/valentina.coppi01@icatt.it/casuser/mortgagedefault.sas7bdat';
run;

cas;
libname mylib cas;

proc casutil;
	load casdata='mortgagedefault.sas7bdat' incaslib='CASUSER'
		casout= 'mortagage' outcaslib= 'CASUSER' replace;
quit;

/* Double Obs */

proc sort data=mortages
	nodupkey dupout='mortages_dup';
	by _all_;
run;


/* Summary Table */
proc contents data = mortages;
run;

/* Missing Values Table for numeric variables */
options nolabel;
PROC MEANS DATA= mortages NMISS;
run;

/* Numeric Variables with missing data */

proc freq data = mortages;
	title3 "Missing Data Frequencies";

	format OCLTV DTI 
		CSCORE_B MI_PCT CSCORE_C MI_TYPE _nmissprint.;
	tables OCLTV DTI 
		CSCORE_B MI_PCT CSCORE_C MI_TYPE/missing nocum ;
run;



/* NOminal Variables have no missing data */
ods noproctitle;

proc format;
	value $_cmissprint " "=" " other="Non-missing";
run;

proc freq data=mortages;
	title3 "Missing Data Frequencies";

	format LOAN_ID willDefault ORIG_CHN SellerName FTHB_FLG PURPOSE PROP_TYP 
		OCC_STAT STATE ProductType RELOCATION_FLG $_cmissprint.;
	tables LOAN_ID willDefault ORIG_CHN SellerName FTHB_FLG PURPOSE PROP_TYP 
		OCC_STAT STATE ProductType RELOCATION_FLG / missing nocum;
run;

/* TARGET VARIABLE DISTRIBUTION (DEFAULT VS NON DEFAULT) */
PROC FREQ DATA=mortages;
    TABLE willDefault;
RUN;


/* NA DISTRIBUTION IN TARGET VARIABLE */

ods noproctitle;

proc sort data=mortages out=Work.SORTTempTableSorted;
	by willDefault;
run;

proc format;
	value _nmissprint low-high="Non-missing";
run;

proc freq data=WORK.SORTTempTableSorted;
	title3 "Missing Data Frequencies";

	format OCLTV DTI CSCORE_B MI_PCT CSCORE_C MI_TYPE _nmissprint.;
	tables OCLTV DTI CSCORE_B MI_PCT CSCORE_C MI_TYPE / missing nocum;
	by willDefault;
run;

proc freq data=WORK.SORTTempTableSorted noprint;
	table OCLTV * DTI * CSCORE_B * MI_PCT * CSCORE_C * MI_TYPE / missing 
		out=Work._MissingData_;
	format OCLTV DTI CSCORE_B MI_PCT CSCORE_C MI_TYPE _nmissprint.;
	by willDefault;
run;

proc print data=Work._MissingData_ noobs label;
	title3 "Missing Data Patterns across Variables";

	format OCLTV DTI CSCORE_B MI_PCT CSCORE_C MI_TYPE _nmissprint.;
	label count="Frequency" percent="Percent";
run;

title3;

/* Clean up */
proc delete data=Work._MissingData_;
run;

proc delete data=Work.SORTTempTableSorted;
run;


/* Correlation matrix */

proc corr data=mortages;
run;                     /* Shows everytihing, it's a little bit confusing*/



proc corr data=mortages outp=CorrSym;
   var _numeric_;
run;

data mortages;
  set CorrSym(where=(_type_='CORR'));  /* subset the rows */
  Var1 = _NAME_;
  length Var2 $32;
  array _cols (*) _NUMERIC_;     /* columns that contain the correlations */
  do _i = _n_ + 1 to dim(_cols); /* iterate over STRICTLY upper-triangular values  */
     Var2 = vname(_cols[_i]);    /* get the name of this column           */
     Correlation = _cols[_i];    /* get the value of this element         */
     output;
  end;
  keep Var1 Var2 Correlation;
run;
 
proc print data=mortages noobs;
	where Correlation > 0.5 or Correlation < -0.5;   /* We show only the highest correlated */
run;



data mortages2;
	set mortages (rename=(willdefault=oldvar));
	if oldvar = 'No' then tgt = 0; else tgt = 1;  /* we trasform the target variable in numeric*/
run;

ods noproctitle;
ods graphics / imagemap=on;

proc corr data=WORK.MORTAGES2 pearson nosimple noprob plots=none;
	var tgt;
	with LoanAge LAST_UPB ORIG_RT ORIG_AMT ORIG_TRM OLTV OCLTV NUM_BO DTI CSCORE_B 
		NUM_UNIT MI_PCT CSCORE_C MI_TYPE RealGDPgrowth NominalGDPgrowth 
		Realdisposableincomegrowth Nominaldisposableincomegrowth Unemploymentrate 
		CPIinflationrate X3monthTreasuryrate X5yearTreasuryyield X10yearTreasuryyield 
		BBBcorporateyield Mortgagerate Primerate MarketVolatilityIndex 
		EuroarearealGDPgrowth Euroareainflation Euroareabilateraldollarexchanger 
		DevelopingAsiarealGDPgrowth DevelopingAsiainflation 
		DevelopingAsiabilateraldollarexc JapanrealGDPgrowth Japaninflation 
		Japanbilateraldollarexchangerate UKrealGDPgrowth UKinflation 
		UKbilateraldollarexchangerateUSD DowJonesYoY CommercialRealEstateYoY 
		HousePriceYoY LastVersusOriginal;
run;  /* we checked if the target variable is highly correlated with the others numerical variables, but it's not
so our model will have more than one explenatory variable */
