#! /bin/bash
cp /var/log/ufw.log logscopy.txt
cat /dev/null | sudo tee /var/log/ufw.log
sed 1d rules.txt | while read -r line
do
read -r -a array <<<"$line"
if [ "${array[0]}" = "any" ];
then
sudo ufw ${array[1]} from ${array[2]} to ${array[3]}
fi
done
sed 1d rules.txt | while read -r line
do
read -r -a  array <<<"$line"
if [ "${array[2]}" != "any" ] || [ "${array[3]}" != "any" ];
then
if [ "${array[0]}" != "any" ];
then
sudo ufw ${array[1]} from ${array[2]} to ${array[3]} port ${array[0]}
fi
fi
done
sed 1d rules.txt | while read -r line
do
read -r -a  array <<<"$line"
if [ "${array[2]}" = "any" ] && [ "${array[3]}" = "any" ];
then
sudo ufw ${array[1]} ${array[0]}
fi
done
sudo ufw enable
sudo ufw logging medium
while true
do
cat /dev/null | sudo tee logstest2.txt 
cat /var/log/ufw.log > logstest2.txt
sudo iptables -L ufw-user-input -v -n | grep 'DROP' | awk '{print $1,$8}' > droptable.txt
file=droptable.txt
while read -r drop ip; do
if (( $drop >= 3 && $drop%3 == 0 )); then
echo "$ip has been dropped $drop time";
sleep 10
fi
done < $file
done

