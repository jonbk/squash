FROM fedora:38

LABEL description Robot Framework in Docker.

ENV ROBOT_REPORTS_DIR /opt/robotframework/reports
ENV ROBOT_TESTS_DIR /opt/robotframework/tests
ENV ROBOT_WORK_DIR /opt/robotframework/temp

ENV SCREEN_COLOUR_DEPTH 24
ENV SCREEN_HEIGHT 1080
ENV SCREEN_WIDTH 1920

ENV TZ UTC

ENV ROBOT_THREADS 1

ENV ROBOT_UID 1000
ENV ROBOT_GID 1000

ENV ALPINE_GLIBC 2.35-r0
ENV AWS_CLI_VERSION 1.27.140
ENV AXE_SELENIUM_LIBRARY_VERSION 2.1.6
ENV BROWSER_LIBRARY_VERSION 16.1.0
ENV CHROMIUM_VERSION 114.0
ENV DATABASE_LIBRARY_VERSION 1.2.4
ENV DATADRIVER_VERSION 1.7.0
ENV DATETIMETZ_VERSION 1.0.6
ENV FAKER_VERSION 5.0.0
ENV FIREFOX_VERSION 114.0
ENV FTP_LIBRARY_VERSION 1.9
ENV GECKO_DRIVER_VERSION v0.33.0
ENV IMAP_LIBRARY_VERSION 0.4.6
ENV JSON_LIBRARY_VERSION 0.5
ENV PABOT_VERSION 2.15.0
ENV REQUESTS_VERSION 0.9.4
ENV ROBOT_FRAMEWORK_VERSION 6.0.2
ENV SELENIUM_LIBRARY_VERSION 6.1.0
ENV SSH_LIBRARY_VERSION 3.8.0
ENV XVFB_VERSION 1.20

ENV AWS_UPLOAD_TO_S3 false

# Install system dependencies
RUN dnf upgrade -y --refresh \
  && dnf install -y \
    chromedriver-${CHROMIUM_VERSION}* \
    chromium-${CHROMIUM_VERSION}* \
    firefox-${FIREFOX_VERSION}* \
    npm \
    nodejs \
    python3-pip \
    tzdata \
    xorg-x11-server-Xvfb-${XVFB_VERSION}* \
  && dnf clean all

# FIXME: below is a workaround, as the path is ignored
RUN mv /usr/lib64/chromium-browser/chromium-browser /usr/lib64/chromium-browser/chromium-browser-original \
  && ln -sfv /opt/robotframework/bin/chromium-browser /usr/lib64/chromium-browser/chromium-browser

# Install Robot Framework and associated libraries
RUN pip3 install \
  --no-cache-dir \
  robotframework==$ROBOT_FRAMEWORK_VERSION \
  robotframework-browser==$BROWSER_LIBRARY_VERSION \
  robotframework-databaselibrary==$DATABASE_LIBRARY_VERSION \
  robotframework-datadriver==$DATADRIVER_VERSION \
  robotframework-datadriver[XLS] \
  robotframework-datetime-tz==$DATETIMETZ_VERSION \
  robotframework-faker==$FAKER_VERSION \
  robotframework-ftplibrary==$FTP_LIBRARY_VERSION \
  robotframework-imaplibrary2==$IMAP_LIBRARY_VERSION \
  robotframework-jsonlibrary==$JSON_LIBRARY_VERSION \
  robotframework-pabot==$PABOT_VERSION \
  robotframework-requests==$REQUESTS_VERSION \
  robotframework-seleniumlibrary==$SELENIUM_LIBRARY_VERSION \
  robotframework-sshlibrary==$SSH_LIBRARY_VERSION \
  axe-selenium-python==$AXE_SELENIUM_LIBRARY_VERSION \
  PyYAML \
  awscli==$AWS_CLI_VERSION

# Gecko drivers
RUN dnf install -y wget \
  && wget -q "https://github.com/mozilla/geckodriver/releases/download/$GECKO_DRIVER_VERSION/geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz" \
  && tar xzf geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz \
  && mkdir -p /opt/robotframework/drivers/ \
  && mv geckodriver /opt/robotframework/drivers/geckodriver \
  && rm geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz \
  && dnf remove -y wget \
  && dnf clean all

# Install the Node dependencies for the Browser library
# FIXME: Playright currently doesn't support relying on system browsers, which is why the `--skip-browsers` parameter cannot be used here.
RUN rfbrowser init

# SSH
# Installation des paquets SSH
RUN dnf install -y openssh-server && dnf clean all && ssh-keygen -A

# Creation of user reachable by SSH
RUN groupadd -g ${ROBOT_GID} robot \
  && useradd -u ${ROBOT_UID} -g ${ROBOT_GID} -s /bin/bash robot \
  && echo "robot:robot" | sudo chpasswd

# Create the default report and work folders with the default user to avoid runtime issues
# These folders are writeable by anyone, to ensure the user can be changed on the command line.
RUN mkdir -p ${ROBOT_REPORTS_DIR} \
  && mkdir -p ${ROBOT_WORK_DIR} \
  && chown ${ROBOT_UID}:${ROBOT_GID} ${ROBOT_REPORTS_DIR} \
  && chown ${ROBOT_UID}:${ROBOT_GID} ${ROBOT_WORK_DIR} \
  && chmod ugo+w ${ROBOT_REPORTS_DIR} ${ROBOT_WORK_DIR}

# Allow any user to write logs
RUN chmod ugo+w /var/log \
  && chown ${ROBOT_UID}:${ROBOT_GID} /var/log

# Update system path
ENV PATH=/opt/robotframework/bin:/opt/robotframework/drivers:$PATH

# Prepare binaries to be executed
COPY bin/chromedriver.sh /opt/robotframework/bin/chromedriver
COPY bin/chromium-browser.sh /opt/robotframework/bin/chromium-browser
COPY bin/run-tests-in-virtual-screen.sh /opt/robotframework/bin/

# Set up a volume for the generated reports
VOLUME ${ROBOT_REPORTS_DIR}

# USER ${ROBOT_UID}:${ROBOT_GID}

# A dedicated work folder to allow for the creation of temporary files
WORKDIR ${ROBOT_WORK_DIR}

# Configuration de l'entrypoint pour exécuter SSH en mode foreground
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
