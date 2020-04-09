tar cvf secrets.tar android/key.jks android/key.properties
tar tvf secrets.tar
travis encrypt-file secrets.tar
#tar xvf secrets.tar