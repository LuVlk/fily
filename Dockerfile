FROM golang:1.23.2 AS api-builder

WORKDIR /build

COPY ./api/go.mod ./api/go.sum ./
RUN go mod download

COPY ./api ./

RUN CGO_ENABLED=0 GOOS=linux go build -o fily -ldflags="-s -w"

FROM node:20.11.1 AS app-builder

WORKDIR /build

COPY ./app/package*.json ./

RUN npm install

COPY ./app ./

RUN npm run build

FROM alpine:3.20

COPY --from=api-builder /build/fily /fily
COPY --from=app-builder /build/dist /app/dist

EXPOSE 8080

# Run
CMD ["/fily"]