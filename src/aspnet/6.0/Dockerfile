FROM --platform=$TARGETPLATFORM mcr.microsoft.com/dotnet/aspnet:6.0 AS base

# buildx args
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT
ARG BUILDPLATFORM
ARG BUILDOS
ARG BUILDARCH
ARG BUILDVARIANT

# print buildx default args
RUN case "$TARGETOS" in \
        linux) \
            echo "Running Linux specific commands" \
            # 在这里添加 Linux 特定的命令或脚本 \
            ;; \
        windows) \
            echo "Running Windows specific commands" \
            # 在这里添加 Windows 特定的命令或脚本 \
            ;; \
        *) \
            echo "Unsupported TARGETOS: $TARGETOS" \
            exit 1 \
            ;; \
    esac

# RUN echo "TARGETPLATFORM $TARGETPLATFORM" \
#   && echo "TARGETOS $TARGETOS" \
#   && echo "TARGETARCH $TARGETARCH" \
#   && echo "TARGETVARIANT $TARGETVARIANT" \
#   && echo "BUILDPLATFORM $BUILDPLATFORM" \
#   && echo "BUILDOS $BUILDOS" \
#   && echo "BUILDARCH $BUILDARCH" \
#   && echo "BUILDVARIANT $BUILDVARIANT"