sudo cp /var/tmp/60-rke2-cis.conf /etc/sysctl.d/60-rke2-cis.conf
sudo cp /var/tmp/k8s.conf /etc/sysctl.d/k8s.conf

sudo useradd -r -c "etcd user" -s /sbin/nologin -M etcd -U

