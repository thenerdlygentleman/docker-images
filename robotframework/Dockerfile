FROM ubuntu:24.04


# PIP VERSIONS
ARG APPIUM_LIBRARY=2.0.0
ARG BROWSER_LIBRARY=18.5.1
ARG DOCTEST_LIBRARY=0.20.0
ARG OCR_LIBRARY=2.0.0
ARG PABOT_LIBRARY=2.18.0
ARG ROBOTFRAMEWORK=7.0
ARG SSH_LIBRARY=3.8.0


# INSTALL NODE
RUN apt update \
    && apt upgrade -y \
    && apt install -y \
    nodejs \
    npm \
    python3 \
    pip


# PIP INSTALL
RUN pip install --break-system-packages \
    robotframework-appiumlibrary==${APPIUM_LIBRARY} \
    robotframework-browser==${BROWSER_LIBRARY} \
    robotframework-doctestlibrary==${DOCTEST_LIBRARY} \
    robotframework-ocrlibrary==${OCR_LIBRARY} \
    robotframework-pabot==${PABOT_LIBRARY} \
    robotframework-sshlibrary==${SSH_LIBRARY} \
    robotframework==${ROBOTFRAMEWORK}

    
# INSTALL BROWSER DEPENCIES
RUN npx playwright install-deps
RUN rfbrowser init
