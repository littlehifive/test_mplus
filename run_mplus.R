library(MplusAutomation)
dat <- haven::read_dta("/Users/michaelfive/Box/Box 3EA Team Folder/3EA Analysis/3EA Lebanon_Analysis/Lebanon_Y1_FA/LBY1B_PREIMPUTED_FULL_SPREAD_10-31-2019_mplus.dta")

test <- mplusObject(
  TITLE = "LBY1 Baseline Factor Analysis",
  VARIABLE = "   

 Usevariables are
      PSRA1-PSRA10 PSRA11 PSRA12 PSRA13;
 
 Categorical is    
      PSRA1-PSRA10 PSRA11 PSRA12 PSRA13 ;
 
    Cluster is LOCIDY1N;
    
    Subpopulation is half eq 0;",
  ANALYSIS = "Type = complex;
   Estimator =wlsmv;",
  
  MODEL = "PSRA by PSRA1* PSRA2-PSRA10 PSRA11 PSRA12 PSRA13;	 
   PSRA@1;",
  
  OUTPUT = "sampstat stdy modindices(all);",
  
  rdata = dat
  
)

fit <- mplusModeler(test, modelout = "Models/model1.inp", run = 1L, writeData = "always")
