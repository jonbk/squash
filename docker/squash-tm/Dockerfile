ARG SQUASH_TM_VERSION=4.1.0
ARG SQUASH_SCM_VERSION=4.0.0

FROM squashtest/squash-tm:${SQUASH_TM_VERSION}

ARG SQUASH_TM_VERSION=4.1.0
ARG SQUASH_SCM_VERSION=4.0.0

RUN wget https://nexus.squashtest.org/nexus/repository/public-releases/tm/plugin/autom/squashautom/${SQUASH_TM_VERSION}.RELEASE/plugin.testautomation.squashautom.community-${SQUASH_TM_VERSION}.RELEASE.tar.gz -P /tmp \
    && tar -zxf /tmp/plugin.testautomation.squashautom.community-${SQUASH_TM_VERSION}.RELEASE.tar.gz -C /tmp \
    && mv /tmp/plugin.testautomation.squashautom.community-${SQUASH_TM_VERSION}.RELEASE/plugins/* /opt/squash-tm/plugins \
    && rm -rf /tmp/plugin.testautomation.squashautom.community-${SQUASH_TM_VERSION}.RELEASE /tmp/plugin.testautomation.squashautom.community-${SQUASH_TM_VERSION}.RELEASE.tar.gz \
    && wget https://nexus.squashtest.org/nexus/repository/public-releases/tm/plugin/autom/scm-git/${SQUASH_SCM_VERSION}.RELEASE/plugin.scm.git-${SQUASH_SCM_VERSION}.RELEASE.tar.gz -P /tmp \
    && tar -zxf /tmp/plugin.scm.git-${SQUASH_SCM_VERSION}.RELEASE.tar.gz -C /tmp \
    && mv /tmp/plugin.scm.git-${SQUASH_SCM_VERSION}.RELEASE/plugins/* /opt/squash-tm/plugins \
    && rm -rf /tmp/plugin.scm.git--${SQUASH_SCM_VERSION}.RELEASE /tmp/plugin.scm.git-${SQUASH_SCM_VERSION}.RELEASE.tar.gz \
    ;