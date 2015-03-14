# printtree
prints all the trees in a distributed forest

This needs the hiforestanalysis libraries, so one a one-time setup is required:
```bash
git clone git@github.com:CmsHI/HiForestAnalysis.git
```

Next this will run out of the box by just doing:
```bash
./printtree.sh pPb_5TeV_Jet80_split.txt run
```

This script will first create a temporary production dir where everything will be copied to. Next it will compile the printtree.C file to obtain the most up to date executable. Next it will create the wrapper shell script which will run the C++ executable with the proper arguments. Finally it will create the condor submission script and if the second run parameter is supplied will also submit it directly to condor.

This is a good template class for generic distributed tasks via the condor framework since all this does is print some trees. To add a different .C file one would just need to change the NAME and exe lines appropriately. The generated runprint.sh would also need additional lines to handle the output like moving a generated root file, if there is one, to a hadoop directory. The generated printtree.condor also needs the Arguments line to match what the runprint.sh equivalent expects, adn the Output, Error, and Log directories need to exist and be writable. Make sure that transfer_input_files has all the correct files needed for the analysis to run. Lastly remember to have the script clean up after itself, since everything that is left behind when the job completes is not magically deleted, instead it's copied back to the directory from which the job was submitted, which can have catastrophic consequences if larger data files are left behind as this will be a many-to-one write operation.

Remember before submitting to cd into the temporary production dir and run the shell script at least once interactively to catch any potential bugs or issues, and if everything looks ok and accounted for then do condor_submit.

**Important:** Condor gives you access to thousands of machines at once, and quoting uncle Ben, with great computational power comes great responsibility. You never want thousands of machines to ever interact with a single machine for a finite amount of time or with a finite amount of data. Every output must be written locally and transfered to hadoop only upon completion. 

Never perform a non-instantaneous many-to-one read or write operation.
