#!/bin/bash

REPO_NAME=$1

cd $REPO_NAME

cat > dependency.yml <<EOF
project:
    name: $REPO_NAME

externals:
    CRYSTAL:
        files: defineDirs_docker.pri:defineDirs.pri
EOF

cat > Dockerfile <<EOF
#
# The line below states we will base our new image on the Qt 5.9 image
FROM 192.9.200.190:5000/qt-sintez-base:18.04_w5.9.7 as intermediate
 
#
# Identify the maintainer of an image
LABEL maintainer="eugeniy.maksmov@vniira.spb.su"

USER root
#
# DOWNLOAD REPO
RUN \
    cd /sintez/sintez/build && \
    git clone ssh://git@192.9.200.190:2222/git-server/repos/pivp/main/$REPO_NAME.git

#
# DOWNLOAD CODE FROM SVN
RUN \
    cd /sintez/sintez/build && \
    git clone ssh://git@192.9.200.190:2222/git-server/repos/pivp/crystal/dependency-getter.git && \
    ln -sf dependency-getter/get_dependency.sh get_dependency.sh && \
    ./get_dependency.sh $REPO_NAME/dependency.yml

#
# DOWNLOAD DEPENDENCY BUILDER AND BUILD IT
RUN \
    cd /sintez/sintez/build && \
    git clone ssh://git@192.9.200.190:2222/git-server/repos/pivp/crystal/dependency-builder.git && \
    ln -sf dependency-builder/build_dependency.sh build_dependency.sh && \
    ./build_dependency.sh $REPO_NAME/dependency.yml

# 
# uncomment if depends on xProtoSpecification 
#RUN \
#    rm -rf /sintez/sintez/bin/xProtoSpecification && \
#    mkdir -p /sintez/sintez/bin/xProtoSpecification && \
#    cp -r /sintez/sintez/build/xProtoTools/xProtoSpecification/        /sintez/sintez/bin/xProtoSpecification

#     
# uncomment if depends on asterixSpecification
#RUN \
#    rm -rf /sintez/sintez/bin/asterixSpecification && \
#    mkdir -p /sintez/sintez/bin/asterixSpecification && \
#    cp -r /sintez/sintez/build/asterixTools/asterixSpecification/        /sintez/sintez/bin/asterixSpecification


#
#
# Multi-stage build. Final part
FROM 192.9.200.190:5000/qt-sintez-base:18.04_w5.9.7 as final

USER root
    
#
# COPY RESULTS FROM BUILD IMAGE
COPY --from=intermediate /sintez/sintez/bin/                                          /sintez/sintez/bin/
COPY --from=intermediate /sintez/sintez/lib/                                          /sintez/sintez/lib/

RUN chown -R sintez:sintez /sintez/sintez/  
    
USER sintez
WORKDIR /sintez/sintez/bin

#
# Last is the actual command to start up APP
CMD ["/sintez/sintez/bin/$REPO_NAME"]
EOF
