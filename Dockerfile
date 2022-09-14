#
# MailHog Dockerfile
#

FROM golang:1.18 as builder

COPY ZscalerRootCertificate-2048-SHA256.crt /usr/local/share/ca-certificates
RUN update-ca-certificates

# Install MailHog:
RUN mkdir -p /root/gocode \
  && export GOPATH=/root/gocode \
  && go install github.com/aguedoptc/MailHog@latest

FROM alpine:3
# Add mailhog user/group with uid/gid 1000.
# This is a workaround for boot2docker issue #581, see
# https://github.com/boot2docker/boot2docker/issues/581
RUN adduser -D -u 1000 mailhog

COPY --from=builder /root/gocode/bin/MailHog /usr/local/bin/

USER mailhog

WORKDIR /home/mailhog

ENTRYPOINT ["MailHog"]

# Expose the SMTP and HTTP ports:
EXPOSE 1025 8025
