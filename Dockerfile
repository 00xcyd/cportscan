FROM rust:1.82-slim AS build
WORKDIR /app
COPY . .
RUN apt-get update && apt-get install -y pkg-config libssl-dev && cargo build --release

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=build /app/target/release/cportscan ./cportscan
COPY public ./public
ENV PORT=3000
EXPOSE 3000
CMD ["./cportscan"]
