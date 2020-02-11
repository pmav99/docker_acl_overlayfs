Runtime ACLs seem to be supported both on the workstation and the cluster

```
docker run --rm -it ubuntu bash

apt update
apt install acl
mkdir foo
getfacl foo
setfacl -d -m group:users:rwx foo
getfacl foo
setfacl -m group:users:rwx foo
getfacl foo
```
