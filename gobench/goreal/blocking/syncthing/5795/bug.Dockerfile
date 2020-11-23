FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/syncthing/syncthing.git /go/src/github.com/syncthing/syncthing




WORKDIR /go/src/github.com/syncthing/syncthing

# Rollback to the latest bug-free version
RUN git reset --hard 02752af86233849746c638f3e8cbbd78cce46878

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/syncthing/syncthing/bug_patch.diff
RUN git apply github.com/syncthing/syncthing/bug_patch.diff


# Build
RUN go test ./lib/protocol -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/github.com/syncthing/syncthing/./lib/protocol
