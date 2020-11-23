FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/cockroachdb/cockroach.git /go/src/github.com/cockroachdb/cockroach

# Install package dependencies
RUN apt-get update && \
	apt-get install -y cmake autoconf bison vim python3

# Clone git porject dependencies


# Get go package dependencies


# Checkout the fixed version of this bug
WORKDIR /go/src/github.com/cockroachdb/cockroach
RUN git reset --hard dee133c8c3b026492b51dcd7b841d2606f3b7a69




RUN sed -i '889 i\	\$(xgo) test \$(GOFLAGS) -tags \x27\$(TAGS)\x27 -ldflags \x27\$(LINKFLAGS)\x27 \$(PKG) -c -o /go/gobench.test' Makefile && \
	sed -i '890d' Makefile && \
	mv ./pkg/sql/logictest/testdata/logic_test/alter_table alter_table && \
	rm -rf ./pkg/sql/logictest/testdata/logic_test && \
	mkdir -p ./pkg/sql/logictest/testdata/logic_test && \
	mv alter_table ./pkg/sql/logictest/testdata/logic_test/ && \
	make testrace PKG=./pkg/sql/logictest