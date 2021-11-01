 #!/bin/bash

PACKAGES="f2fs-tools dosfstools ntfs-3g p7zip unrar ark aspell-ru firefox firefox-i18n-ru gwenview flameshot kate audacious gnome-disk-utility gnome-mahjongg conky ttf-liberation ttf-dejavu"

    echo '(П.21 стр.47) Выбор установки nvidia drivers c kernel ($NV_DEFAULT,$NV_ZEN,$NV_LTS),'
NV_DEFAULT="nvidia nvidia-settings"
NV_ZEN="nvidia-dkms nvidia-settings"
NV_LTS="nvidia-lts nvidia-settings"
AMD_ATI="xorg-server xorg-drivers"

    echo '(П.22 стр.49) Выбор установки рабочего стола $PLASMA, $CINNAMON, $GNOME, $XFCE, $MATE'
PLASMA="plasma dolphin pavucontrol-qt"
CINNAMON="cinnamon cinnamon-translations networkmanager lxdm pulseaudio pavucontrol"
GNOME="gnome gnome-extra networkmanager pavucontrol"
XFCE="xfce4 xfce4-goodies networkmanager lxdm pulseaudio pavucontrol"
MATE="mate mate-extra network-manager-applet networkmanager mate-media lxdm pulseaudio pavucontrol"

    echo '(П.24 стр.53) Вводим имя пользователя'
USERNAME=username

    echo '(П.25 стр.55) Вводим такое же имя пользователя для пароля'
USERPASS=username

    echo '(П.27 стр.59) Выбор экранного менеджера SDDM GDM LXDM'
SDDM=sddm
 GDM=gdm
LXDM=lxdm

    echo 'Место (ДИСК) установки GRUB'
DISK=/dev/xxx

    echo '15. Выставляем регион'
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
    echo '16. Раскоментируем локаль системы'
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen
    echo '17. Генерируем локаль системы'
locale-gen
    echo '18. Указываем язык системы'
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf
    echo '19. Русифицируем консоль'
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf
    echo '20. Обновляем базу PACMAN'
pacman -Sy
    echo '21. Устанавливаем NVIDIA AMD_ATI drivers'
pacman -S $NV_DEFAULT
    echo '22. Устанавливаем рабочий стол (DE)'
pacman -S $PLASMA
    echo '23. Создаем root пароль'
passwd
    echo '24. Создаём пользователя'
useradd -m -G users,wheel,audio,video -s /bin/bash $USERNAME
    echo '25. Устанавливаем пароль пользователя'
passwd $USERPASS
    echo '26. Раскоментируем sudoers'
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
    echo '27. Подключаем daemon SDDM, GDM, LXDM'
systemctl enable $SDDM
    echo '28. Подключаем daemon NetworkManager'
systemctl enable NetworkManager
    echo '29 Устанавливаем grub'
pacman -S grub os-prober efibootmgr
grub-install $DISK
    echo '30. Подключение os-prober'
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
    echo '31. Обновляем grub'
grub-mkconfig -o /boot/grub/grub.cfg
    echo '32. Устанавливаем программы'
pacman -S $PACKAGES
