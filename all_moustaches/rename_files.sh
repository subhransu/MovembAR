a=1
for i in *.png; do
  mv "$i" moustache_$i.png
  let a=a+1
done
