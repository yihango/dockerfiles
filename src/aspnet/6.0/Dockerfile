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
RUN if [ "$TARGETOS" = "linux" ]; then \
    echo "Linux specific commands executed here"; \
elif [ "$TARGETOS" = "windows" ]; then \
    echo "Windows specific commands executed here"; \
else \
    echo "Unsupported TARGETOS: $TARGETOS"; \
    exit 1; \
fi

# RUN echo "TARGETPLATFORM $TARGETPLATFORM" \
#   && echo "TARGETOS $TARGETOS" \
#   && echo "TARGETARCH $TARGETARCH" \
#   && echo "TARGETVARIANT $TARGETVARIANT" \
#   && echo "BUILDPLATFORM $BUILDPLATFORM" \
#   && echo "BUILDOS $BUILDOS" \
#   && echo "BUILDARCH $BUILDARCH" \
#   && echo "BUILDVARIANT $BUILDVARIANT"