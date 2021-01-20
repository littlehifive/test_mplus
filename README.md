# Solution 1

The first solution is to create Mplus input files outside Box and have them version controlled, and simultaneously update a "replica" folder in Box that tracks changes in the version-controlled folder and update the same files accordingly.

I figured that this might be easier and much more efficient to use an existing command-line tool, `rsync` (see instructions [here](https://unix.stackexchange.com/questions/203846/how-to-sync-two-folders-with-command-line-tools), [here](https://download.samba.org/pub/rsync/rsync.html) and [here](https://www.hostinger.com/tutorials/how-to-use-rsync)). 

Step 1: You will need to install `brew` first by running `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"` in terminal. You can either open the terminal app on Mac, or open it in R (the tab right next to the Console tab).

Step 2: Install `rsync` by running `brew install rsync`.

Step 3: Create the `.inp` files in a git repository outside Box. Relative paths like `../` can be preserved as if the files are in your target Box folder.

Step 4: Run `rsync -avu /home/user/A/ /home/user/B ` (notice the slash after A), this basically copies content from directory A (git repository) to directory B (Box folder). Notice there is no quotation mark in between the two file paths, only a space.

- `-a` Do the sync preserving all filesystem attributes
- `-v` run verbosely
- `-u` only copy files with a newer modification time (or size difference if the times are equal)
- Should you ever want to delete the files in the target folder that do not exist in the source, add ` --delete` after `-avu`.

A full example would be something like (notice the backslash to escape the spaces): 
```
rsync -avu /Users/michaelfive/Desktop/R\ Directory/Git\ learning/test-presentation/test/ /Users/michaelfive/Box/Box\ 3EA\ Team\ Folder/For\ Zezhen/MR\ automation/Test\ Input\ Data/Baseline
```

Therefore, each time you finish making changes in the version-controlled repository, make sure to both commit changes to GitHub and run Step 4 in terminal to update the files in Box.

# Solution 2

The second solution is to directly run Mplus from R without bothering to open Mplus. `mplusObject` does exactly the job: it creates the `.inp` file from an R function with Mplus arguments. `mplusModeler` further creates a temporary `.dat` file from a specified dataset (with the filename of any number of characters), and generate the `.out` file from the `.inp` file and the temporary `.dat` file.

For instance:
```
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

fit <- mplusModeler(test, modelout = "model1.inp", run = 1L, writeData = "always")
```
It creates the following files in your working directory, and the `.inp` and `.out` files look exactly like what you'll get from Mplus.
<img width="496" alt="Screen Shot 2021-01-14 at 11 05 06 PM" src="https://user-images.githubusercontent.com/26876926/104680066-0bb2b180-56bd-11eb-873b-73a635620efe.png">