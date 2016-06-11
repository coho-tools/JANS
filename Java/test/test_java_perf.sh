#/bin/sh

echo "****Testing JAVA performance****" 
date
java -cp ../bin/coho.jar:../lib/cup.jar coho.interp.MyParser < fastProj.log > result.log
date
java -cp ../bin/coho.jar:../lib/cup.jar coho.interp.MyParser < slowProj.log > result2.log
date
