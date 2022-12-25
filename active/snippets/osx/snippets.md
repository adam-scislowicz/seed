# OSX Snippets

List programs listening on the network: (*run as root to see privileged processed as well*)
```sh
lsof -i -P | grep -i "listen"
```

List socket listeners on TCP w/o name lookups (aka numbers only -n)
```sh
netstat -ant | grep LISTEN
```

List socket listeners on UDP w/o name lookups
```sh
netstat -anu | grep LISTEN
```


