#cloud-config

package_upgrade: true

packages:
  - git

users:
  - name: fedora
    gecos: fedora
    password: password
    lock-passwd: false
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEA2HoSA98Qs5beCQnlfNuTXXNryLMuwQWGFaqjwnUXd1Fs8jx7ac3WaF3VXBkx/mcyikpSmFLoX1KtvJMHrvLKF8KHpzIOX59r5/MWFd8EllD1Hkjiv4dEVfe4M3SDDVeHUUCOuQuokcJusoQftWNN0bnsyv0TTzYG7Xh5Ig3ikjR27XBuAfS0o4SICjTJg7/oXK9HnPKx/SXzrKSs0tGn08OR8NwHdzkbp3GgU6YcqSQDyMPCsTQQpy5LcdmWdFKsPtgKLQ19qpBU0Qp7iO4Bqcrn7KlAbtpiW0Fb5WCWivTMFNKIvvBzRMrBbl6lfAhk/zz6PWFx7Ed3RGKmiyCHwQ== rsa-key-20191115 
  - name: nadorr
    gecos: nadorr
    lock-passwd: false
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEA2HoSA98Qs5beCQnlfNuTXXNryLMuwQWGFaqjwnUXd1Fs8jx7ac3WaF3VXBkx/mcyikpSmFLoX1KtvJMHrvLKF8KHpzIOX59r5/MWFd8EllD1Hkjiv4dEVfe4M3SDDVeHUUCOuQuokcJusoQftWNN0bnsyv0TTzYG7Xh5Ig3ikjR27XBuAfS0o4SICjTJg7/oXK9HnPKx/SXzrKSs0tGn08OR8NwHdzkbp3GgU6YcqSQDyMPCsTQQpy5LcdmWdFKsPtgKLQ19qpBU0Qp7iO4Bqcrn7KlAbtpiW0Fb5WCWivTMFNKIvvBzRMrBbl6lfAhk/zz6PWFx7Ed3RGKmiyCHwQ== rsa-key-20191115
  - name: mjschmidt
    gecos: mjschmidt
    lock-passwd: false
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEA2HoSA98Qs5beCQnlfNuTXXNryLMuwQWGFaqjwnUXd1Fs8jx7ac3WaF3VXBkx/mcyikpSmFLoX1KtvJMHrvLKF8KHpzIOX59r5/MWFd8EllD1Hkjiv4dEVfe4M3SDDVeHUUCOuQuokcJusoQftWNN0bnsyv0TTzYG7Xh5Ig3ikjR27XBuAfS0o4SICjTJg7/oXK9HnPKx/SXzrKSs0tGn08OR8NwHdzkbp3GgU6YcqSQDyMPCsTQQpy5LcdmWdFKsPtgKLQ19qpBU0Qp7iO4Bqcrn7KlAbtpiW0Fb5WCWivTMFNKIvvBzRMrBbl6lfAhk/zz6PWFx7Ed3RGKmiyCHwQ== rsa-key-20191115
