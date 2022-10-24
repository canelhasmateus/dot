function sendChangesToSplitDownstream {

function pullUpstream {

    git remote add canelhas https://github.com/canelhasmateus/limni.git
    git fetch canelhas
    git branch -d canelhas_master
    git checkout -b canelhas_master canelhas/master
    

}

function pushDownStream {

git branch canelhas_vault origin/canelhas_vault
git subtree split --prefix=vault -b canelhas_vault

git checkout canelhas_vault
git push -u origin canelhas_vault --force


}


pullUpstream
pushDownStream

}


function addSplitChangesToCurrentBranch {


sleep 1

if test -d ./canelhas

then

git subtree pull --prefix canelhas origin canelhas_vault -m "subtree pull"

else
git subtree add --prefix canelhas origin canelhas_vault


fi

}



echo "Help Pages"
echo https://lostechies.com/johnteague/2014/04/04/using-git-subtrees-to-split-a-repository/
echo https://manpages.ubuntu.com/manpages/bionic/man1/git-subtree.1.html


sendChangesToSplitDownstream
git checkout master
if ! test -d ./canelhas
then
git submodule add -b canelhas_vault ssh:/origin canelhas
else

git submodule update --init --recursive --remote

fi


