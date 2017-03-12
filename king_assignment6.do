capture log close
log using "king_assignment6.log", replace

/* PhD Research Practicum, Spring 2017*/
/* Assignment 6*/
/* Robb King*/
/* 03/11/17 */

set more off

clear

global ddir "../data/"

use ${ddir}plans2, clear


/*1. Using the plans dataset, specify a model that uses mat scores as the 
dependent variable and contains at least two interactions.*/

svyset psu [pw = f1pnlwt], strat(strat_id) singleunit(scaled)

svy: reg bynels2m female ib(freq).byrace2 byses1 ib(freq).order_plan 
eststo plans: svy: reg bynels2m female##ib(freq).byrace2 c.byses1##ib(freq).order_plan


/*2. Plot the interaction at least four different ways, using both bar plots and line plots.*/
set scheme s2color

graph hbar (mean) bynels2m, over(female, relabel(1 "Male" 2 "Female")) asyvar bar(1, col(orange*0.7)) bar (2, col(green*0.6)) over(byrace2) ///
	title("10th Grade Math Scores by Gender and Race") ///
	ytitle("10th Grade Math Scores (Mean)") b2title("Gender") ///
	graphregion(color(white)) 
graph save graph1a

graph bar (mean) bynels2m, over(female, relabel(1 "Male" 2 "Female")) asyvar bar(1, col(orange*0.7)) bar (2, col(green*0.6)) over(byrace2) ///
	title("10th Grade Math Scores by Gender and Race") ///
	ytitle("10th Grade Math Scores (Mean)") b2title("Gender") ///
	graphregion(color(white))
graph save graph2

graph twoway (lfit bynels2m byses1 if order_plan==1, lcolor(red)) ///
	(lfit bynels2m byses1 if order_plan==2, lcolor(blue)) ///
	(lfit bynels2m byses1 if order_plan==3, lcolor(green)), ///
	legend(order(1 "No Plans/DK" 2 "Votech/CC" 3 "Four Year")) ///
	title("10th Grade Math Scores by SES and Plans After HS") ///
	ytitle("10th Grade Math Scores") b2title("Plans After HS") ///
	graphregion(color(white))
graph save graph3

graph twoway (lfitci bynels2m byses1 if order_plan==1, lcolor(red)) ///
	(lfitci bynels2m byses1 if order_plan==2, lcolor(blue)) ///
	(lfitci bynels2m byses1 if order_plan==3, lcolor(green)), ///
	legend(order(2 "No Plans/DK" 4 "Votech/CC" 6 "Four Year")) ///
	title("10th Grade Math Scores by SES and Plans After HS (CI)") ///
	ytitle("10th Grade Math Scores") b2title("Plans After HS") ///
	graphregion(color(white))
graph save graph4


/*3. Create a table that shows predictions and confidence intervals from the 
complex interactions in at least two different ways.*/

estimates restore plans
eststo all: margins, predict(xb) at((mean) byses1 order_plan=(1 2 3) female=(0 1) byrace2=(1 2 3 4 5 6)) post

esttab all using all2.rtf, label nostar ci ///
	varlabels(1._at "No Plans, Avg. SES, Male, Native/Ind." ///
		2._at "Votech/CC, Avg. SES. Male, Native/Ind." ///
		3._at "Four Years, Avg. SES, Male, Native/Ind." ///
		4._at "No Plans, Avg. SES, Male, Asian" ///
		5._at "Votech/CC, Avg. SES, Male, Asian" ///
		6._at "Four Years, Avg. SES, Male, Asian" ///
		7._at "No Plans, Avg. SES, Male, Black" /// 
		8._at "Votech/CC, Avg. SES, Male, Black" ///
		9._at "Four Years, Avg. SES, Male, Black" ///
		10._at "No Plans, Avg. SES, Male, Hispanic" ///
		11._at "Votech/CC, Avg. SES, Male, Hispanic" ///
		12._at "Four Years, Avg. SES, Male, Hispanic" ///
		13._at "No Plans, Avg. SES, Male, Multiracial" ///
		14._at "Votech/CC, Avg. SES, Male, Multiracial" ///
		15._at "Four Years, Avg. SES, Male, Multiracial" ///
		16._at "No Plans, Avg. SES, Male, White" ///
		17._at "Votech/CC, Avg. SES, Male, White" ///
		18._at "Four Years, Avg. SES, Male, White" ///
		19._at "No Plans, Avg. SES, Female, Native/Ind." ///
		20._at "Votech/CC, Avg. SES. Female, Native/Ind." ///
		21._at "Four Years, Avg. SES, Female, Native/Ind." ///
		22._at "No Plans, Avg. SES, Female, Asian" ///
		23._at "Votech/CC, Avg. SES, Female, Asian" ///
		24._at "Four Years, Avg. SES, Female, Asian" ///
		25._at "No Plans, Avg. SES, Female, Black" ///
		26._at "Votech/CC, Avg. SES, Female, Black" ///
		27._at "Four Years, Avg. SES, Female, Black" ///
		28._at "No Plans, Avg. SES, Female, Hispanic" ///
		29._at "Votech/CC, Avg. SES, Female, Hispanic" ///
		30._at "Four Years, Avg. SES, Female, Hispanic" ///
		31._at "No Plans, Avg. SES, Female, Multiracial" ///
		32._at "Votech/CC, Avg. SES, Female, Multiracial" ///
		33._at "Four Years, Avg. SES, Female, Multiracial" ///
		34._at "No Plans, Avg. SES, Female, White" ///
		35._at "Votech/CC, Avg. SES, Female, White" ///
		36._at "Four Years, Avg. SES, Female, White") ///
	replace
		

estimates restore plans
eststo nat: margins, predict(xb) at((mean) byses1 order_plan=(1 2 3) female=(0 1) byrace2=1) post

estimates restore plans
eststo asi: margins, predict(xb) at((mean) byses1 order_plan=(1 2 3) female=(0 1) byrace2=2) post

estimates restore plans
eststo bla: margins, predict(xb) at((mean) byses1 order_plan=(1 2 3) female=(0 1) byrace2=3) post

estimates restore plans
eststo hisp: margins, predict(xb) at((mean) byses1 order_plan=(1 2 3) female=(0 1) byrace2=4) post

estimates restore plans
eststo multi: margins, predict(xb) at((mean) byses1 order_plan=(1 2 3) female=(0 1) byrace2=5) post

estimates restore plans
eststo whi: margins, predict(xb) at((mean) byses1 order_plan=(1 2 3) female=(0 1) byrace2=6) post


esttab nat asi bla hisp multi whi using margins5.rtf, label nostar ci ///
	varlabels(1._at "No Plans & Avg SES, Male" ///
		2._at "Votech/CC & Avg SES, Male" ///
		3._at "Four Year & Avg SES, Male" ///
		4._at "No Plans & Avg SES, Female" ///
		5._at "Votech/CC & Avg SES, Female" ///
		6._at "Four Year & Avg SES, Female") ///
	replace

exit









