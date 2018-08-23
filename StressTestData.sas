ods listing close;

data stress_test;
input repl A B C toler_mins;
label A="Gender"
      B="Body Fat Level"
	  C="Smoking History";
	  toler_mins= "Tolerance Minutes";
datalines;
1 -1 -1 -1 24.1
1 1 -1 -1 20.0
1 -1 1 -1 14.6
1 1 1 -1 16.1
1 -1 -1 1 17.6
1 1 -1 1 14.8
1 -1 1 1 14.9
1 1 1 1 10.1
2 -1 -1 -1 29.2
2 1 -1 -1 21.9
2 -1 1 -1 15.3
2 1 1 -1 9.3
2 -1 -1 1 18.8
2 1 -1 1 10.3
2 -1 1 1 20.4
2 1 1 1 14.4
3 -1 -1 -1 24.6
3 1 -1 -1 17.6
3 -1 1 -1 12.3
3 1 1 -1 10.8
3 -1 -1 1 23.2
3 1 -1 1 11.3
3 -1 1 1 12.8
3 1 1 1 6.1
;
run;

proc means mean;
 var toler_mins;
run;

proc means mean;
 var toler_mins;
 class A;
run;

proc means mean;
 var toler_mins;
 class B;
run;

proc means mean;
 var toler_mins;
 class C;
run;

proc means mean;
 var toler_mins;
 class A B;
run;

proc means mean;
 var toler_mins;
 class A C;
run;

proc means mean;
 var toler_mins;
 class B C;
run;

proc means mean;
 var toler_mins;
 class A B C;
run;

ods listing close;


proc glm data=stress_test;
class A B C;
model toler_mins=A|B|C;
output out=temp1 r=resid p=predict student=sresid;
means A B C /tukey;
means B*C;
run;
quit;

goptions reset=all;
symbol v=dot c=black h=.8;
proc gplot data=temp1;
 plot resid*predict /name='RvsFV';
 title "Residuals vs. Fitted Values";
run;
quit;
proc univariate data=temp1 noprint;
 var resid;
 probplot resid /vaxislabel="Residual" odstitle= "Probability Plot of Ordered Residuals" name="ProbPlot";
run;


goption display;
proc greplay nofs tc=sashelp.templt template=l2r1;
   igout gseg;
     treplay 1:RvsFV 2:ProbPlot;
run;
quit;


/*A, B, C, BC significant*/
/*AB, AC, ABC not significant*/




/*Interaction Plot for BC */
proc glm;
class B C;
model toler_mins=B|C;
run;
quit;

/*Reduced Model*/
proc glm data=stress_test;
class A B C;
model toler_mins=A B C B*C;
means A /tukey;
means B*C;
estimate 'Male vs. Female' A 1 -1;
output out=temp1 r=resid p=predict;
run;
quit;

goptions reset=all;
symbol v=dot c=blue h=.8;
proc gplot data=temp1;
 plot resid*predict;
run;
quit;
proc univariate data=temp1 noprint;
 var resid;
 probplot resid;
run;
