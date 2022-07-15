FROM alpine:3.12.10

COPY entrypoint.sh /entrypoint.sh
COPY prod_version_bump.sh /prod_version_bump.sh
COPY merge.sh /merge.sh
COPY createpr.sh /createpr.sh
COPY get-changelog.sh /get-changelog.sh
COPY get-app-version.sh /get-app-version.sh
COPY get_ids.py /get_ids.py
COPY delete_old_packages.py /delete_old_packages.py
COPY delete_versions.py /delete_versions.py
COPY delete_package_bump.sh /delete_package_bump.sh

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add --no-cache \
    hub \
    git \
    gawk \
    python3 \
    py3-pip
RUN pip3 install requests

ENTRYPOINT ["/entrypoint.sh"]
