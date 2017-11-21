# Docker-in-Docker based on centos original image

### Step 1:
```sh
$ git clone https://github.com/AixC/dind_centos.git
```

### Step 2:Build docker image
```sh
$ sudo ./build.sh
```

### Step 3:Run
```sh
$ sudo docker run --privileged -d dind_centos
```
