FROM ubuntu:latest
LABEL name="robot"

RUN apt-get update && \
    apt-get install -y python3 python3-pip gcc wget curl unzip libdbus-glib-1-dev libgtk2.0-0 && \
    apt-get install -y x11-apps xauth x11-utils xvfb libpci3 libegl1 alsa-utils && \
    apt-get install -y gnupg gpg-agent && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

RUN pip install --upgrade pip && \
    pip install -r requirements.txt && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
    apt-get update && \
    apt-get -y install google-chrome-stable && \
    cp /opt/google/chrome/google-chrome /opt/google/chrome/google-chrome-browser && \
    rm /usr/bin/google-chrome-stable && \
    rm /usr/bin/google-chrome && \
    ln -s /opt/google/chrome/google-chrome /usr/bin/google-chrome && \
    wget -O firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US" && \
    tar -xf firefox.tar.bz2 -C /opt/ && \
    ln -s /opt/firefox/firefox /usr/bin/firefox && \
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \
    install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ && \
    sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list' && \
    apt-get update && \
    apt-get install -y microsoft-edge-dev && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf microsoft.gpg

ENV DISPLAY=:99 
ENV PATH="$PATH:/usr/bin"
ENV DEBIAN_FRONTEND=noninteractive

CMD Xvfb :99 -screen 0 1024x768x16 & sleep 10 && robot test_robo_combined.robot && tail -f /dev/null


