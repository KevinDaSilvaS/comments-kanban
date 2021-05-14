FROM haskell as base

COPY ./ .

RUN stack setup

RUN stack build

WORKDIR ./

COPY . .

FROM debian

RUN apt update

RUN apt-get install build-essential -y

RUN apt-get install manpages-dev

EXPOSE 8835

COPY --from=base .stack-work/install/x86_64-linux-tinfo6/*/8.10.4/bin/ .

CMD ./comments-kanban-exe