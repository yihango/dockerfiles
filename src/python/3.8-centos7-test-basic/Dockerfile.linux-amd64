FROM centos/python-38-centos7:latest


WORKDIR /app

# chrome
COPY ./3.8-centos7-test-basic.zip ./

RUN unzip ./3.8-centos7-test-basic.zip \
    && yum install -y ./google-chrome-stable-75.0.3770.90-1.x86_64.rpm \
    && cp ./chromedriver /usr/bin/chromedriver \
    && chmod +x /usr/bin/chromedriver \
    && rm -rf ./*

# pip
COPY ./requirements.txt ./
RUN pip3 install -r ./requirements.txt
