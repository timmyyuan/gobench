FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/cockroachdb/cockroach.git /go/src/github.com/cockroachdb/cockroach

# Update development envirnoment
RUN apt update && apt install -y cmake autoconf bison



WORKDIR /go/src/github.com/cockroachdb/cockroach

# Rollback to the latest bug-free version
RUN git reset --hard dee133c8c3b026492b51dcd7b841d2606f3b7a69

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/cockroachdb/cockroach/bug_patch.diff
RUN git apply github.com/cockroachdb/cockroach/bug_patch.diff

# Pred-build
RUN sed -i '889 i\	\$(xgo) test \$(GOFLAGS) -tags \x27\$(TAGS)\x27 -ldflags \x27\$(LINKFLAGS)\x27 \$(PKG) -c -o /go/gobench.test' Makefile && \
    sed -i '890d' Makefile && \
    mv ./pkg/sql/logictest/testdata/logic_test/alter_table alter_table && \
    rm -rf ./pkg/sql/logictest/testdata/logic_test && \
    mkdir -p ./pkg/sql/logictest/testdata/logic_test && \
    mv alter_table ./pkg/sql/logictest/testdata/logic_test/

# Build
RUN make testrace PKG=./pkg/sql/logictest

# For entrypoint
WORKDIR /go/src/github.com/cockroachdb/cockroach/./pkg/sql/logictest
