FROM google/dart

RUN pub global activate switchX

ENTRYPOINT ["/root/.pub-cache/bin/switchX"]
