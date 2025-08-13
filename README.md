# devops-network
Linux automation web ui

- First release - prototype testing
## ##########################
## How to commit big files ## 
## ##########################
1. Copy or move the large file into your repo
Example:
C:\Users\makwetjat\Videos\devnetwork-repos\devops-network\installations\Symantec-SESC.tgz

2. Then run the Git LFS tracking, add, commit, and push steps:
powershell
git lfs track "installations/Symantec-SESC.tgz"
git add .gitattributes
git add installations/Symantec-SESC.tgz
git commit -m "Add Symantec-SESC.tgz via LFS"
git push origin main

N.B - Once it’s inside the repo, Git LFS will handle it correctly — no need to keep it elsewhere