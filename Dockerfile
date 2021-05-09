FROM haskell

EXPOSE 8835

COPY ./ .

RUN stack setup

RUN stack build

WORKDIR ./

CMD stack run