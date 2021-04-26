# :rocket: tcadmin-installer

[![Discord](https://img.shields.io/discord/682342331206074373?label=&logo=discord&logoColor=ffffff&color=7389D8&labelColor=6A7EC2)](https://pterodactyl-installer.se/discord)

Unofficial scripts for installing TCAdmin V2 Panel & Database (MySql + Mariadb).

## Features

- Automatic installation of the TCAdmin V2 Panel (dependencies, database andnginx).
- Optional installation of SSL and change port 8880 (default) to 80 so you have now: panel.host.com and not panel.host.com:8880

## Help and support

For help and support about the script you can join my [Discord Server](https://eldremor.com/discord).

## Supported installations

List of supported operational systems supported by this installation script).

### Supported panel operating systems and webservers

| Operating System | Version | nginx support      | PHP Version |
| ---------------- | ------- | ------------------ | ----------- |
| Ubuntu           | 18.04   | :white_check_mark: |             |
|                  | 20.04   | :white_check_mark: |             |

## Let's install it!

Just run the command below in your terminal

```bash
bash <(curl -s https://raw.githubusercontent.com/eldremor/tcadmin-installer/main/tcadmin-installer.sh)
```

## Firewall setup

The installation scripts already install and configure a firewall for you. Just sit and relax!

## Contributors ✨

Copyright (C) 2021, Carlos "Eldremor" Dorelli, <carlos@timberhost.com.br>

Created and maintained by [Carlos "Eldremor" Dorelli](https://github.com/eldremor/tcadmin-installer).

Special thanks to Luis Alvarenga for keep TCAdmin always the best during all these years!