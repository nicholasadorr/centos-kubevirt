<img src="images/kv_image1.png" align="left" width="476px" height="108px"/>
<img align="left" width="0" height="192px" hspace="10"/>

> Utilizing KubeVirt to run a Fedora VM on top of Kubernetes

[![Under Development](https://img.shields.io/badge/under-development-skyblue.svg)](https://github.com/cez-aug/github-project-boilerplate) [![Public Domain](https://img.shields.io/badge/public-domain-lightgrey.svg)](https://creativecommons.org/publicdomain/zero/1.0/)

<br><br><br>


# __KubeVirt and CDI__

> _KubeVirt technology addresses the needs of development teams that have adopted or want to adopt Kubernetes but possess existing Virtual Machine-based workloads that cannot be easily containerized. More specifically, the technology provides a unified development platform where developers can build, modify, and deploy applications residing in both Application Containers as well as Virtual Machines in a common, shared environment._ 

> _Containerized-Data-Importer (CDI) is a persistent storage management add-on for Kubernetes. It's primary goal is to provide a declarative way to build Virtual Machine Disks on PVCs for Kubevirt VMs._

## Project Dependencies
* Minikube 1.5.2+
* Kubectl 1.16.2+
* Docker 19.03.5+

## Steps for adding KubeVirt and Containerized Data Inporter(CDI) environment

### Install Virtctl
```
chmod +x resources/v0.26.0/virtctl
sudo cp resources/v0.26.0/virtctl /usr/bin
```

### Create KubeVirt Namespace
```
kubectl create ns kubevirt
```

### Turn on emulation mode
```
kubectl create configmap -n kubevirt kubevirt-config --from-literal debug.useEmulation=true
```

### Create and deploy KubeVirt operator to cluster
```
kubectl create -f resources/v0.26.0/kv-v0.26.0-operator.yaml

kubectl create -f resources/v0.26.0/kv-v0.26.0-cr.yaml
```

### Check status of operator creation
```
watch -d kubectl get all -n kubevirt
```
<img src="images/KV_status_image.JPG" width="600" height="300" align="center" />

### Create and deploy CDI operator to cluster
```
kubectl create -f resources/v0.26.0/cdi-v1.13.0-operator.yaml

kubectl create -f resources/v0.26.0/cdi-v1.13.0-cr.yaml
```
<img src="images/CDI_status_image.JPG" width="600" height="300" align="center" /><br>

## Steps to build PVCs and create VMs

### __Option 1:__

> __Details:__ <br> Option 1 builds PVCs separately from creating the VM  

### Build image into PVC to test VM creation
```
vim pvc_fedora1.yml
```

### PVC details
```
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: fedora1
  labels:
    app: containerized-data-importer
  annotations:
    cdi.kubevirt.io/storage.import.endpoint: "https://download.fedoraproject.org/pub/fedora/linux/releases/30/Cloud/x86_64/images/Fedora-Cloud-Base-30-1.2.x86_64.raw.xz"
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
```

### Create the PVC with Fedora image
```
kubectl create -f pvc_fedora1.yml
#optional: watch the image download
kubectl logs -f $(kubectl get all | grep importer | cut -c -28)
```

### Wait for CDI image import to complete
> (K8s pod importer-fedora1-xxxxx will run then complete)
```
watch -d kubectl get all
```
<img src="images/watchk_1_status.JPG" width="600" height="150" align="center" />

> Check to make sure PVC claim is bound
```
kubectl get pvc
```
<img src="images/pvc_status.JPG" width="600" height="50" align="center" />

### Create VM and add public key

> Add public key to startup-scripts/fedora-startup-script.sh in project.

```
vim vm_fedora1.yml
```

### VM details
```
apiVersion: kubevirt.io/v1alpha3
kind: VirtualMachine
metadata:
  generation: 1
  labels:
    kubevirt.io/os: linux
  name: fedora1
spec:
  running: true
  template:
    metadata:
      creationTimestamp: null
      labels:
        kubevirt.io/domain: fedora1
    spec:
      domain:
        cpu:
          cores: 2
        devices:
          disks:
          - disk:
              bus: virtio
            name: disk0
          - cdrom:
              bus: sata
              readonly: true
            name: cloudinitdisk
        machine:
          type: q35
        resources:
          requests:
            memory: 4096M
      volumes:
      - name: disk0
        persistentVolumeClaim:
          claimName: fedora1
      - name: cloudinitdisk
        cloudInitNoCloud:
          userDataBase64: $(cat ../startup-scripts/fedora-startup-script.sh | base64 -w0) 
```

> __Note:__ <br>If command in __userDataBase64__ field doesn't produce value, run command outside of yaml and copy/paste into it 

### __Option 2:__

> __Details:__ <br> Option 2 builds PVCs sequentially prior to creating the VM in one yaml

### Create PVC and VM while adding cloudinit script value

```
vim pvc_vm_fedora.yml
```

PVC_VM Detals:
```
apiVersion: kubevirt.io/v1alpha3
kind: VirtualMachine
metadata:
  creationTimestamp: null
  labels:
    kubevirt.io/vm: fedora1
  name: fedora1
spec:
  dataVolumeTemplates:
  - metadata:
      creationTimestamp: null
      name: fedora-dv
    spec:
      pvc:
        accessModes:
        - ReadWriteOnce
        resources:
          requests:
            storage: 10Gi
        storageClassName: standard
      source:
        http:
          url: https://download.fedoraproject.org/pub/fedora/linux/releases/30/Cloud/x86_64/images/Fedora-Cloud-Base-30-1.2.x86_64.raw.xz
  running: false
  template:
    metadata:
      labels:
        kubevirt.io/vm: vm-datavolume
    spec:
      domain:
        cpu:
          cores: 2
        devices:
          disks:
          - disk:
              bus: virtio
            name: data-disk0
          - cdrom:
              bus: sata
              readonly: true
            name: cloudinitdisk
        machine:
          type: q35
        resources:
          requests:
            memory: 4096M
      terminationGracePeriodSeconds: 0
      volumes:
      - name: data-disk0
        dataVolume:
          name: fedora-dv
      - name: cloudinitdisk
        cloudInitNoCloud:
          userDataBase64: $(cat ../startup-scripts/fedora-startup-script.sh | base64 -w0)
```

> __Note:__ <br>If command in __userDataBase64__ field doesn't produce value, run command outside of yaml and copy/paste into it


### Apply to cluster and watch for creation
```
kubectl create -f vm_fedora1.yml # Option 1 
```
_or_
``` 
kubectl create -f pvc_vm_fedora.yml # Option 2
```
then:
```
watch -d kubectl get all
virtctl console fedora1
```
<img src="images/watchk_2_status.JPG" width="600" height="300" align="center" />

### Create nodeport service for SSH access
```
virtctl expose vmi fedora1 --name=fedora1-ssh --port=22 --type=NodePort
```

### Grab nodeport created and ssh into box
```
kubectl get all
ssh fedora@<host machine ip> -p <service nodeport>
```
<img src="images/success.JPG" width="600" height="150" align="center" />

## Acknowledgments :thumbsup:

* [KubeVirt](https://kubevirt.io/)
* [CDI](https://github.com/kubevirt/containerized-data-importer)
