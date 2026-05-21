FROM golang:1.23-alpine AS build

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . . 

RUN go build -o worker .


FROM gcr.io/distroless/base-debian12:nonroot AS runtime

WORKDIR /app

COPY --from=build /app/worker .

USER nonroot

CMD ["./worker"]
