FROM ubuntu:16.04

ARG USERNAME=scipsycho

RUN apt-get update && \
        apt-get -y install sudo

#Creating a SUDO user
RUN adduser --disabled-password --gecos '' $USERNAME && \
      adduser $USERNAME sudo && \
      echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER $USERNAME

RUN sudo apt-get install -y curl vim wget build-essential autoconf automake\
    libxmu-dev libperl4-corelibs-perl  

RUN sudo apt-get install -y nam xorg-dev g++ xgraph

RUN sudo apt-get install -y x11vnc xvfb firefox
RUN mkdir /home/$USERNAME/workdir

WORKDIR /home/$USERNAME/workdir

COPY . . 

RUN tar -xzvf ./ns-allinone-2.35.tar.gz && cd ./ns-allinone-2.35/ && \
     ./install && cd ./ns-2.35/ && sudo make install

RUN echo "" >> ~/.bashrc && \
    echo "#For ns2" >> ~/.bashrc && \
    echo "export TCL_LIBRARY=\"/home/$USERNAME/workdir/ns-allinone-2.35/tcl8.5.10/library\"" >> ~/.bashrc && \
    echo "export LD_LIBRARY_PATH=\"/home/$USERNAME/workdir/ns-allinone-2.35/otcl-1.14:/home/scipsycho/workdir/ns-allinone-2.35/lib\"" >> ~/.bashrc

RUN     mkdir ~/.vnc && x11vnc -storepasswd 1234 ~/.vnc/passwd

RUN     bash -c 'echo "firefox" >> ~/.bashrc' 
