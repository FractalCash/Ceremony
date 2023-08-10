FROM rust:slim
RUN apt-get update && \
    apt-get install -y pkg-config libssl-dev git && \
    rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/FractalCash/Ceremony
WORKDIR /Ceremony/phase2
RUN cargo build --release --bin tornado
CMD sh run.sh
