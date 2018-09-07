########################VARIABLES###############################
export ROJO="\033[1;31m"
export AZUL="\033[1;36m"
export VERDE="\033[1;32m"
export NEGRO="\033[0m"
INSTALAR_FFMPEG=s
INSTALAR_FREEPASCAL=s
MENU=100
################################################################
rm -Rf /tmp/*
while [ $MENU != 0 ]
do
clear
echo -e "${ROJO}------------------------${NEGRO}"
echo -e "${ROJO}   MENU INSTALACION     ${NEGRO}"
echo -e "${ROJO}------------------------${NEGRO}"
echo -e "${AZUL}1) Instalar dependencias${NEGRO}"
echo -e "${AZUL}2) Instalar ffmpeg${NEGRO}"
echo -e "${AZUL}3) Instalar freepasacal${NEGRO}"
echo -e "${AZUL}4) Instalar ultrastar${NEGRO}"
echo -e "${AZUL}5) Instalar ultrastar world party${NEGRO}"
echo -e "${AZUL}6) Crear acceso directo en el escritorio${NEGRO}"
echo -e "${AZUL}7) Autoinicar Ultrastar${NEGRO}"
echo -e "${AZUL}8) Crear un link simbolico a NAS.${NEGRO}"
echo -e "${AZUL}0) Salir${NEGRO}"
echo -e "${ROJO}Escoge una opcion:${NEGRO}"
read OPCION
case $OPCION in
   1)
    echo -e "${AZUL}--------------------${NEGRO}"
	echo -e "${AZUL}Actualizando sistema${NEGRO}"
	echo -e "${AZUL}--------------------${NEGRO}"

	sudo apt-get -y update

	echo -e "${AZUL}-----------------------${NEGRO}"
	echo -e "${AZUL}Instalando dependencias${NEGRO}"
	echo -e "${AZUL}-----------------------${NEGRO}"
	
	#PAQUETES="automake libpng12-0 libpng12-dev libsdl2-dev libsdl2-2.0-0 libsdl2-gfx-1.0-0 libsdl2-gfx-dev libsdl2-image-2.0-0 libsdl2-image-dev libsdl2-mixer-2.0-0 libsdl2-mixer-dev libsdl2-net-2.0-0 libsdl2-net-dev libsdl2-ttf-2.0-0 libsdl2-ttf-dev portaudio19-dev liblua5.1-0 liblua5.1-0-dev libsqlite3-0 libsqlite3-dev git fpc fpc-source fpc-2.6.4 fpc-source-2.6.4 libass-dev libmp3lame-dev libopus-dev libtheora-dev libx264-dev libbz2-dev build-essential libvpx-dev"
	PAQUETES="automake libpng12-0 libpng12-dev libsdl2-dev libsdl2-2.0-0 libsdl2-gfx-1.0-0 libsdl2-gfx-dev libsdl2-image-2.0-0 libsdl2-image-dev libsdl2-mixer-2.0-0 libsdl2-mixer-dev libsdl2-net-2.0-0 libsdl2-net-dev libsdl2-ttf-2.0-0 libsdl2-ttf-dev portaudio19-dev liblua5.1-0 liblua5.1-0-dev libsqlite3-0 libsqlite3-dev git fpc fpc-source fpc-3.0.0 fpc-source-3.0.0 libvorbis-dev libx264-dev libx265-dev libmp3lame-dev libass-dev libavcodec-dev libavcodec-extra57 libzvbi-dev libavformat* libghc-bzlib-dev libopus-dev libtheora-dev libvpx-dev libxvidcore-dev libswscale-dev"
	PAQ_CORECTOS=0
	PAQ_ERRORES=0
	for PAQUETE in $PAQUETES
	do
	sudo apt-get -y install $PAQUETE
	dpkg -l | grep $PAQUETE > /dev/null
	case $? in
		0)
		echo -e "${VERDE}$PAQUETE Instalado correctamente${NEGRO}"
		PAQ_CORRECTOS=$(($PAQ_CORRECTOS+1))
		;;
		*)
		echo -e "${ROJO}$PAQUETE No instalado correctamente${NEGRO}"
		PAQ_ERRORES=$(($PAQ_ERRORES+1))
		;;
		esac
		done
	sudo aptitude -y install build-essential
			   
	echo -e "${VERDE}Dependencias instaladas.${NEGRO}"
	echo -e "${VERDE}$PAQ_CORRECTOS Dependencias correctas.${NEGRO}"
	echo -e "${ROJO}$PAQ_ERRORES Dependencias fallidas.${NEGRO}"
	read TECLA
	;;
	
   2)
      ffmpeg -version
      FFMPEG_INSTALADO=$?
      if [ $FFMPEG_INSTALADO -eq 0 ]
      then
         echo -e "${ROJO}Esta instalada la version `ffmpeg -version | grep version | awk '{print $3}'` de ffmpeg${NEGRO}"
         echo -e "${AZUL}Quieres instalar otra version? s/n${NEGRO}"
         read INSTALAR_FFMPEG
         case $INSTALAR_FFMPEG in
         s)
            wget -P /tmp/ http://ffmpeg.org/releases/
            mv /tmp/index.html /tmp/ffmpeg_versions
            cat /tmp/ffmpeg_versions | grep tar.gz | grep -v .asc| awk -F\" '{print $6}'
            echo -e "${AZUL}Escoge la version de ffmpeg para descargar:${NEGRO}"
            read FFMPEG_VERSION
            cd /tmp/
            wget -P /tmp/ http://ffmpeg.org/releases/${FFMPEG_VERSION}
         ;;
         *)
            echo -e "${VERDE}No se descargara otra version de ffmpeg${NEGRO}"
         ;;
         esac
      else
              wget -P /tmp/ http://ffmpeg.org/releases/
              mv /tmp/index.html /tmp/ffmpeg_versions
              cat /tmp/ffmpeg_versions | grep tar.gz | grep -v .asc| awk -F\" '{print $6}'
              echo -e "${AZUL}Escoge la version de ffmpeg para descargar:${NEGRO}"
              read FFMPEG_VERSION
              wget -P /tmp/ http://ffmpeg.org/releases/${FFMPEG_VERSION}
      fi
         case $INSTALAR_FFMPEG in
         s)
            cd /tmp
            tar -zxvf ${FFMPEG_VERSION}

            #tar -zxvf fpcbuild-${FREEPASCAL_VERSION}.tar.gz

            echo -e "${AZUL}------------------------------${NEGRO}"
            echo -e "${AZUL}Compilando e instalando ffmpeg${NEGRO}"
            echo -e "${AZUL}------------------------------${NEGRO}"
                      echo "Pulsa INTRO para continuar"
            read TECLA

            FFMPEG_DIR=`echo ${FFMPEG_VERSION}  | sed 's/.tar.gz//g'`
            cd /tmp/${FFMPEG_DIR}
            # Configuracion original (videos a saltos)
			# ./configure --enable-shared --enable-pic --disable-encoders --disable-static --prefix=/usr	
			
            #Configuracion original 720P (videos a saltos)
			#./configure --arch=armel --target-os=linux --enable-gpl --enable-omx --enable-omx-rpi --enable-nonfree
			
			#Añadiendo decodificación por hardware MMAL. ULTRASTAR ARRANCA PERO LOS VIDEOS MAL
			#./configure --prefix=/usr --enable-shared --enable-pic --disable-static --enable-gpl --enable-libx264 --enable-libmp3lame --enable-libvorbis  --enable-hwaccel=h264_mmal --enable-decoder=h264_mmal --enable-decoder=mpeg2_mmal --enable-decoder=mpeg4_mmal
			
			#Añadiendo  --enable-omx --enable-omx-rpi para la codificación por hardware. ULTRASTAR ARRANCA PERO LOS VIDEOS MAL
			#./configure --prefix=/usr --enable-shared --enable-pic --disable-static --enable-omx --enable-omx-rpi --enable-mmal --enable-hwaccel=h264_mmal --enable-decoder=h264_mmal --enable-decoder=mpeg2_mmal --enable-decoder=mpeg4_mmal --enable-libx264 --enable-libx265 --enable-nonfree --enable-gpl --enable-avresample --enable-libass --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libtheora --enable-libvorbis --enable-libvpx
			
			#Añadiendo  --arch=armel --target-os=linux, según web https://maniaclander.blogspot.com/2017/08/ffmpeg-with-pi-hardware-acceleration.html ULTRASTAR ARRANCA PERO LOS VIDEOS MAL
			#./configure --prefix=/usr --arch=armel --target-os=linux --enable-shared --enable-pic --disable-static --enable-omx --enable-omx-rpi --enable-mmal --enable-hwaccel=h264_mmal --enable-decoder=h264_mmal --enable-decoder=mpeg2_mmal --enable-decoder=mpeg4_mmal --enable-libx264 --enable-libx265 --enable-nonfree --enable-gpl --enable-avresample --enable-libass --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libtheora --enable-libvorbis --enable-libvpx
			
			#Otra opción, según web https://www.fororaspberry.es/viewtopic.php?f=6&t=1043&start=340. VIDEOS BIEN, ULTRASTAR MEJORA EN 720P
			#./configure --enable-shared --enable-pic --disable-static --prefix=/usr --arch=arm --enable-pthreads --enable-runtime-cpudetect --enable-neon --enable-bzlib --enable-libfreetype --enable-gpl --shlibdir=/usr/lib/arm-linux-gnueabihf/neon/vfp --cpu=armv7-a --extra-cflags='-mfpu=neon -fPIC -DPIC' --enable-libx264 --enable-mmal --enable-hwaccel=h264_mmal --enable-omx-rpi --enable-omx --enable-opengl --enable-nonfree --enable-libtheora --enable-decoder=h264_mmal --enable-decoder=mpeg2_mmal --enable-decoder=mpeg4_mmal --enable-encoder=h264_omx --enable-encoder=h264_omx --enable-avresample --enable-libass --enable-libmp3lame --enable-libvorbis --enable-libvpx --enable-libopus --disable-decoder=h264 --disable-decoder=mpeg4 --disable-encoder=libx264 --disable-encoder=mpeg4
			
			#Unión de todas las opciones anteriores
			./configure --enable-shared --enable-pic --disable-static --prefix=/usr --arch=armel --enable-pthreads --enable-runtime-cpudetect --enable-neon --enable-bzlib --enable-libfreetype --enable-gpl --shlibdir=/usr/lib/arm-linux-gnueabihf/neon/vfp --cpu=armv7-a --extra-cflags='-mfpu=neon -fPIC -DPIC' --enable-libx264 --enable-mmal --enable-hwaccel=h264_mmal --enable-omx-rpi --enable-omx --enable-opengl --enable-nonfree --enable-libtheora --enable-decoder=h264_mmal --enable-decoder=mpeg2_mmal --enable-decoder=mpeg4_mmal --enable-encoder=h264_omx --enable-encoder=h264_omx --enable-avresample --enable-libass --enable-libmp3lame --enable-libvorbis --enable-libvpx --enable-libopus --disable-decoder=h264 --disable-decoder=mpeg4 --disable-encoder=libx264 --disable-encoder=mpeg4
			
            make -j4

            sudo make install

            which ffmpeg
         case $? in
         0)
                         VERSION_INSTALADA=`ffmpeg -version | grep version | awk '{print $3}'`
                         VERSION_COMPILADA=`echo $FFMPEG_DIR | awk -F- '{print $NF}'`

                         if [ $VERSION_INSTALADA != $VERSION_COMPILADA ]
                         then
                            echo -e "${ROJO}Error en la compilación de ffmpeg"
                            echo -e "Version instalada ${VERSION_INSTALADA}"
                            echo -e "Version compilada ${VERSION_COMPILADA}${NEGRO}"
                            exit 1
                         else
							sudo apt-get install -y ffmpeg
                            echo -e "${VERDE}Compilacion e instalacion de ffmpeg correcta${NEGRO}"
                         fi
         ;;
         *)
            echo -e "${ROJO}Error en la instalacion de ffmpeg. Revisa el log de la compilacion${NEGRO}"
         ;;
         esac
         ;;
         *)
            echo -e "${VERDE}No se instalara el ffmpeg descargado${NEGRO}"
         ;;
         esac
	read TECLA
   ;;
   3)
      fpc -iV
      FREEPASCAL_INSTALADO=$?
      if [ $FREEPASCAL_INSTALADO -eq 0 ]
      then
              echo -e "${ROJO}Esta instalada la version `fpc -iV` de freepascal"
              echo -e "${AZUL}Quieres instalar otra version? s/n${NEGRO}"
              read INSTALAR_FREEPASCAL
              case $INSTALAR_FREEPASCAL in
              s)
              wget -P /tmp/ https://sourceforge.net/projects/freepascal/files/Source/
              mv /tmp/index.html /tmp/freepascal_versions
              cat /tmp/freepascal_versions | grep "\"name\":" | sed 's/name/\n/g' | awk '{print $2}' | sed 's/=//g' | awk -F\" '{print$2}' | sort

              echo -e "${AZUL}Escoge la version de freepascal para descargar:${NEGRO}"
              read FREEPASCAL_VERSION
              wget -P /tmp/ https://sourceforge.net/projects/freepascal/files/Source/${FREEPASCAL_VERSION}/fpcbuild-${FREEPASCAL_VERSION}.tar.gz
             cd /tmp/
             tar -zxvf fpcbuild-${FREEPASCAL_VERSION}.tar.gz
         ;;
              *)
                      echo -e "${VERDE}No se descargara otra version de freepascal${NEGRO}"
              ;;
              esac

      else
         wget -P /tmp/ https://sourceforge.net/projects/freepascal/files/Source/
         mv /tmp/index.html /tmp/freepascal_versions
         cat /tmp/freepascal_versions | grep "\"name\":" | sed 's/name/\n/g' | awk '{print $2}' | sed 's/=//g' | awk -F\" '{print$2}' | sort

         echo -e "${AZUL}Escoge la version de freepascal para descargar:${NEGRO}"
         read FREEPASCAL_VERSION
         wget -P /tmp/ https://sourceforge.net/projects/freepascal/files/Source/${FREEPASCAL_VERSION}/fpcbuild-${FREEPASCAL_VERSION}.tar.gz
         cd /tmp/
         tar -zxvf fpcbuild-${FREEPASCAL_VERSION}.tar.gz

      fi
         case $INSTALAR_FREEPASCAL in
         s)

                    echo -e "${AZUL}----------------------------------${NEGRO}"
                    echo -e "${AZUL}Compilando e instalando freepascal${NEGRO}"
                    echo -e "${AZUL}----------------------------------${NEGRO}"
                        echo "Pulsa INTRO para continuar"
         read tecla

            cd /tmp/fpcbuild-${FREEPASCAL_VERSION}
            make NOGDB=1 OPT="-dFPC_ARMHF -CX -CfVFPV3_D16 -O- -XX -Xs" build

            sudo make NOGDB=1 install

            sudo unlink /usr/bin/ppcarm

            sudo ln -s /usr/local/lib/fpc/${FREEPASCAL_VERSION} /usr/lib/fpc/${FREEPASCAL_VERSION}

            sudo ln -s /usr/local/lib/fpc/${FREEPASCAL_VERSION}/ppcarm /usr/bin/ppcarm

         which fpc
         case $? in
         0)
                         VERSION_INSTALADA=`fpc -iV`
                         VERSION_COMPILADA=`echo ${FREEPASCAL_VERSION}`

                         if [ $VERSION_INSTALADA != $VERSION_COMPILADA ]
                         then
                                    echo -e "${ROJO}Error en la compilación de freepascal"
                                 echo -e "Version instalada ${VERSION_INSTALADA}"
                                    echo -e "Version compilada ${VERSION_COMPILADA}${NEGRO}"
                                 exit 1
                         else
                                    echo -e "${VERDE}Compilacion e instalacion de freepascal correcta${NEGRO}"
                         fi
         ;;
         *)
            echo -e "${ROJO}Error en la instalacion de FreePascal. Revisa el log de la compilacion${NEGRO}"
         ;;
         esac
         ;;
         *)
            echo -e "${VERDE}No se instalara el freepascal descargado${NEGRO}"
         ;;
         esac
	read TECLA
   ;;
   4)
      which ultrastardx
      ULTRASTAR_INSTALADO=$?

      case $ULTRASTAR_INSTALADO in
      0)
              echo -e "${ROJO}Ya hay una version de ultrastar instalada"
              echo -e "${AZUL}Quieres recompilar ULTRASTAR? s/n${NEGRO}"
              read INSTALA_ULTRASTAR
      ;;
      *)
         INSTALA_ULTRASTAR=s
      ;;
      esac
      #if [ $INSTALA_ULTRASTAR == s ]
      #then
         echo -e "${AZUL}1) Version estable (Agosto 2017)"
         echo -e "2) Ultima version (no estable)"
         echo -e "3) Version diciembre 2016 (no estable)"
         echo -e "Que version de Ultrastar quieres descargar?"
         read VERSION
         case $VERSION in
         2)
              echo -e "${VERDE}Descargando la última version (no estable)${NEGRO}"
              cd /tmp
              git clone https://github.com/UltraStar-Deluxe/USDX.git
         ;;
         3)
              echo -e "${VERDE}Descargando la versión de Diciembre de 2016 (no estable)${NEGRO}"
              cd /tmp
              git clone https://github.com/UltraStar-Deluxe/USDX.git
              cd /tmp/USDX
              git checkout `git rev-list -n 1 --before="2016-12-04 23:59" master`
         ;;
         *)
              echo -e "${VERDE}Descargando la version de Agosto de 2017 (estable)${NEGRO}"
              cd /tmp
              wget -P /tmp/ https://github.com/UltraStar-Deluxe/USDX/archive/v2017.8.0.tar.gz
              tar -zxvf v2017.8.0.tar.gz
              mv USDX-2017.8.0 USDX
         ;;
         esac
         echo -e "${AZUL}---------------------------------${NEGRO}"
         echo -e "${AZUL}Compilando e instalando ULTRASTAR${NEGRO}"
         echo -e "${AZUL}---------------------------------${NEGRO}"
         echo -e "Pulsa INTRO para continuar"
         read TECLA

			cd /tmp/USDX

			./autogen.sh

			./configure --prefix=/usr

			cd src

			sed 's/PFLAGS_RELEASE_DEFAULT := -Xs- -O2/PFLAGS_RELEASE_DEFAULT := -Xs- -O1/g' Makefile > Makefile.mod
			sed 's/LIBS       ?=/LIBS       ?= -lm -lgcc_s -llua5.1/g' Makefile.mod > Makefile.mod2

			mv Makefile Makefile.orig
			mv Makefile.mod2 Makefile

			sudo unlink /lib/arm-linux-gnueabihf/libgcc_s.so

			sudo ln -s /lib/arm-linux-gnueabihf/libgcc_s.so.1 /lib/arm-linux-gnueabihf/libgcc_s.so

			make -j4

			cd /tmp/USDX

			sudo make install
      #else
      #   echo -e "${VERDE}No se instalara ULTRASTAR${NEGRO}"
      #fi
	read TECLA
   ;;
   5)
   # Obtenido según web http://ultrastar-es.org/foro/viewtopic.php?t=4789
   cd /tmp
   git clone https://github.com/ultrastares/usdxworldparty
   cd usdxworldparty
   chmod 777 install autogen.sh
   sudo ./install
   sudo cp /usr/share/applications/WorldParty.desktop /home/pi/Desktop/WorldParty.desktop
   echo -e "${VERDE}ULTRASTAR DELUXE WORLDPARTY INSTALADO.${NEGRO}"
   read TECLA
   ;;
   6)
	wget -P /tmp/ http://i.imgur.com/JtmXso1.png
	sudo mv /tmp/JtmXso1.png /usr/share/icons/ultra.png
	cd /home/pi/Desktop
	touch ultrastar.desktop
	echo "[Desktop Entry]" >> /home/pi/Desktop/ultrastar.desktop
	echo "Version=1.0" >> /home/pi/Desktop/ultrastar.desktop
	echo "Type=Application" >> /home/pi/Desktop/ultrastar.desktop
	echo "Terminal=false"  >> /home/pi/Desktop/ultrastar.desktop
	echo "Name=ultrastar"  >> /home/pi/Desktop/ultrastar.desktop
	echo "Categories=Games;"  >> /home/pi/Desktop/ultrastar.desktop
	echo "Exec=/usr/bin/ultrastardx"  >> /home/pi/Desktop/ultrastar.desktop
	echo "Comment=Ultrastar"  >> /home/pi/Desktop/ultrastar.desktop
	echo "Icon=/usr/share/icons/ultra.png"  >> /home/pi/Desktop/ultrastar.desktop
	chmod 755 /home/pi/Desktop/ultrastar.desktop
   ;;
   7)
		cd /home/pi/Util/ultrastar
		sudo chmod 775 ultrastar_autoinicio.sh
		sudo cp /home/pi/Util/ultrastar/ultrastar_autoinicio.sh /home/pi/ultrastar_autoinicio.sh
		sudo cp /home/pi/Util/ultrastar/rmspi.desktop /etc/xdg/autostart/rmspi.desktop
		echo -e "${VERDE}Autoinicio Ultrastar creado.${NEGRO}"
		sudo chmod 775 ultrastar_autoapagado.sh
		sudo cp /home/pi/Util/ultrastar/ultrastar_autoapagado.sh /home/pi/ultrastar_autoapagado.sh
		#sudo chown root:root /etc/init.d/ultrastar_autoapagado.sh
		echo -e "${VERDE}Autoapagado Ultrastar creado.${NEGRO}"
		echo -e "${AZUL}-Añadir la siguiente orden a crontab -e.${NEGRO}"
		echo -e "${AZUL}*/1 * * * *	sh	/home/pi/ultrastar_autoapagado.sh${NEGRO}"
		read TECLA
   ;;
   8)
		sudo mkdir /mnt/KARAOKE_NAS
		ln -s /mnt/KARAOKE_NAS /home/pi/.ultrastardx/songs
		ln -s /mnt/KARAOKE_NAS /home/pi/.WorldParty/songs
		echo -e "${VERDE}Enlace simbolico creado.${NEGRO}"
		echo -e "${VERDE}Copiar la siguiente sentencia en fstab:${NEGRO}"
		echo -e "${AZUL}//192.168.0.5/KODI/KARAOKE /mnt/KARAOKE_NAS cifs user=xxx,pass=xxx,nofail${NEGRO}"
		echo -e "${VERDE}Hay que reiniciar para que surta efecto.${NEGRO}"
		read TECLA
   ;;
   0)
      echo -e "${ROJO}Saliendo${NEGRO}"
      exit 1
   ;;
esac
done
