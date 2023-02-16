module github.com/timmyyuan/gobench

go 1.13

replace (
	github.com/Sirupsen/logrus v1.7.0 => github.com/sirupsen/logrus v1.7.0
	golang.org/x/sys => golang.org/x/sys v0.0.0-20200826173525-f9321e4c35a6
)

require (
	github.com/containerd/containerd v1.5.18 // indirect
	github.com/docker/docker v17.12.0-ce-rc1.0.20200916142827-bd33bbf0497b+incompatible
	github.com/docker/go-connections v0.4.0 // indirect
	github.com/gorilla/mux v1.8.0 // indirect
	github.com/hashicorp/go-version v1.2.1
	github.com/morikuni/aec v1.0.0 // indirect
	golang.org/x/time v0.0.0-20201208040808-7e3f01d25324 // indirect
	golang.org/x/tools v0.1.5
)
