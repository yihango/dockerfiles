FROM python:3.7.13-buster


# install deps + add Chrome Stable + purge all the things
ARG CHROME_VERSION="75.0.3770.90-1"
RUN apt-get update \
    && apt-get install -y \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg \
	fontconfig \
	fonts-ipafont-gothic \
	fonts-wqy-zenhei \
	fonts-thai-tlwg \
	fonts-kacst \
	fonts-symbola \
	fonts-noto \
	fonts-freefont-ttf \
	--no-install-recommends \
	&& apt-get purge --auto-remove -y curl gnupg \
	&& rm -rf /var/lib/apt/lists/* \
	&& wget --no-verbose -O /tmp/chrome.deb https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}_amd64.deb \
  	&& apt install -y /tmp/chrome.deb \
  	&& rm /tmp/chrome.deb	


# set env
ENV PUPPETEER_EXECUTABLE_PATH "/usr/bin/google-chrome"

# install 
WORKDIR /app
COPY ./requirements.txt ./
RUN pip3 install -r ./requirements.txt
