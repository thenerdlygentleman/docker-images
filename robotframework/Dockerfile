FROM debian:12-slim AS robotframework

ARG APPIUM_LIBRARY=2.0.0
ARG BROWSER_LIBRARY=18.5.1
ARG DOCTEST_LIBRARY=0.20.0
ARG OCR_LIBRARY=2.0.0
ARG PABOT_LIBRARY=2.18.0
ARG ROBOTFRAMEWORK=7.0
ARG SSH_LIBRARY=3.8.0

RUN apt update && apt install --yes \
    nodejs \
    npm \
    python3 \
    pip

RUN pip install --break-system-packages \
    robotframework-appiumlibrary==${APPIUM_LIBRARY} \
    robotframework-browser==${BROWSER_LIBRARY} \
    robotframework-doctestlibrary==${DOCTEST_LIBRARY} \
    robotframework-ocrlibrary==${OCR_LIBRARY} \
    robotframework-pabot==${PABOT_LIBRARY} \
    robotframework-sshlibrary==${SSH_LIBRARY} \
    robotframework==${ROBOTFRAMEWORK}

RUN npx playwright install-deps
RUN rfbrowser init

FROM robotframework AS test
RUN mkdir /root/robot-test
WORKDIR /root/robot-test
COPY ./test/robot-test.robot .
RUN robot robot-test.robot
