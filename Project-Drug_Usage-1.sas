libname drug base "/home/u47236280/Project-Drug_Usage";
/*In this project we try to use Logistic regression to perform supervised classification to identify
if a subject is a drug (Cannabis) user or not. In Logistic Regression, we model the probability
of a case being drug user based on different characteristic or demographic features of that case.
The predicted posterior probabilities from the Logistic regression model is a nonlinear
function of the input variables. To linearize the model, we use logit transformation that measures the
log odds of the posterior probability which is a linear function of the input function just as in
linear regression. */

/*Importing Data into csv file*/
data drug.drug_usage;
	infile "/home/u47236280/Project-Drug_Usage/drug_consumption.data" dlm=',' dsd;
	input id Age $ Gender $ Education $ Country $ Ethnicity $
	Neuroticism Extraversion Openness Agreeableness Conscientiousness
	Impulsiveness Sensation Alcohol $ Amphet $ Amyl $ Benzos $
	Caff $ Cannabis $ Choc $ Coke $ Crack $ Ecstasy $ Heroin $ 
	Ketamine $ Legalh $ LSD $ Meth $ Mushrooms $ Nicotine $
	Semer $ VSA $;
run;

/*Filtering only the columns that are needed in the model. Since we are going to 
to predict the usage of Cannabis using Logistic Regression, we will fiter the
required columns from dataset.*/

data drug.drug_usage;
	set drug.drug_usage;
	keep id Age Gender Education Country Ethnicity Neuroticism Extraversion
	Openness Agreeableness Conscientiousness Impulsiveness Sensation Cannabis;
run;

/*DATA WRANGLING*/
/*Cleaning the Data. Renaming the values in each columns according to the data 
description provided on the website: https://archive.ics.uci.edu/ml/datasets/Drug+consumption+%28quantified%29#
*/
/*Renaming the values in Age column*/
data drug.drug_usage;
	set drug.drug_usage;
	if Age='-0.95197' then Age= '18-24';
	else if Age= '-0.07854' then Age= '25-34';
	else if Age= '0.49788' then Age= '35-44';
	else if Age= '1.09449' then Age= '45-54';
	else if Age= '1.82213' then Age= '55-64';
	else if Age= '2.59171' then Age= '65+';
run;

/*Renaming the values in Gender column*/

data drug.drug_usage;
	set drug.drug_usage;
	if Gender= '0.48246' then Gender= 'Female';
	else if Gender= '-0.48246' then Gender= 'Male';
run;

/*Renaming the values in Education column*/

data drug.drug_usage;
	set drug.drug_usage(rename=(Education=nEducation));
	length Education $ 60;
	if nEducation= '-2.43591' then Education= 'Left school before 16 years';
	else if nEducation= '-1.73790' then Education= 'Left school at 16 years';
	else if nEducation= '-1.43719' then Education= 'Left school at 17 years';
	else if nEducation= '-1.22751' then Education= 'Left school at 18 years';
	else if nEducation= '-0.61113' then Education= 'Some college or university, no certificate or degree';
	else if nEducation= '-0.05921' then Education= 'Professional certificate/ diploma';
	else if nEducation= '0.45468' then Education= 'University degree';
	else if nEducation= '1.16365' then Education= 'Masters degree';
	else if nEducation= '1.98437' then Education= 'Doctorate degree';
	drop nEducation;
run;

/*Renaming the values in Country column*/
data drug.drug_usage;
	set drug.drug_usage(rename=(Country=nCountry));
	length Country $ 20;
	if nCountry= '-0.09765' then Country= 'Australia';
	else if nCountry= '0.24923' then Country= 'Canada';
	else if nCountry= '-0.46841' then Country= 'New Zealand';
	else if nCountry= '-0.28519' then Country= 'Other';
	else if nCountry= '0.21128' then Country = 'Republic of Ireland';
	else if nCountry= '0.96082' then Country= 'UK';
	else if nCountry= '-0.57009' then Country= 'USA';
	drop nCountry;
run;

/*Renaming the values in Ethnicity column*/

data drug.drug_usage;
	set drug.drug_usage (rename=(Ethnicity=nEthnicity));
	length Ethnicity $ 30;
	if nEthnicity= '-0.50212' then Ethnicity='Asian';
	else if nEthnicity= '-1.10702' then Ethnicity= 'Black';
	else if nEthnicity= '1.90725' then Ethnicity= 'Mixed-Black/Asian';
	else if nEthnicity= '0.12600' then Ethnicity= 'Mixed-White/Asian';
	else if nEthnicity= '-0.22166' then Ethnicity= 'Mixed-White/Black';
	else if nEthnicity= '0.11440' then Ethnicity= 'Other';
	else if nEthnicity= '-0.31685' then Ethnicity= 'White';
	drop nEthnicity;
run;

/*Reassigning the Neuroticism column values*/

data drug.drug_usage;
	set drug.drug_usage;
	if Neuroticism= -3.46436 then Neuroticism= 12;
	else if Neuroticism= -0.67825 then Neuroticism=29;
	else if Neuroticism=1.02119 then Neuroticism=46;
	else if Neuroticism=-3.15735 then Neuroticism=13;
	else if Neuroticism=-0.58016 then Neuroticism=30;
	else if Neuroticism=1.13281 then Neuroticism=47;
	else if Neuroticism=-2.75696 then Neuroticism=14;
	else if Neuroticism=-0.46725 then Neuroticism=31;
	else if Neuroticism=1.23461 then Neuroticism=48;
	else if Neuroticism=-2.52197 then Neuroticism=15;
	else if Neuroticism=-0.34799 then Neuroticism=32;
	else if Neuroticism=1.37297 then Neuroticism=49;
	else if Neuroticism=-2.42317 then Neuroticism=16;
	else if Neuroticism=-0.24649 then Neuroticism=33;
	else if Neuroticism=1.49158 then Neuroticism=50;
	else if Neuroticism=-2.34360 then Neuroticism=17;
	else if Neuroticism=-0.14882 then Neuroticism=34;
	else if Neuroticism=1.60383 then Neuroticism=51;
	else if Neuroticism= -2.21844 then Neuroticism=18;
	else if Neuroticism= -0.05188 then Neuroticism=35;
	else if Neuroticism= 1.72012 then Neuroticism=52;
	else if Neuroticism=-2.05048 then Neuroticism=19;
	else if Neuroticism= 0.04257 then Neuroticism= 36;
	else if Neuroticism=1.83990 then Neuroticism= 53;
	else if Neuroticism=  -1.86962 then Neuroticism=20;
	else if Neuroticism=0.13606 then Neuroticism= 37;
	else if Neuroticism=1.98437 then Neuroticism=54;
	else if Neuroticism=-1.69163 then Neuroticism=21;
	else if Neuroticism=0.22393 then Neuroticism=38;
	else if Neuroticism=2.12700 then Neuroticism=55;
	else if Neuroticism= -1.55078 then Neuroticism=22;
	else if Neuroticism= 0.31287 then Neuroticism=39;
	else if Neuroticism=2.28554 then Neuroticism=56;
	else if Neuroticism=-1.43907 then Neuroticism=23;
	else if Neuroticism=0.41667 then Neuroticism=40;
	else if Neuroticism= 2.46262 then Neuroticism= 57;
	else if Neuroticism=-1.32828 then Neuroticism=24;
	else if Neuroticism= 0.52135 then Neuroticism=41;
	else if Neuroticism= 2.61139 then Neuroticism=58;
	else if Neuroticism= -1.19430 then Neuroticism=25;
	else if Neuroticism=0.62967 then Neuroticism=42;
	else if Neuroticism=2.82196 then Neuroticism=59;
	else if Neuroticism=-1.05308 then Neuroticism=26;
	else if Neuroticism=0.73545 then Neuroticism=43;
	else if Neuroticism=3.27393 then Neuroticism=60;
	else if Neuroticism=-0.92104 then Neuroticism=27;
	else if Neuroticism=0.82562 then Neuroticism=44;
	else if Neuroticism=-0.79151 then Neuroticism=28;
	else if Neuroticism=0.91093 then Neuroticism=45;
run;


/*Reassigning the values of Extraversion column*/

data drug.drug_usage;
	set drug.drug_usage;
	if Extraversion=-3.27393 then Extraversion=16;
	else if Extraversion= -1.23177 then Extraversion=31;
	else if Extraversion=0.80523 then Extraversion=45;
	else if Extraversion= -3.00537 then Extraversion=18;
	else if Extraversion= -1.09207 then Extraversion=32;
	else if Extraversion=  0.96248 then Extraversion=46;
	else if Extraversion=  -2.72827 then Extraversion=19;
	else if Extraversion=-0.94779 then Extraversion=33;
	else if Extraversion=-1.11406 then Extraversion=47;
	else if Extraversion=-2.53830 then Extraversion=20;
	else if Extraversion=-0.80615 then Extraversion=34;
	else if Extraversion=1.28610 then Extraversion=48;
	else if Extraversion=-2.44904 then Extraversion=21;
	else if Extraversion=-0.69509 then Extraversion=35;
	else if Extraversion=1.45421 then Extraversion=49;
	else if Extraversion=-2.32338 then Extraversion=22;
	else if Extraversion= -0.57545 then Extraversion=36;
	else if Extraversion=1.58487 then Extraversion=50;
	else if Extraversion=-2.21069 then Extraversion=23;
	else if Extraversion=-0.43999 then Extraversion=37;
	else if Extraversion=1.74091 then Extraversion=51;
	else if Extraversion=-2.11437 then Extraversion=24;
	else if Extraversion=-0.30033 then Extraversion=106;
	else if Extraversion=1.93886 then Extraversion=52;
	else if Extraversion=-2.03972 then Extraversion=25;
	else if Extraversion=-0.15487 then Extraversion=39;
	else if Extraversion=2.12700 then Extraversion=53;
	else if Extraversion= -1.92173 then Extraversion=26;
	else if Extraversion=0.00332 then Extraversion=40;
	else if Extraversion=2.32338 then Extraversion=54;
	else if Extraversion=-1.76250 then Extraversion=27;
	else if Extraversion=0.16767 then Extraversion=41;
	else if Extraversion=2.57309 then Extraversion=55;
	else if Extraversion=-1.63340 then Extraversion=28;
	else if Extraversion=0.32197 then Extraversion=42;
	else if Extraversion=2.85950 then Extraversion=56;
	else if Extraversion=-1.50796 then Extraversion=29;
	else if Extraversion=0.47617 then Extraversion=43;
	else if Extraversion=3.00537 then Extraversion=58;
	else if Extraversion=-1.37639 then Extraversion=30;
	else if Extraversion=0.63779 then Extraversion=44;
	else if Extraversion=3.27393 then Extraversion=59;
run;
	
/*Reassigning the values in Openness column*/
data drug.drug_usage;
	set drug.drug_usage;
	if Openness=-3.27393 then Openness=24;
	else if Openness=-1.11902 then Openness=38;
	else if Openness= 0.58331 then Openness=50;
	else if Openness= -2.85950 then Openness=26;
	else if Openness= -0.97631 then Openness=39;
	else if Openness= 0.72330 then Openness= 51;
	else if Openness= -2.63199 then Openness= 28;
	else if Openness= -0.84732 then Openness= 40;
	else if Openness= 0.88309 then Openness= 52;
	else if Openness= -2.39883 then Openness=29;
	else if Openness=-0.71727 then Openness=41;
	else if Openness=1.06238 then Openness=53;
	else if Openness=-2.21069 then Openness=30;
	else if Openness= -0.58331 then Openness=42;
	else if Openness= 1.24033 then Openness=54;
	else if Openness=-2.09015 then Openness=31;
	else if Openness=-0.45174 then Openness=43;
	else if Openness= 1.43533 then Openness=55;
	else if Openness= -1.97495 then Openness=32;
	else if Openness=-0.31776 then Openness=44;
	else if Openness=1.65653 then Openness=56;
	else if Openness=-1.82919 then Openness=33;
	else if Openness=-0.17779 then Openness=45;
	else if Openness=1.88511 then Openness=57;
	else if Openness=-1.68062 then Openness=34;
	else if Openness=-0.01928 then Openness=46;
	else if Openness=2.15324 then Openness=58;
	else if Openness=-1.55521 then Openness=35;
	else if Openness=0.14143 then Openness=47;
	else if Openness=2.44904 then Openness=59;
	else if Openness=-1.42424 then Openness=36;
	else if Openness=0.29338 then Openness=48;
	else if Openness=2.90161 then Openness=60;
	else if Openness= -1.27553 then Openness=37;
	else if Openness=0.44585 then Openness=49;
run;
	
/*Reassigning the values in Agreeableness column*/

data drug.drug_usage;
	set drug.drug_usage;
	if Agreeableness=-3.46436 then Agreeableness=12;
	else if Agreeableness=-1.34289 then Agreeableness=34;
	else if Agreeableness=0.76096 then Agreeableness=48;
	else if Agreeableness=-3.15735 then Agreeableness=16;
	else if Agreeableness=-1.21213 then Agreeableness=35;
	else if Agreeableness=0.94156 then Agreeableness=49;
	else if Agreeableness=-3.00537 then Agreeableness=18;
	else if Agreeableness= -1.07533 then Agreeableness=36;
	else if Agreeableness=1.11406 then Agreeableness=50;
	else if Agreeableness=-2.90161 then Agreeableness=23;
	else if Agreeableness=-0.91699 then Agreeableness=37;
	else if Agreeableness=1.2861 then Agreeableness=51;
	else if Agreeableness=-2.78793 then Agreeableness=24;
	else if Agreeableness= -0.76096 then Agreeableness=38;
	else if Agreeableness=1.45039 then Agreeableness=52;
	else if Agreeableness=-2.70172 then Agreeableness=25;
	else if Agreeableness=-0.60633 then Agreeableness=39;
	else if Agreeableness=1.61108 then Agreeableness=53;
	else if Agreeableness=-2.53830 then Agreeableness=26;
	else if Agreeableness=-0.45321 then Agreeableness=40;
	else if Agreeableness=1.81866 then Agreeableness=54;
	else if Agreeableness=-2.35413 then Agreeableness=27;
	else if Agreeableness=-0.30172 then Agreeableness=41;
	else if Agreeableness=2.03972 then Agreeableness=55;
	else if Agreeableness=-2.21844 then Agreeableness=28;
	else if Agreeableness=-0.15487 then Agreeableness=42;
	else if Agreeableness=2.23427 then Agreeableness=56;
	else if Agreeableness=-2.07848 then Agreeableness=29;
	else if Agreeableness= -0.01729 then Agreeableness=43;
	else if Agreeableness=2.46262 then Agreeableness=57;
	else if Agreeableness=-1.92595 then Agreeableness=30;
	else if Agreeableness=0.13136 then Agreeableness=44;
	else if Agreeableness=2.75696 then Agreeableness=58;
	else if Agreeableness= -1.77200 then Agreeableness=31;
	else if Agreeableness=0.28783 then Agreeableness=45;
	else if Agreeableness=3.15735 then Agreeableness=59;
	else if Agreeableness=-1.62090 then Agreeableness=32;
	else if Agreeableness=0.43852 then Agreeableness=46;
	else if Agreeableness=3.46436 then Agreeableness=60;
	else if Agreeableness=-1.47955 then Agreeableness=33;
	else if Agreeableness=0.59042 then Agreeableness=47;
run;
	
/*Reassigning values in the Conscientiousness column*/
	
data drug.drug_usage;
	set drug.drug_usage;
	if Conscientiousness=-3.46436 then Conscientiousness=17;
	else if Conscientiousness=-1.25773 then Conscientiousness=32;
	else if Conscientiousness=0.58489 then Conscientiousness=46;
	else if Conscientiousness=-3.15735 then Conscientiousness=19;
	else if Conscientiousness=-1.13788 then Conscientiousness=33;
	else if Conscientiousness=0.7583 then Conscientiousness=47;
	else if Conscientiousness= -2.90161 then Conscientiousness=20;
	else if Conscientiousness=-1.01450 then Conscientiousness=34;
	else if Conscientiousness=0.93949 then Conscientiousness=48;
	else if Conscientiousness=-2.72827 then Conscientiousness=21;
	else if Conscientiousness=-0.89891 then Conscientiousness=35;
	else if Conscientiousness= 1.13407 then Conscientiousness=49;
	else if Conscientiousness=-2.57309 then Conscientiousness=22;
	else if Conscientiousness=-0.78155 then Conscientiousness=36;
	else if Conscientiousness=1.30612 then Conscientiousness=50;
	else if Conscientiousness=-2.42317 then Conscientiousness=23;
	else if Conscientiousness=-0.65253 then Conscientiousness=37;
	else if Conscientiousness=1.46191 then Conscientiousness=51;
	else if Conscientiousness=-2.30408 then Conscientiousness=24;
	else if Conscientiousness=-0.52745 then Conscientiousness=38;
	else if Conscientiousness=1.63088 then Conscientiousness=52;
	else if Conscientiousness= -2.18109 then Conscientiousness=25;
	else if Conscientiousness= -0.40581 then Conscientiousness=39;
	else if Conscientiousness=1.81175 then Conscientiousness=53;
	else if Conscientiousness=-2.04506 then Conscientiousness=26;
	else if Conscientiousness=-0.27607 then Conscientiousness=40;
	else if Conscientiousness=2.04506 then Conscientiousness=54;
	else if Conscientiousness=-1.92173 then Conscientiousness=27;
	else if Conscientiousness=-0.14277 then Conscientiousness=41;
	else if Conscientiousness=2.33337 then Conscientiousness=55;
	else if Conscientiousness= -1.78169 then Conscientiousness=28;
	else if Conscientiousness= -0.00665 then Conscientiousness=42;
	else if Conscientiousness=2.63199 then Conscientiousness=56;
	else if Conscientiousness= -1.64101 then Conscientiousness=29;
	else if Conscientiousness=0.12331 then Conscientiousness=43;
	else if Conscientiousness=3.00537 then Conscientiousness=57;
	else if Conscientiousness=-1.51840 then Conscientiousness=30;
	else if Conscientiousness=0.25953 then Conscientiousness=44;
	else if Conscientiousness=3.46436 then Conscientiousness=59;
	else if Conscientiousness=-1.38502 then Conscientiousness=31;
	else if Conscientiousness=0.41594 then Conscientiousness=45;
run;
/*Creating a Custom picture format to insert text in to numerical columns*/
proc format;
	picture pct (default=20)
	low-high = '9.99%';
run;

/*Reassigning values in the Impulsiveness columns*/
data drug.drug_usage;
	set drug.drug_usage;
	*length Impulsiveness $ 8;
	if Impulsiveness=-2.55524 then Impulsiveness=1.06;
	else if Impulsiveness=-1.37983 then Impulsiveness=14.64;
	else if Impulsiveness= -0.71126 then Impulsiveness= 16.29;
	else if Impulsiveness= -0.21712 then Impulsiveness= 18.83;
	else if Impulsiveness= 0.19268 then Impulsiveness= 13.63;
	else if Impulsiveness= 0.52975 then Impulsiveness= 11.46;
	else if Impulsiveness= 0.88113 then Impulsiveness= 10.34;
	else if Impulsiveness= 1.29221 then Impulsiveness= 7.85;
	else if Impulsiveness= 1.86203 then Impulsiveness= 5.52;
	else if Impulsiveness= 2.90161 then Impulsiveness= 0.37;
	format Impulsiveness pct.;
run;
/*Reassigning values in the Sensation column*/
data drug.drug_usage;
	set drug.drug_usage;
	if Sensation=-2.07848 then Sensation=3.77;
	else if Sensation=-1.54858 then Sensation=4.62;
	else if Sensation=-1.18084 then Sensation=7.00;
	else if Sensation=-0.84637 then Sensation=8.97;
	else if Sensation=-0.52593 then Sensation=11.19;
	else if Sensation=-0.21575 then Sensation=11.83;
	else if Sensation=0.07987 then Sensation=11.62;
	else if Sensation=0.40148 then Sensation=13.21;
	else if Sensation=0.76540 then Sensation=11.19;
	else if Sensation=1.22470 then Sensation=11.14;
	else if Sensation=1.92173 then Sensation=5.46;
	format Sensation pct.;
run;

data drug.drug_usage;
	set drug.drug_usage;
	if Cannabis= 'CL0' or Cannabis= 'CL1' then Cannabis= '0';
	else Cannabis='1';
run;

data drug.drug_usage;
	set drug.drug_usage(rename=(Cannabis=nCannabis));
	if nCannabis='0' then Cannabis= input(nCannabis, 1.);
	else if nCannabis='1' then Cannabis= input(nCannabis, 1.);
	drop nCannabis;
run;

ods rtf file="/home/u47236280/Project-Drug_Usage/Project_Logistic_Regression.docx";
proc print data= drug.drug_usage (obs=20);
run;

proc freq data=drug.drug_usage;
tables (Age Gender Education Country Ethnicity)*Cannabis/
plots=freqplot(scale=percent);
run;

proc means data=drug.drug_usage;
var _numeric_;
run;

proc freq data=drug.drug_usage;
tables Neuroticism;
run;

/*Distribution of Cannabis seems to vary in different age groups. The highest amount of drug usage
is found in early age groups of 18-24 and 25-34. It seems to reduce in later ages. Those above between
55 and 64 age groups shows highly reduced level of drug usage and those above 65+ hardly show
any drug usage.*/
/*Among the different gender groups, male shows much higher drug usage than females.*/
/*When looking at the distribution of drug users and non-users at various levels of Education,
it seems like those went to some College or University but did not attain a degree tend to show
the largest amount of drug consumption. It might be the reason that these people get demotivated 
and start taking drugs and are not able to complete the degree. After that those who complete University
tend to show high drug usage followed by those who attain a Professional diploma or certificate and those who
are in Masters program. This clearly shows drugs are mainly used among those who are affliated to higher 
level academic educational institutes.*/
/*It is also seen that drug consumption is very higher at higher percentages of impulsiveness
such as 6.29% and 8.83%.*/
/*The drug consumption is also highest for those who show sensation at 1.19% and 3.21%.*/
/*Among the different Countries, USA and UK shows highest amount of drug usage.*/
/*Among different ethnic groups, those belonging to White Ethnicity shows the highest and extremely large
amount of drug consumption.*/
/*Also we see several cases of Quasi complete separation where we have 100% of drug assumptions in
certain categorical levels of the categorical input variables such as Country, and Ethnicity.
This will give problems when trying to fit a Logistic Regression model as the model will not converge as the
maximum liklihood estimation function will lead to infinite probability for that level leading to an infinite
parameter estimate for that level. Therefore, to avoid that problem, we will use Smoothed weight of evidence
method to convert the categorical column to numerical columns.*/

/*Now we would like to perform the chi-square test of association between the categorical variables and the
the target variable Cannabis.*/

proc freq data=drug.drug_usage;
	tables (Age Gender Education Country Ethnicity)*Cannabis/
	chisq expected cellchi2 nocol nopercent relrisk;
run;

/*Chi-Square test of Association shows a significant association between the categorical variables:
Age, Gender, Impulsiveness, Sensation, Country, and Ethnicity with the target response variable Cannabis with 
a significant p-value for the chi-square statistics. This shows that the difference in the distribution
of Cannabis users and non-users among different levels of the categorical variables is significant 
at a significance level of 0.05.*/ 

/*Now we will try to first split the dataset in to training and
validation dataset using proc surveyselect. */

proc sort data=drug.drug_usage out=drug.drug_usage1;
by Cannabis;
run;

/*When we do stratified sampling, we basically separate sample or oversample the events in the training and 
validation data set*/



proc surveyselect data=drug.drug_usage1 samprate=0.6667 seed=1256345
out=drug.drug_usage_split outall;
strata Cannabis;
run;


data drug.drug_usage_train drug.drug_usage_valid;
	set drug.drug_usage_split;
	if selected then output drug.drug_usage_train;
	else output drug.drug_usage_valid;
run;
/*For numerical or ordinal variables, we would like to verify if the relationship with the target response 
variable is linear/ monotonic or nonlinear/ nonmontonic.
The variables that shows high spearmann correlation statistics will show a linear/ monotonic
association with the target variable regardless of the Hoeffding statistics.
But those variables which shows low value for Spearmann correlation statistic and high value of 
Hoeffding statistics shows a nonlinear/ non-monotonic association with the target variable.
For this, we will compute the spearmann and hoeffding correlation statistics which shows association between the rank orders of two ordinal variables.
The spearmann and hoeffding statistics will be rank ordered in the descending order. A plot of spearmann and
hoeffding ranks will then plotted to determine those variables with high spearmann rank (corresponding to
low spearmann correlation statistic) and low hoeffding rank (corrresponding to high hoeffding correlation
statistic). These variables are nonmonotonic in nature.*/
%let intervall= Neuroticism Agreeableness Openness Extraversion Conscientiousness Impulsiveness Sensation;
ods select none;
ods output spearmancorr=drug.spearmann
		hoeffdingcorr=drug.hoeffding;
proc corr data=drug.drug_usage_train spearman hoeffding;
	var Cannabis;
	with &intervall;
run;

ods select all;

proc sort data=drug.spearmann;
by variable;
run;

proc sort data=drug.hoeffding;
by variable;
run;

data drug.correlations;
	merge drug.spearmann(rename=(Cannabis=scorr PCannabis=P_scorr))
	 drug.hoeffding(rename=(Cannabis=hcorr PCannabis=P_hcorr));
	 by variable;
	 scorr= abs(scorr);
	 hcorr=abs(hcorr);
run;

proc rank data=drug.correlations descending out=drug.correlation1;
var scorr hcorr;
ranks ranksp rankho;
run;

proc sql noprint;
	select min(ranksp) into :minsc from (select ranksp from drug.correlation1 where P_scorr>0.005);
	select min(rankho) into :minhf from (select rankho from drug.correlation1 where P_hcorr>0.05);
quit;

/*We can see that in correlations table, the spearman correlation statistic has the smallest p-value
as 0.008. Therefore, we choose the minimum boundary line to separate the variables with higher spearman ranks
or lower spearman correlation statistics at 0.005 in the scatter plot of spearman and hoeffding ranks.
From the correlations table, we definitely see that all the variables shows a significant association
with target response variable at a significance of 0.05. However, the value of Spearman correlation
statistic is not very large. Therefore, it is a relatively weaker association. Therefore, we choose
0.005 as significance level to draw the boundary line for including variables in the model. The variables
with high spearman and hoeffding ranks (that is with high spearman and correlation statistics) are extremely
weak predictors and can be excluded from the model development process.*/

proc sgplot data=drug.correlation1;
	refline &minsc / axis=y;
	refline &minhf / axis=x;
	scatter y=ranksp x=rankho/ datalabel=variable;
	yaxis label="Rank of Spearmann";
	xaxis label="Rank of Hoeffding";
run;

/*From the scatter plot, it is evident that Extraversion is a relatively weaker predictor of target variable
Cannabis and will therefore, be excluded from the model. */

proc print data=drug.correlation1;
run;

proc rank data=drug.drug_usage_train groups=50 out=drug.agree;
var Agreeableness;
ranks agree;
run;

proc means data=drug.agree sum;
class agree;
var Cannabis;
output out=drug.agg sum=Can_events;
run;
proc sql;
	select mean(Cannabis) into :rho1 from drug.drug_usage_train;
run;
data drug.agg;
	set drug.agg;
	elogit= log((Can_events+(sqrt(_Freq_)/2))/(_Freq_ - (Can_events)+(sqrt(_Freq_)/2)));
run; 

proc sgplot data=drug.agg;
	reg Y=elogit X= agree/
	curvelabel= "Linear Relationship of Elogit vs Agreeableness"
	Curvelabelloc=outside
	lineattrs=(color=ligr);
	series Y=elogit X=agree;
run;
	
proc rank data=drug.drug_usage_train groups=50 out=drug.open;
var Openness;
ranks open;
run;

proc means data=drug.open sum;
class open;
var Cannabis;
output out=drug.opens sum=Can_events;
run;

data drug.opens;
	set drug.opens;
	elogit= log((Can_events+(sqrt(_Freq_)/2))/(_Freq_ - (Can_events)+(sqrt(_Freq_)/2)));
run; 

proc sgplot data=drug.opens;
	reg Y=elogit X= open/
	curvelabel= "Linear Relationship of Elogit vs Openness"
	Curvelabelloc=outside
	lineattrs=(color=ligr);
	series Y=elogit X=open;
run;

proc rank data=drug.drug_usage_train groups=50 out=drug.cons;
var Conscientiousness;
ranks cons;
run;

proc means data=drug.cons sum;
class cons;
var Cannabis;
output out=drug.cons1 sum=Can_events;
run;

data drug.cons1;
	set drug.cons1;
	elogit= log((Can_events+(sqrt(_Freq_)/2))/(_Freq_ - (Can_events)+(sqrt(_Freq_)/2)));
run; 

proc sgplot data=drug.cons1;
	reg Y=elogit X= cons/
	curvelabel= "Linear Relationship of Elogit vs Conscientiousness"
	Curvelabelloc=outside
	lineattrs=(color=ligr);
	series Y=elogit X=cons;
run;


proc rank data=drug.drug_usage_train groups=50 out=drug.neuro;
var Neuroticism;
ranks neuro;
run;

proc means data=drug.neuro sum;
class neuro;
var Cannabis;
output out=drug.neur sum=Can_events;
run;

data drug.neur;
	set drug.neur;
	elogit= (Can_events+(sqrt(_Freq_)/2))/(_Freq_ - (Can_events)+(sqrt(_Freq_)/2));
run; 

proc sgplot data=drug.neur;
	reg Y=elogit X= neuro/
	curvelabel= "Linear Relationship of Elogit vs Neuroticism"
	Curvelabelloc=outside
	lineattrs=(color=ligr);
	series Y=elogit X=neuro;
run;

proc means data=drug.drug_usage_train sum;
class Impulsiveness;
var Cannabis;
output out=drug.impulse sum=Can_events;
run;
proc sql;
	select mean(Cannabis) into :rho1 from drug.drug_usage_train;
run;
data drug.impulse;
	set drug.impulse;
	elogit= log((Can_events+(sqrt(_Freq_)/2))/(_Freq_ - (Can_events)+(sqrt(_Freq_)/2)));
run; 

proc sgplot data=drug.impulse;
	reg Y=elogit X= Impulsiveness/
	curvelabel= "Linear Relationship of Elogit vs Agreeableness"
	Curvelabelloc=outside
	lineattrs=(color=ligr);
	series Y=elogit X=Impulsiveness;
run;

proc means data=drug.drug_usage_train sum;
class Sensation;
var Cannabis;
output out=drug.sens sum=Can_events;
run;
proc sql;
	select mean(Cannabis) into :rho1 from drug.drug_usage_train;
run;
data drug.sens;
	set drug.sens;
	elogit= log((Can_events+(sqrt(_Freq_)/2))/(_Freq_ - (Can_events)+(sqrt(_Freq_)/2)));
run; 

proc sgplot data=drug.sens;
	reg Y=elogit X= Sensation/
	curvelabel= "Linear Relationship of Elogit vs Agreeableness"
	Curvelabelloc=outside
	lineattrs=(color=ligr);
	series Y=elogit X=Sensation;
run;
	

/*We can see from above plots of adjusted log odds of the events (i.e. drug usage) vs different
ordinal features such as Agreeableness, Openness, Conscientiousness and Neurotocism after
binning these variables into groups or bins is approximately linear with some deviations possibly due to 
sampling variability. Therefore, instead of using the actual variables, we will use the binned variables
in the final model. For that we create a dataset that will contain the binned variables for 
Agreeableness, Openness, Conscientiousness and Neurotocism. We first write set of rules to a SAS file 
and then include that file in a dataset to create binned variables.
However, for variables such as Impulsiveness and Sensation, there seems to be a non-monotonic relation.
Even though Logistic regression assumes a linear relation between input variables and the predicted
logits (or log odds), it has been seen that Logistic Regression is a fairly robust model towards such
non-linearity occurences. Therefore, we will continue to fit a logistic regression model to the data.*/

proc means data=drug.neuro noprint;
class neuro;
var Neuroticism;
ways 1;
output out=work.neuro1 max=max;
run;


filename rfile1 "/home/u47236280/Project-Drug_Usage/binned1.sas";

data _null_;
	file rfile1;
	set work.neuro1 end=last;
	if _n_=1 then put "select;";
	if not last then do;
	put " when ( Neuroticism <= " max ") B_neuro = " neuro ";";
	end;
	if last then do;
	put " otherwise B_neuro = " neuro ";"/ "end;";
	end;
run;

data drug.drug_usage_n;
	set drug.drug_usage_train;
	%include rfile1/source2;
run;


proc means data=drug.cons noprint;
class cons;
var Conscientiousness;
ways 1;
output out=work.conss max=max;
run;


filename rfile2 "/home/u47236280/Project-Drug_Usage/binned2.sas";

data _null_;
	file rfile2;
	set work.conss end=last;
	if _n_=1 then put "select;";
	if not last then do;
	put " when ( Conscientiousness <= " max ") B_cons = " cons ";";
	end;
	if last then do;
	put " otherwise B_cons = " cons ";"/ "end;";
	end;
run;

data drug.drug_usage_n;
	set drug.drug_usage_n;
	%include rfile2/source2;
run;


proc means data=drug.open noprint;
class open;
var Openness;
ways 1;
output out=work.openn max=max;
run;


filename rfile3 "/home/u47236280/Project-Drug_Usage/binned3.sas";

data _null_;
	file rfile3;
	set work.openn end=last;
	if _n_=1 then put "select;";
	if not last then do;
	put " when ( Openness <= " max ") B_open = " open ";";
	end;
	if last then do;
	put " otherwise B_open = " open ";"/ "end;";
	end;
run;

data drug.drug_usage_n;
	set drug.drug_usage_n;
	%include rfile3/source2;
run;

proc means data=drug.agree noprint;
class agree;
var Agreeableness;
ways 1;
output out=work.agree1 max=max;
run;


filename rfile4 "/home/u47236280/Project-Drug_Usage/binned4.sas";

data _null_;
	file rfile4;
	set work.agree1 end=last;
	if _n_=1 then put "select;";
	if not last then do;
	put " when ( Agreeableness <= " max ") B_agree = " agree ";";
	end;
	if last then do;
	put " otherwise B_agree = " agree ";"/ "end;";
	end;
run;

data drug.drug_usage_n;
	set drug.drug_usage_n;
	%include rfile4/source2;
run;


ods rtf close;


	












	
	
	



























	












