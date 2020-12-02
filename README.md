# Rpifo-web

WEB Responsive application for real-time Raspberry Pi monitoring (French interface)

![](https://i.imgur.com/U3eqkEz.png)

## Installation and update :
```bash
curl -Ls https://raw.githubusercontent.com/debmus/rpifo-web/master/install.sh| sudo bash
```

## Information :
In the `index.html` file, uncomment the three lines below to refresh the page every 5 minutes
```javascript
this.interval = setInterval(() => {
    vm.vresult()
}, 300000);
```

## Remove :
```bash
rm -r /var/www/rpifo
sudo rm /etc/cron.d/rpifo
sudo rm /etc/apache2/sites-available/rpifo.conf
sudo a2dissite rpifo
sudo sed -i 's/.*Listen 9696.*//g' /etc/apache2/ports.conf
```