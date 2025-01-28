FROM ubuntu:22.04 as base
RUN apt update -q && apt install -y ca-certificates wget && \
    wget -qO /cuda-keyring.deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb && \
    dpkg -i /cuda-keyring.deb && apt update -q

FROM base as build
RUN apt install -y --no-install-recommends cuda-nvcc-12-2
COPY vector_add_grid.cu /app/
RUN /usr/local/cuda-12.2/bin/nvcc /app/vector_add_grid.cu -o /app/vector_add_grid

FROM base
COPY --from=build /app/vector_add_grid /usr/local/bin/
CMD ["sleep", "inf"]