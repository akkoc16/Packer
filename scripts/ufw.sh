sudo apt-get install netfilter-persistent -y
sudo systemctl stop ufw
sudo systemctl disable ufw
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo netfilter-persistent save
sudo netfilter-persistent reload
