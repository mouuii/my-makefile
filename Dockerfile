FROM golang:alpine as builder
LABEL maintainer="Mouuii <chaoyueshijian@gmail.com>"

ENV GOPROXY https://goproxy.cn
# ENV GO11MODULE on
# ENV CGO_ENABLE 0
# ENV GOOS linux 
# ENV GOARCH amd64
WORKDIR /go/cache

COPY go.mod .
# COPY go.sum .
RUN go mod download

WORKDIR /go/release
COPY . . 
RUN GOOS=linux CGO_ENABELD=0 go build /go/release/cmd/usdtsrv/srv.go
RUN pwd & ls

FROM alpine:latest as prod
RUN apk --no-cache --no-progress add ca-certificates
COPY --from=builder /go/release/srv /
COPY --from=builder /go/release/config.yaml /
# EXPOSE 8080
CMD ["/srv"]
