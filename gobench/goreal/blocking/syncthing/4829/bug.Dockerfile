FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/syncthing/syncthing.git /go/src/github.com/syncthing/syncthing




WORKDIR /go/src/github.com/syncthing/syncthing

# Rollback to the latest bug-free version
RUN git reset --hard e7dc2f91900c9394529190de921c96b3b2d4eb44

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/syncthing/syncthing/bug_patch.diff
RUN git apply github.com/syncthing/syncthing/bug_patch.diff


# Build
RUN go test ./lib/nat -c -o /go/gobench.test

# For entrypoint
WORKDIR /go/src/github.com/syncthing/syncthing/./lib/nat
